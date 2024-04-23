// Solution 1
// ----------
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

// Solution 2
// ----------
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
