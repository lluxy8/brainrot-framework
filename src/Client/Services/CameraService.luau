--!strict

local TweenService = game:GetService("TweenService")

local CameraService = {}
CameraService.__index = CameraService

export type CameraService = typeof(setmetatable(
	{} :: {
		_started: boolean,
		_lastTween: Tween?,
	},
	CameraService
))

function CameraService.new(): CameraService
	local self = setmetatable({
		_started = false,
		_lastTween = nil,
	}, CameraService)

	return self
end

function CameraService:Start()
	self._started = true
end

function CameraService:FocusOn(cframeTarget: CFrame, durationSeconds: number?)
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end

	local tweenDuration = durationSeconds or 0.4
	local tween = TweenService:Create(camera, TweenInfo.new(tweenDuration), {
		CFrame = cframeTarget,
	})

	self._lastTween = tween
	tween:Play()
end

function CameraService:CancelFocusTween()
	if self._lastTween then
		self._lastTween:Cancel()
		self._lastTween = nil
	end
end

return CameraService
