--!strict

local Types = {}

export type StringMap<T> = { [string]: T }
export type NumberMap<T> = { [number]: T }
export type Result<T> = {
	ok: boolean,
	value: T?,
	error: string?,
}

return Types
