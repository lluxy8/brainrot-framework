--!strict

local HighlightComponent = {}
HighlightComponent.__index = HighlightComponent

export type HighlightComponent = typeof(setmetatable(
	{} :: {
		_highlight: Highlight?,
	},
	HighlightComponent
))

function HighlightComponent.new(): HighlightComponent
	local self = setmetatable({
		_highlight = nil,
	}, HighlightComponent)

	return self
end

function HighlightComponent:Start()
	-- Intentionally empty. Call SetTarget from game-specific scripts.
end

function HighlightComponent:SetTarget(target: Instance?)
	if not target then
		if self._highlight then
			self._highlight:Destroy()
			self._highlight = nil
		end
		return
	end

	if not self._highlight then
		local highlight = Instance.new("Highlight")
		highlight.FillTransparency = 0.75
		highlight.OutlineTransparency = 0.2
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		self._highlight = highlight
	end

	self._highlight.Adornee = target
	self._highlight.Parent = target
end

return HighlightComponent
