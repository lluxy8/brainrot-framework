--!strict

type Listener = {
	callback: (...any) -> (),
	once: boolean,
}

export type Connection = {
	Connected: boolean,
	Disconnect: (self: Connection) -> (),
}

type SignalData = {
	_listeners: { [number]: Listener },
	_nextId: number,
}

local Signal = {}
Signal.__index = Signal

export type Signal = typeof(setmetatable({} :: SignalData, Signal))

local function createConnection(signal: Signal, id: number): Connection
	local connection = {
		Connected = true,
	} :: Connection

	function connection:Disconnect()
		if not self.Connected then
			return
		end

		self.Connected = false
		signal._listeners[id] = nil
	end

	return connection
end

function Signal.new(): Signal
	local self = setmetatable({
		_listeners = {},
		_nextId = 0,
	}, Signal)

	return self
end

function Signal:Connect(callback: (...any) -> ()): Connection
	self._nextId += 1
	local id = self._nextId

	self._listeners[id] = {
		callback = callback,
		once = false,
	}

	return createConnection(self, id)
end

function Signal:Once(callback: (...any) -> ()): Connection
	self._nextId += 1
	local id = self._nextId

	self._listeners[id] = {
		callback = callback,
		once = true,
	}

	return createConnection(self, id)
end

function Signal:Fire(...: any)
	local args = table.pack(...)
	for id, listener in pairs(self._listeners) do
		task.spawn(listener.callback, table.unpack(args, 1, args.n))
		if listener.once then
			self._listeners[id] = nil
		end
	end
end

function Signal:Wait(): ...any
	local thread = coroutine.running()
	assert(thread ~= nil, "Signal:Wait must be called from within a coroutine")

	local connection: Connection?
	connection = self:Connect(function(...: any)
		local activeConnection = connection
		if activeConnection then
			activeConnection:Disconnect()
		end

		task.spawn(thread :: thread, ...)
	end)

	return coroutine.yield()
end

function Signal:DisconnectAll()
	table.clear(self._listeners)
end

function Signal:Destroy()
	self:DisconnectAll()
end

return Signal
