--!strict

local TaskState = {
	Idle = "Idle",
	InProgress = "InProgress",
	Completed = "Completed",
}

return table.freeze(TaskState)
