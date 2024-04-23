# Q5
This spell looks like a custom version of eternal winter spell but in a larger area around the player, longer duration, and random timing for each tile. I have used [Revscriptsys](https://github.com/otland/forgottenserver/wiki/Revscriptsys) for all server side scripts.

Pseudo code
```
- Inside `onCastSpell` invoke `combat:execute(creature, variant)` multiple times to increase spell intensity
- Use `onTargetTile` to add an event for every single tile in the pattern which draws the effect at random times
```

The area of effect should look like this, where `3` represents the player and `1` the effect location relative to the player
```lua
local area = {
  { 0, 0, 0, 1, 0, 0, 0 },
  { 0, 0, 1, 0, 1, 0, 0 },
  { 0, 1, 0, 1, 0, 1, 0 },
  { 1, 0, 1, 3, 1, 0, 1 },
  { 0, 1, 0, 1, 0, 1, 0 },
  { 0, 0, 1, 0, 1, 0, 0 },
  { 0, 0, 0, 1, 0, 0, 0 },
}
```
But unfortunately this did not come as expected for some reason

https://github.com/WindOfXaos/OTT/assets/52869398/8513af0c-6129-433c-b1a7-3573a7611dd9

So I ended up with this area, which is one tile away from the solution
```lua
local area = {
  { 0, 0, 0, 1, 0, 0, 0 },
  { 0, 0, 1, 1, 1, 0, 0 },
  { 0, 1, 1, 1, 1, 1, 0 },
  { 1, 1, 1, 1, 3, 1, 1 },
  { 0, 1, 1, 1, 1, 1, 0 },
  { 0, 0, 1, 1, 1, 0, 0 },
  { 0, 0, 0, 1, 0, 0, 0 },
}
```

https://github.com/WindOfXaos/OTT/assets/52869398/5bf949f1-9b0f-4702-b877-6cf5b3e78e8b
