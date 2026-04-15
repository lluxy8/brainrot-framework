--!strict

local StationState = {
	Idle = "Idle",
	Reserved = "Reserved",
	InUse = "InUse",
}

return table.freeze(StationState)
