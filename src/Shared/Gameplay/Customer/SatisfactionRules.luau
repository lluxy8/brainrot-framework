--!strict

local SatisfactionRules = {}

function SatisfactionRules.CalculateScore(
	waitSeconds: number,
	maxPatienceSeconds: number,
	mistakes: number
): number
	local patienceRatio = 1 - math.clamp(waitSeconds / math.max(maxPatienceSeconds, 1), 0, 1)
	local mistakePenalty = math.max(0, mistakes) * 0.15
	local raw = (patienceRatio - mistakePenalty) * 100
	return math.clamp(math.floor(raw + 0.5), 0, 100)
end

function SatisfactionRules.GetTier(score: number): string
	if score >= 90 then
		return "Perfect"
	end
	if score >= 70 then
		return "Good"
	end
	if score >= 45 then
		return "Okay"
	end
	return "Bad"
end

return SatisfactionRules
