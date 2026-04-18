--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local AssetConfig = require(Shared.Config.AssetConfig)

local ARROW_COLOR = Color3.fromRGB(255, 220, 90)
local ORIGIN_HEIGHT_OFFSET = Vector3.new(0, -2.2, 0)
local MIN_GUIDE_DISTANCE = 6
local MAX_MARKERS = 24
local MARKER_SPACING = 9
local MARKER_SIZE = Vector3.new(2.8, 0.08, 2.8)
local MARKER_VISIBLE_TRANSPARENCY = 0.2
local MARKER_HIDDEN_TRANSPARENCY = 1
local MARKER_DECAL_VISIBLE_TRANSPARENCY = 0.15
local MARKER_DECAL_HIDDEN_TRANSPARENCY = 1
local GROUND_CAST_START_HEIGHT = 30
local GROUND_CAST_DEPTH = 150
local GROUND_OFFSET = 0.05

type Marker = {
	part: Part,
	decal: Decal,
	hasTexture: boolean,
}

local GuidePathComponent = {}
GuidePathComponent.__index = GuidePathComponent

export type GuidePathComponent = typeof(setmetatable(
	{} :: {
		_player: Player,
		_targetInstance: Instance?,
		_targetPosition: Vector3?,
		_markers: { Marker },
		_markerFolder: Folder,
		_renderConnection: RBXScriptConnection?,
		_started: boolean,
		_raycastParams: RaycastParams,
		_arrowTexture: string,
	},
	GuidePathComponent
))

local function resolveArrowTexture(): string
	if type(AssetConfig) ~= "table" then
		return ""
	end

	local decals = AssetConfig.Decals
	if type(decals) ~= "table" then
		return ""
	end

	local texture = decals.GuideArrow
	if type(texture) ~= "string" then
		return ""
	end

	return texture
end

local function createMarker(parent: Instance, arrowTexture: string): Marker
	local part = Instance.new("Part")
	part.Name = "GuideArrowMarker"
	part.Size = MARKER_SIZE
	part.Anchored = true
	part.Material = Enum.Material.Neon
	part.Color = ARROW_COLOR
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Transparency = MARKER_HIDDEN_TRANSPARENCY
	part.Parent = parent

	local decal = Instance.new("Decal")
	decal.Name = "GuideArrowDecal"
	decal.Face = Enum.NormalId.Top
	decal.Color3 = ARROW_COLOR
	decal.Transparency = MARKER_DECAL_HIDDEN_TRANSPARENCY
	decal.Texture = arrowTexture
	decal.Parent = part

	return {
		part = part,
		decal = decal,
		hasTexture = arrowTexture ~= "",
	}
end

local function resolveTargetPosition(target: Instance?): Vector3?
	if not target then
		return nil
	end

	if not target.Parent then
		return nil
	end

	if target:IsA("Attachment") then
		return target.WorldPosition
	end

	if target:IsA("PVInstance") then
		return target:GetPivot().Position
	end

	return nil
end

function GuidePathComponent.new(): GuidePathComponent
	local markerFolder = Instance.new("Folder")
	markerFolder.Name = "BrainrotGuidePath"
	markerFolder.Parent = Workspace

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true

	local self = setmetatable({
		_player = Players.LocalPlayer,
		_targetInstance = nil,
		_targetPosition = nil,
		_markers = {},
		_markerFolder = markerFolder,
		_renderConnection = nil,
		_started = false,
		_raycastParams = raycastParams,
		_arrowTexture = resolveArrowTexture(),
	}, GuidePathComponent)

	return self
end

function GuidePathComponent:_updateRaycastFilter()
	local exclude = { self._markerFolder }
	local character = self._player.Character
	if character then
		table.insert(exclude, character)
	end

	self._raycastParams.FilterDescendantsInstances = exclude
end

function GuidePathComponent:_projectToGround(position: Vector3): Vector3
	self:_updateRaycastFilter()

	local castOrigin = position + Vector3.new(0, GROUND_CAST_START_HEIGHT, 0)
	local result = Workspace:Raycast(
		castOrigin,
		Vector3.new(0, -(GROUND_CAST_START_HEIGHT + GROUND_CAST_DEPTH), 0),
		self._raycastParams
	)
	if result then
		return result.Position + Vector3.new(0, GROUND_OFFSET, 0)
	end

	return position
end

function GuidePathComponent:_getOriginPosition(): Vector3?
	local character = self._player.Character
	if not character then
		return nil
	end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart or not rootPart:IsA("BasePart") then
		return nil
	end

	return rootPart.Position + ORIGIN_HEIGHT_OFFSET
end

function GuidePathComponent:_getDestinationPosition(): Vector3?
	if self._targetPosition then
		return self._targetPosition
	end

	return resolveTargetPosition(self._targetInstance)
end

function GuidePathComponent:_setVisibleCount(visibleCount: number)
	for index, marker in ipairs(self._markers) do
		if index <= visibleCount then
			marker.part.Transparency = MARKER_VISIBLE_TRANSPARENCY
			if marker.hasTexture then
				marker.decal.Transparency = MARKER_DECAL_VISIBLE_TRANSPARENCY
			else
				marker.decal.Transparency = MARKER_DECAL_HIDDEN_TRANSPARENCY
			end
		else
			marker.part.Transparency = MARKER_HIDDEN_TRANSPARENCY
			marker.decal.Transparency = MARKER_DECAL_HIDDEN_TRANSPARENCY
		end
	end
end

function GuidePathComponent:_ensureMarkerCount(count: number)
	while #self._markers < count do
		table.insert(self._markers, createMarker(self._markerFolder, self._arrowTexture))
	end
end

function GuidePathComponent:_updateMarkers()
	local origin = self:_getOriginPosition()
	local destination = self:_getDestinationPosition()
	if not origin or not destination then
		self:_setVisibleCount(0)
		return
	end

	local flatOffset = Vector3.new(destination.X - origin.X, 0, destination.Z - origin.Z)
	local distance = flatOffset.Magnitude
	if distance < MIN_GUIDE_DISTANCE then
		self:_setVisibleCount(0)
		return
	end

	local markerCount = math.clamp(math.floor(distance / MARKER_SPACING), 1, MAX_MARKERS)
	self:_ensureMarkerCount(markerCount)

	local direction = flatOffset.Unit
	local stepDistance = distance / (markerCount + 1)

	for index = 1, markerCount do
		local marker = self._markers[index]
		local markerDistance = stepDistance * index
		local samplePosition = origin + direction * markerDistance
		local markerPosition = self:_projectToGround(samplePosition)
		marker.part.CFrame = CFrame.lookAt(markerPosition, markerPosition + direction, Vector3.yAxis)
	end

	self:_setVisibleCount(markerCount)
end

function GuidePathComponent:Start()
	if self._started then
		return
	end

	self._started = true
	self._renderConnection = RunService.RenderStepped:Connect(function()
		self:_updateMarkers()
	end)
end

function GuidePathComponent:SetTarget(target: Instance?)
	self._targetInstance = target
	self._targetPosition = nil
end

function GuidePathComponent:SetTargetPosition(position: Vector3?)
	self._targetPosition = position
	self._targetInstance = nil
end

function GuidePathComponent:ClearTarget()
	self._targetInstance = nil
	self._targetPosition = nil
	self:_setVisibleCount(0)
end

function GuidePathComponent:Destroy()
	if self._renderConnection then
		self._renderConnection:Disconnect()
		self._renderConnection = nil
	end

	for _, marker in ipairs(self._markers) do
		marker.part:Destroy()
	end
	table.clear(self._markers)

	self._markerFolder:Destroy()
end

return GuidePathComponent
