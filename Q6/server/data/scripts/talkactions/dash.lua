local talk = TalkAction("!dash")

function talk.onSay(creature, _, _)
	local position = creature:getPosition()
	local direction = creature:getDirection()

	-- Define the distance of the dash and steps of deceleration
	local dashDistance = 3
	local steps = dashDistance + 1

	-- Calculate new position steps based on the direction
	local newPos = {}
	for i = 1, steps do
		-- copy position table
		newPos[i] = Position(position)

		if direction == DIRECTION_NORTH then
			newPos[i].y = position.y - dashDistance
		elseif direction == DIRECTION_EAST then
			newPos[i].x = position.x + dashDistance
		elseif direction == DIRECTION_SOUTH then
			newPos[i].y = position.y + dashDistance
		elseif direction == DIRECTION_WEST then
			newPos[i].x = position.x - dashDistance
		end

		dashDistance = dashDistance + 1
	end

	-- Perform the dash
	local timeBetweenSteps = 50
	for i = 1, steps do
		addEvent(function()
			local freePosition = getClosestFreePositionStraight(creature:getPosition(), newPos[i], direction)
			creature:teleportTo(freePosition)
		end, i * timeBetweenSteps)
	end
	return false
end

-- A modified version of Creature.getClosestFreePosition()
function getClosestFreePositionStraight(fromPos, toPos, direction)
	local distance = getDistanceBetween(fromPos, toPos)
	local currentPos = Position(fromPos)
	local nextPos = Position(currentPos)

	for _ = 1, distance do
		nextPos:getNextPosition(direction)

		local tile = Tile(nextPos)
		-- If next tile is blocked, return the current tile otherwise check the next tile
		if tile and tile:getCreatureCount() == 0 and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then
			currentPos = Position(nextPos)
		else
			return currentPos
		end
	end
	return toPos
end

talk:register()
