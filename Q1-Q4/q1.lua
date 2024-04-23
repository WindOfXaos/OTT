-- storages.lua
PlayerStorageKeys = {
	dailyRewardAvailable = 1000,
	numberOfOutfits = 1001,
	-- ...
}

-- contants.lua
STORAGE_REMOVE_DELAY = 1000
--

function onLogout(player)
	if player:getStorageValue(PlayerStorageKeys.dailyRewardAvailable) == 1 then
		addEvent(function()
			player:removeStorageValue(PlayerStorageKeys.dailyRewardAvailable)
		end, STORAGE_REMOVE_DELAY, player)
	end

	return true
end
