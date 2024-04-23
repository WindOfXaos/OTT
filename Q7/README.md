# Q7
Let's go through the module functions in `jumpbutton.lua` one by one

```lua
-- Resources and constants
local window = nil
local button = nil
local moveEvent = nil
local marginRight = 0
local displacment = 10
local interval = 100
```

The `init()` function, it gets called when we load the module. Usually we initalize our variables and set callbacks for events using `connect()` but we only need to initialize main window and our button that will be used next by `go()` function which is going to move our button
```lua
-- Resources allocation
function init()
  window = g_ui.displayUI("jumpbutton.otui")
  button = window:getChildById("jumpButton")

  go()
end
```

The `terminate()` function where we free allocated resources and disconnect callbacks connected previously by `init()`, it gets called when we unload the module.
```lua
-- Resources de-allocation
function terminate()
  removeEvent(moveEvent)
  window:destroy()

  window = nil
  button = nil
  moveEvent = nil
end
```

To move the button we can manipulate its margin values to get it to move. Instead of doing an infinite for loop to keep moving the button -which of course will lock our game and crash it- we can use `cycleEvent()` to execute the move code periodically without interrupting the flow of the application.
```lua
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
```

In `jumpbutton.otui` we define the module's interface, like setting mainWindow's size, button's text, anchors, etc...
```css
MainWindow
  size: 250 400

  Button
    id: jumpButton
    !text: tr('Jump!')
    text-auto-resize: true
    // Add anchor point or margin to be able to change button margins
    anchors.right: parent.right
    anchors.top: parent.top
    // Invoke jump() callback function after click event
    @onClick: modules.game_jumpbutton.jump()
```

Here is a video of the button jumping tirelessly

