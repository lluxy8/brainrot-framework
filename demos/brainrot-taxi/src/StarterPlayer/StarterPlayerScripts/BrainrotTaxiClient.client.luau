--!strict

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local DEMO_ROOT_NAME = "BrainrotTaxiDemo"
local WASH_TASK_ID = "WashCar"
local SERVE_TASK_ID = "ServeCustomer"

local function createDemoHud()
	local playerGui = player:WaitForChild("PlayerGui")
	local existingGui = playerGui:FindFirstChild("BrainrotTaxiHUD")
	if existingGui and existingGui:IsA("ScreenGui") then
		return existingGui
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BrainrotTaxiHUD"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Name = "Panel"
	frame.Size = UDim2.fromOffset(330, 120)
	frame.Position = UDim2.fromOffset(16, 16)
	frame.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
	frame.BackgroundTransparency = 0.2
	frame.Parent = screenGui

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextSize = 18
	label.Font = Enum.Font.GothamBold
	label.TextWrapped = true
	label.Parent = frame

	return screenGui
end

local function updateHud(screenGui: ScreenGui)
	local panel = screenGui:WaitForChild("Panel")
	local label = panel:WaitForChild("Text") :: TextLabel
	local coins = player:GetAttribute("Brainrot_Coins") or 0
	local lastTask = player:GetAttribute("Brainrot_LastTaskId") or "None"
	local lastReward = player:GetAttribute("Brainrot_LastRewardAmount") or 0

	label.Text = string.format(
		"My Brainrot Taxi Demo\nCoins: %d\nLast Task: %s (+%d)\nUse prompts or press E near a station.",
		coins,
		tostring(lastTask),
		lastReward
	)
end

local function bindPrompt(
	promptComponent: any,
	root: Model,
	stationName: string,
	interactionId: string
)
	local station = root:WaitForChild(stationName)
	local prompt = station:WaitForChild("Prompt") :: ProximityPrompt
	promptComponent:BindPrompt(prompt, interactionId)
end

local function bootstrap()
	local frameworkClientRoot = script.Parent:WaitForChild("BrainrotFrameworkClient")
	local registerControllers = require(frameworkClientRoot.Bootstrap.RegisterControllers)
	local registry = registerControllers()
	local promptComponent = registry:Resolve("InteractionPromptComponent")
	local feedbackService = registry:Resolve("FeedbackService")
	local guidePathComponent = registry:Resolve("GuidePathComponent")

	local root = Workspace:WaitForChild(DEMO_ROOT_NAME) :: Model
	local washStation = root:WaitForChild("WashTaxiStation")
	local dropoffStation = root:WaitForChild("DropoffStation")
	bindPrompt(promptComponent, root, "WashTaxiStation", "WashCarInteract")
	bindPrompt(promptComponent, root, "DropoffStation", "ServeCustomerInteract")
	guidePathComponent:SetTarget(washStation)

	local screenGui = createDemoHud()
	updateHud(screenGui)
	player:GetAttributeChangedSignal("Brainrot_Coins"):Connect(function()
		updateHud(screenGui)
	end)
	player:GetAttributeChangedSignal("Brainrot_LastTaskId"):Connect(function()
		updateHud(screenGui)
	end)
	player:GetAttributeChangedSignal("Brainrot_LastRewardAmount"):Connect(function()
		updateHud(screenGui)
	end)

	feedbackService.TaskCompletedReceived:Connect(function(payload: any)
		if type(payload) ~= "table" or type(payload.taskId) ~= "string" then
			return
		end

		if payload.taskId == WASH_TASK_ID then
			guidePathComponent:SetTarget(dropoffStation)
		elseif payload.taskId == SERVE_TASK_ID then
			guidePathComponent:SetTarget(washStation)
		end
	end)
end

bootstrap()
