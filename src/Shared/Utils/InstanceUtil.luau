--!strict

local InstanceUtil = {}

function InstanceUtil.GetOrCreateFolder(parent: Instance, name: string): Folder
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("Folder") then
		return existing
	end

	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

function InstanceUtil.GetOrCreateAttachment(parent: BasePart, name: string): Attachment
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("Attachment") then
		return existing
	end

	local attachment = Instance.new("Attachment")
	attachment.Name = name
	attachment.Parent = parent
	return attachment
end

function InstanceUtil.SafeDestroy(instance: Instance?)
	if instance and instance.Parent then
		instance:Destroy()
	end
end

return InstanceUtil
