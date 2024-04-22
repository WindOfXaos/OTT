local function releaseStorage(player)
	player:setStorageValue(1000, -1)
end

function onLogout(player)
	if player:getStorageValue(1000) == 1 then
		addEvent(releaseStorage, 1000, player)
	end

	return true
end
