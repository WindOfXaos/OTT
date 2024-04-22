function do_sth_with_PlayerParty(playerId, membername)
	player = Player(playerId)
	local party = player:getParty()

	for k, v in pairs(party:getMembers()) do
		if v == Player(membername) then
			party:removeMember(Player(membername))
		end
	end
end
