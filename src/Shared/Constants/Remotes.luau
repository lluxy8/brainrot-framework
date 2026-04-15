--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteNames = require(script.Parent.Parent.Net.RemoteNames)

local Remotes = {}

function Remotes.GetRoot(): Instance
	return ReplicatedStorage:WaitForChild("BrainrotFramework")
end

function Remotes.WaitForFolder(timeoutSeconds: number?): Folder
	local root = Remotes.GetRoot()
	local folder = if timeoutSeconds
		then root:WaitForChild("Remotes", timeoutSeconds)
		else root:WaitForChild("Remotes")

	assert(folder and folder:IsA("Folder"), "BrainrotFramework.Remotes folder is missing")
	return folder
end

function Remotes.EnsureFolder(): Folder
	local root = Remotes.GetRoot()
	local folder = root:FindFirstChild("Remotes")
	if folder and folder:IsA("Folder") then
		return folder
	end

	local newFolder = Instance.new("Folder")
	newFolder.Name = "Remotes"
	newFolder.Parent = root
	return newFolder
end

function Remotes.WaitForEvent(remoteName: string, timeoutSeconds: number?): RemoteEvent
	local folder = Remotes.WaitForFolder(timeoutSeconds)
	local remote = if timeoutSeconds
		then folder:WaitForChild(remoteName, timeoutSeconds)
		else folder:WaitForChild(remoteName)

	assert(remote and remote:IsA("RemoteEvent"), ("RemoteEvent '%s' is missing"):format(remoteName))
	return remote
end

function Remotes.EnsureEvent(remoteName: string): RemoteEvent
	local folder = Remotes.EnsureFolder()
	local existing = folder:FindFirstChild(remoteName)
	if existing and existing:IsA("RemoteEvent") then
		return existing
	end

	local remote = Instance.new("RemoteEvent")
	remote.Name = remoteName
	remote.Parent = folder
	return remote
end

function Remotes.EnsureAllEvents(): { [string]: RemoteEvent }
	local map: { [string]: RemoteEvent } = {}
	for _, remoteName in pairs(RemoteNames) do
		map[remoteName] = Remotes.EnsureEvent(remoteName)
	end

	return map
end

return Remotes
