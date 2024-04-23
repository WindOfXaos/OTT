# Fix or improve the implementation of the below methods

## Q1
Player storages contain volatile in-memory data
like maybe `dailyRewardAvailable`, `numberOfOutfits`, etc... so when the player logsout
we want to free this memory since it is not needed anymore.

```lua
local function releaseStorage(player)
	player:setStorageValue(1000, -1)
end
```
This function releases player's storage that has key `1000`. It is not clear what that key refers to or what does setting storage to `-1` doe. To make our intentions clear we could use `removeStorageValue(key)` instead, and replace `1000` with a defined storage variable.

```lua
local function releaseStorage(player)
	player:removeStorageValue(PlayerStorageKeys.dailyRewardAvailable)
end
```

We could also get rid of the whole function and do this
```lua
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
```

## Q2
```lua
function printSmallGuildNames(memberCount)  
	-- this method is supposed to print names of all guilds that have less than memberCount max members  
	local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"  
	local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))  
	local guildName = result.getString("name")  
	print(guildName)
end  
```
The main issue here is `resultId` is never used to get results, to get actual results we need to call `result.getString(resultId, "name")` to get one record after making sure that `resutlId != nill`, and to fetch all results we need to chain multiple `result.getString() ` and `result.next(resultId)` like this

```lua
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
```

So the whole thing becomes
```lua
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
```

## Q3
```lua
function do_sth_with_PlayerParty(playerId, membername)
```
The function declaration needs some modifications to follow the code convention, we can give it a more descriptive name, and also use camelCase for `membername`
```lua
function kickFromPlayerParty(playerId, memberName)
```
No need to have `player` as global so we make it local to be collected after the function exits
```lua
local player = Player(playerId)
```
---
```lua
for k,v in pairs(party:getMembers()) do 
```
We can give `k`, `v` names so we know what we are getting and since `k` is not being used we replace it with an underscore
```lua
for _, member in pairs(party:getMembers()) do
```
---
```lua
if v == Player(membername) then  
	party:removeMember(Player(membername))
end
```
We can't compare objects directly but we can get the current member name and compare it with `memberName` that we already have, and since we have the current `member` object we can just pass it to `removeMember()` directly
```lua
if member:getName() == memberName then
	-- We already have the player instance `member`
	-- we can just pass it as is
	party:removeMember(member)
end
```

After these modifications the function becomes as follows
```lua
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
```

## Q4
```cpp
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)  
{  
	Player* player = g_game.getPlayerByName(recipient);  
	if (!player) {  
		player = new Player(nullptr);  
		if (!IOLoginData::loadPlayerByName(player, recipient)) {  
			return;  
		}  
	}  
	  
	Item* item = Item::CreateItem(itemId);  
	if (!item) {  
		return;  
	}  
	  
	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);  
	  
	if (player->isOffline()) {  
		IOLoginData::savePlayer(player);  
	}
}
```
Here we are trying to get a player by name and apparently the player might not be found in memory -might be offline or new- so we allocate memory for a new player instance using the `new` keyword. it gets allocated on the heap which makes this function resposible for managing this resource and freeing it when it is not needed. In our case it is not needed out of this function scope, which means de-allocating it before any return statement. We might also need to add a guard boolean so we don't delete `player` when it is allocated on the stack.

```cpp
void Game::addItemToPlayer(const std::string &recipient, uint16_t itemId) {
  // Guard boolean to prevent undefined behavior
  bool isAllocated = false;

  Player *player = g_game.getPlayerByName(recipient);
  if (!player) {
    isAllocated = true;
    player = new Player(nullptr);
    if (!IOLoginData::loadPlayerByName(player, recipient)) {
      // Here
      delete player;

      return;
    }
  }

  Item *item = Item::CreateItem(itemId);
  if (!item) {
    // Here
    if (isAllocated) delete player;

    return;
  }

  g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER,
                         FLAG_NOLIMIT);

  if (player->isOffline()) {
    IOLoginData::savePlayer(player);

    //Here
    if (isAllocated) delete player;
  }
}
```

Another solution is by using `std::unique_ptr` or smart pointers, it owns and manages `player` and deletes it when it goes out of scope.
```cpp
void Game::addItemToPlayer(const std::string &recipient, uint16_t itemId) {
  std::unique_ptr<Player> playerPtr;
  Player *player = g_game.getPlayerByName(recipient);
  if (!player) {
    player = std::make_unique<Player>(nullptr);
    if (!IOLoginData::loadPlayerByName(player, recipient)) {
      return;
    }
  }

  Item *item = Item::CreateItem(itemId);
  if (!item) {
    return;
  }

  g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER,
                         FLAG_NOLIMIT);

  if (player->isOffline()) {
    IOLoginData::savePlayer(player);
  }
}
```