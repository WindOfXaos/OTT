-- Definitions
local window = nil
local button = nil
local moveEvent = nil
local marginRight = 0
local displacment = 10
local interval = 100

-- Resources allocation
function init()
  window = g_ui.displayUI("jumpbutton.otui")
  button = window:getChildById("jumpButton")

  go()
end

-- Resources de-allocation
function terminate()
  removeEvent(moveEvent)
  window:destroy()

  window = nil
  button = nil
  moveEvent = nil
end

-- Movement callback function
function go()
  -- Create a cyclic event that is called every "interval"
  -- to move the button without blocking code execution
  -- and save it in a variable to de-allocate it later
  moveEvent = cycleEvent(function()
    if marginRight >= window:getWidth() - button:getWidth() - 30 then
      jump()
    end
    button:setMarginRight(marginRight)
    marginRight = marginRight + displacment
  end, interval)
end

-- Reset button location
function jump()
  marginRight = 0
  button:setMarginRight(marginRight)
  button:setMarginTop(math.random(window:getHeight() - button:getHeight() - 60, 0))
end
