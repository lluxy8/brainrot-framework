--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local QuestDefinitionModule = require(Shared.Gameplay.Quest.QuestDefinition)
local Signal = require(Shared.Core.Signal)
type QuestDefinition = QuestDefinitionModule.QuestDefinition
local ObjectiveDefinitionModule = require(Shared.Gameplay.Quest.ObjectiveDefinition)
type ObjectiveDefinition = ObjectiveDefinitionModule.ObjectiveDefinition

export type QuestProgressPayload = {
	questId: string,
	objectiveId: string,
	progress: number,
	requiredCount: number,
}

local QuestService = {}
QuestService.__index = QuestService

export type QuestService = typeof(setmetatable(
	{} :: {
		_dataService: any,
		_taskService: any,
		_quests: { [string]: QuestDefinition },
		_started: boolean,
		QuestProgressed: Signal.Signal,
		QuestCompleted: Signal.Signal,
	},
	QuestService
))

function QuestService.new(dataService: any, taskService: any): QuestService
	local self = setmetatable({
		_dataService = dataService,
		_taskService = taskService,
		_quests = QuestDefinitionModule.GetAll(),
		_started = false,
		QuestProgressed = Signal.new(),
		QuestCompleted = Signal.new(),
	}, QuestService)

	return self
end

function QuestService:Start()
	if self._started then
		return
	end

	self._started = true
	self._taskService.TaskCompleted:Connect(function(player: Player, completionResult: any)
		self:_onTaskCompleted(player, completionResult.taskId)
	end)
end

function QuestService:_allObjectivesComplete(
	player: Player,
	questId: string,
	objectives: { ObjectiveDefinition }
): boolean
	for _, objective in ipairs(objectives) do
		local progress = self._dataService:GetQuestObjectiveProgress(player, questId, objective.id)
		if progress < objective.requiredCount then
			return false
		end
	end

	return true
end

function QuestService:_onTaskCompleted(player: Player, taskId: string)
	for questId, quest in pairs(self._quests) do
		if self._dataService:IsQuestCompleted(player, questId) then
			continue
		end

		local changed = false
		for _, objective in ipairs(quest.objectives) do
			if objective.taskId == taskId then
				local current =
					self._dataService:GetQuestObjectiveProgress(player, questId, objective.id)
				local nextProgress = math.min(current + 1, objective.requiredCount)
				self._dataService:SetQuestObjectiveProgress(
					player,
					questId,
					objective.id,
					nextProgress
				)
				changed = true

				self.QuestProgressed:Fire(
					player,
					{
						questId = questId,
						objectiveId = objective.id,
						progress = nextProgress,
						requiredCount = objective.requiredCount,
					} :: QuestProgressPayload
				)
			end
		end

		if changed and self:_allObjectivesComplete(player, questId, quest.objectives) then
			self._dataService:SetQuestCompleted(player, questId, true)
			self.QuestCompleted:Fire(player, questId)
		end
	end
end

function QuestService:GetQuestProgress(player: Player, questId: string): { [string]: number }
	return self._dataService:GetQuestProgress(player, questId)
end

function QuestService:IsQuestCompleted(player: Player, questId: string): boolean
	return self._dataService:IsQuestCompleted(player, questId)
end

function QuestService:GetAllQuests(): { [string]: QuestDefinition }
	return self._quests
end

return QuestService
