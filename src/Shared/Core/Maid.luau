--!strict

export type CleanupTask =
	RBXScriptConnection
	| Instance
	| (() -> ())
	| { Destroy: ((self: any) -> ())? }
	| { Disconnect: ((self: any) -> ())? }

local Maid = {}
Maid.__index = Maid

export type Maid = typeof(setmetatable({} :: { _tasks: { CleanupTask } }, Maid))

local function cleanupTask(taskObject: CleanupTask)
	local taskType = typeof(taskObject)
	if taskType == "RBXScriptConnection" then
		(taskObject :: RBXScriptConnection):Disconnect()
		return
	end

	if taskType == "Instance" then
		(taskObject :: Instance):Destroy()
		return
	end

	if taskType == "function" then
		(taskObject :: () -> ())()
		return
	end

	if taskType == "table" then
		local taskTable = taskObject :: any
		if type(taskTable.Destroy) == "function" then
			taskTable:Destroy()
			return
		end

		if type(taskTable.Disconnect) == "function" then
			taskTable:Disconnect()
		end
	end
end

function Maid.new(): Maid
	local self = setmetatable({
		_tasks = {},
	}, Maid)

	return self
end

function Maid:GiveTask(taskObject: CleanupTask): CleanupTask
	table.insert(self._tasks, taskObject)
	return taskObject
end

function Maid:DoCleaning()
	for index = #self._tasks, 1, -1 do
		local taskObject = self._tasks[index]
		cleanupTask(taskObject)
		self._tasks[index] = nil
	end
end

function Maid:Destroy()
	self:DoCleaning()
end

return Maid
