--!strict

local StringUtil = {}

function StringUtil.Trim(value: string): string
	return string.match(value, "^%s*(.-)%s*$") or ""
end

function StringUtil.StartsWith(value: string, prefix: string): boolean
	return string.sub(value, 1, #prefix) == prefix
end

function StringUtil.EndsWith(value: string, suffix: string): boolean
	if suffix == "" then
		return true
	end

	return string.sub(value, -#suffix) == suffix
end

function StringUtil.IsBlank(value: string): boolean
	return StringUtil.Trim(value) == ""
end

function StringUtil.Join(parts: { string }, separator: string?): string
	return table.concat(parts, separator or "")
end

return StringUtil
