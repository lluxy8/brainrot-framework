--!strict

local SoundService = game:GetService("SoundService")

local AudioService = {}
AudioService.__index = AudioService

export type AudioService = typeof(setmetatable(
	{} :: {
		_started: boolean,
	},
	AudioService
))

function AudioService.new(): AudioService
	local self = setmetatable({
		_started = false,
	}, AudioService)

	return self
end

function AudioService:Start()
	self._started = true
end

function AudioService:Play2D(soundId: string, volume: number?, playbackSpeed: number?)
	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = volume or 0.6
	sound.PlaybackSpeed = playbackSpeed or 1
	sound.RollOffMode = Enum.RollOffMode.InverseTapered
	sound.Parent = SoundService

	sound.Ended:Connect(function()
		sound:Destroy()
	end)
	sound:Play()
end

return AudioService
