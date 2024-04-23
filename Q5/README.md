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

