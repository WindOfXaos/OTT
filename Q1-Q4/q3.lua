-- This function kicks a member from the party of a player
-- Use camelCase for membername to follow the code convention
function kickFromPlayerParty(playerId, memberName)
	-- Use `local` keyword
	-- since `player` is not needed outside this function scope
	local player = Player(playerId)
	local party = player:getParty()

	-- Use '_' instead of 'k' to indicate that we are not interested in this value
	-- and `member` instead of `v` to be clear about what we are getting
	for _, member in pairs(party:getMembers()) do
		-- We can't compare objects so we compare names instead
		if member:getName() == memberName then
			-- We already have the player instance `member`
			-- we can just pass it as is
			party:removeMember(member)
		end
	end
end
