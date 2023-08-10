# VR Bottom Bar
VR Bottom Bar adds a second bar under the Roblox VR menu
for custom buttons.

# Usage
## Setup
VR Bottom Bar only requires a call to `SetUp` on the client.
**Make sure to check if `UserInputService.VREnabled` is `true`
before running.**

```lua
local VRBottomBar = require(game:GetService("ReplicatedStorage"):WaitForChild("VRBottomBar"))

if game:GetService("UserInputService").VREnabled then
    VRBottomBar:SetUp()
end
```

## Generic `GuiObject`s
Generic `GuiObject`s (`TextButton`s and `ImageButton`s in most cases)
can be added to the bottom bar with a couple of methods.

```lua
local VRBottomBar = require(game:GetService("ReplicatedStorage"):WaitForChild("VRBottomBar"))

if game:GetService("UserInputService").VREnabled then
    VRBottomBar:SetUp()

    local Buttons = {}
    for i = 1, 4 do
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.SizeConstraint = Enum.SizeConstraint.RelativeYY --When a scale width is used, RelativeYY MUST be used.
        Button.Text = tostring(i)
        Button.Parent = Somewhere --Make sure to parent any frames somewhere so that there is a fallback option when this eventually breaks.
        table.insert(Buttons, Button)
    end

    VRBottomBar:Add(Buttons[4]) --Adds a button to the end.
    VRBottomBar:AddBefore(Buttons[1], Buttons[4]) --Adds a button right before another.
    VRBottomBar:AddAfter(Buttons[2], Buttons[1]) --Adds a button right after another.
    VRBottomBar:Add(Buttons[3], 3) --Adds a button at a specific index.
end
```

## TopbarPlus
[TopbarPlus](https://github.com/1ForeverHD/TopbarPlus) has special support
for adding buttons.

```lua
local Icon = require(game:GetService("ReplicatedStorage"):WaitForChild("Icon")) --TopbarPlus
local VRBottomBar = require(game:GetService("ReplicatedStorage"):WaitForChild("VRBottomBar"))

local TestIcon = Icon.new()
    :setName("MyTestIcon")
    :setImage("rbxassetid://14034301935")

if game:GetService("UserInputService").VREnabled then
    VRBottomBar:SetUp()

    local Context = VRBottomBar:WithTopbarPlus(Icon)
    Context:Add(TestIcon) --Can also specify an index, like VRBottomBar:Add(GuiObject, number)

    --You can also add a button dedicated for opening the Nexus VR Character Model menu.
    --Passing 1 makes the button first, but it is optional. Nothing can be passed in to put it at the end.
    --Recommended to also set Menu.MenuToggleGestureActive to false in the Nexus VR Character Model menu.
    Context:AddNexusVRCharacterModelMenuButton(1)
end
```

Note: `AddBefore` and `AddAfter` are not implemented. Please
submit a GitHub Issue or Pull Request if there is a use case.

# License
This project is available under the terms of the MIT License.
See [LICENSE](LICENSE) for details.