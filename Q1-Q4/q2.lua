-- From "src/database.h"
-- and "data/migrations/"

function printSmallGuildNames(memberCount)
	-- db.escapeString() to prevent SQL injections
	local selectGuildQuery = "SELECT `name` FROM `guilds` WHERE `max_members` < " .. db.escapeString(memberCount)
	local resultId = db.storeQuery(selectGuildQuery)
	-- Check if there are results "resutlId != nill"
	if resultId then
		-- Keep getting results until next == false
		repeat
			local guildName = result.getString(resultId, "name")
			print(guildName)
		until not result.next(resultId)
		-- Free results
		result.free(resultId)
	end
end
