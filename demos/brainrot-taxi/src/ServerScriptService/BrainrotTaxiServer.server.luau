--!strict

local Workspace = game:GetService("Workspace")

local DEMO_ROOT_NAME = "BrainrotTaxiDemo"

local function makeStation(
	parent: Instance,
	name: string,
	position: Vector3,
	partColor: Color3,
	actionText: string,
	objectText: string
): ProximityPrompt
	local station = Instance.new("Part")
	station.Name = name
	station.Size = Vector3.new(10, 1, 10)
	station.Anchored = true
	station.Position = position
	station.Color = partColor
	station.TopSurface = Enum.SurfaceType.Smooth
	station.BottomSurface = Enum.SurfaceType.Smooth
	station.Parent = parent

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "Prompt"
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 10
	prompt.RequiresLineOfSight = false
	prompt.Parent = station

	return prompt
end

local function makeSpawn(parent: Instance)
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "DemoSpawn"
	spawn.Size = Vector3.new(8, 1, 8)
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Position = Vector3.new(-20, 3, 0)
	spawn.Parent = parent
end

local function ensureDemoWorld()
	local previous = Workspace:FindFirstChild(DEMO_ROOT_NAME)
	if previous then
		previous:Destroy()
	end

	local root = Instance.new("Model")
	root.Name = DEMO_ROOT_NAME
	root.Parent = Workspace

	makeSpawn(root)
	makeStation(
		root,
		"WashTaxiStation",
		Vector3.new(0, 3, 0),
		Color3.fromRGB(75, 176, 255),
		"Wash Taxi",
		"Taxi Wash Bay"
	)
	makeStation(
		root,
		"DropoffStation",
		Vector3.new(18, 3, 0),
		Color3.fromRGB(120, 255, 140),
		"Drop Passenger",
		"Downtown Dropoff"
	)
end

ensureDemoWorld()

local frameworkServerRoot = script.Parent:WaitForChild("BrainrotFrameworkServer")
local registerServices = require(frameworkServerRoot.Bootstrap.RegisterServices)
local registerComponents = require(frameworkServerRoot.Bootstrap.RegisterComponents)
local services = registerServices()
registerComponents(services)
