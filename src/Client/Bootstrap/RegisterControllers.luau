--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Registry = require(Shared.Core.Registry)

local AudioService = require(script.Parent.Parent.Services.AudioService)
local CameraService = require(script.Parent.Parent.Services.CameraService)
local FeedbackService = require(script.Parent.Parent.Services.FeedbackService)
local FloatingRewardComponent = require(script.Parent.Parent.Components.FloatingRewardComponent)
local HUDController = require(script.Parent.Parent.Controllers.HUDController)
local HighlightComponent = require(script.Parent.Parent.Components.HighlightComponent)
local InputService = require(script.Parent.Parent.Services.InputService)
local InteractionPromptComponent =
	require(script.Parent.Parent.Components.InteractionPromptComponent)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local ProgressBarController = require(script.Parent.Parent.Controllers.ProgressBarController)
local PromptController = require(script.Parent.Parent.Controllers.PromptController)
local ShopController = require(script.Parent.Parent.Controllers.ShopController)
local TaskProgressComponent = require(script.Parent.Parent.Components.TaskProgressComponent)
local UpgradeController = require(script.Parent.Parent.Controllers.UpgradeController)

local activeRegistry: Registry.Registry? = nil

local function startIfPresent(target: any)
	if type(target.Start) == "function" then
		target:Start()
	end
end

local function registerControllers()
	if activeRegistry then
		return activeRegistry
	end

	local registry = Registry.new()

	local feedbackService = FeedbackService.new()
	local inputService = InputService.new()
	local cameraService = CameraService.new()
	local audioService = AudioService.new()

	local promptController = PromptController.new(feedbackService, inputService)
	local notificationController = NotificationController.new(feedbackService)
	local hudController = HUDController.new(feedbackService)
	local progressBarController = ProgressBarController.new(feedbackService)
	local shopController = ShopController.new(feedbackService)
	local upgradeController = UpgradeController.new(feedbackService)

	local interactionPromptComponent = InteractionPromptComponent.new(promptController)
	local taskProgressComponent = TaskProgressComponent.new(feedbackService)
	local floatingRewardComponent = FloatingRewardComponent.new(feedbackService, audioService)
	local highlightComponent = HighlightComponent.new()

	registry:Register("FeedbackService", feedbackService)
	registry:Register("InputService", inputService)
	registry:Register("CameraService", cameraService)
	registry:Register("AudioService", audioService)
	registry:Register("PromptController", promptController)
	registry:Register("NotificationController", notificationController)
	registry:Register("HUDController", hudController)
	registry:Register("ProgressBarController", progressBarController)
	registry:Register("ShopController", shopController)
	registry:Register("UpgradeController", upgradeController)
	registry:Register("InteractionPromptComponent", interactionPromptComponent)
	registry:Register("TaskProgressComponent", taskProgressComponent)
	registry:Register("FloatingRewardComponent", floatingRewardComponent)
	registry:Register("HighlightComponent", highlightComponent)

	startIfPresent(feedbackService)
	startIfPresent(inputService)
	startIfPresent(cameraService)
	startIfPresent(audioService)
	startIfPresent(promptController)
	startIfPresent(notificationController)
	startIfPresent(hudController)
	startIfPresent(progressBarController)
	startIfPresent(shopController)
	startIfPresent(upgradeController)
	startIfPresent(interactionPromptComponent)
	startIfPresent(taskProgressComponent)
	startIfPresent(floatingRewardComponent)
	startIfPresent(highlightComponent)

	feedbackService:RequestSnapshot()

	activeRegistry = registry
	return registry
end

return registerControllers
