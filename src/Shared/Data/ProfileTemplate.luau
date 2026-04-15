--!strict

local Currency = require(script.Parent.Parent.Constants.Currency)
local DataVersion = require(script.Parent.DataVersion)

export type Profile = {
	version: number,
	economy: { [string]: number },
	tasks: {
		completedCounts: { [string]: number },
	},
	inventory: {
		items: { [string]: number },
	},
	upgrades: {
		levels: { [string]: number },
	},
	zones: {
		unlocked: { [string]: boolean },
	},
	quests: {
		progress: { [string]: { [string]: number } },
		completed: { [string]: boolean },
	},
}

local template: Profile = {
	version = DataVersion,
	economy = {
		[Currency.Coins] = 0,
	},
	tasks = {
		completedCounts = {},
	},
	inventory = {
		items = {},
	},
	upgrades = {
		levels = {},
	},
	zones = {
		unlocked = {},
	},
	quests = {
		progress = {},
		completed = {},
	},
}

local ProfileTemplate = {}

function ProfileTemplate.Create(): Profile
	return {
		version = template.version,
		economy = {
			[Currency.Coins] = template.economy[Currency.Coins],
		},
		tasks = {
			completedCounts = {},
		},
		inventory = {
			items = {},
		},
		upgrades = {
			levels = {},
		},
		zones = {
			unlocked = {},
		},
		quests = {
			progress = {},
			completed = {},
		},
	}
end

ProfileTemplate.Template = template

return ProfileTemplate
