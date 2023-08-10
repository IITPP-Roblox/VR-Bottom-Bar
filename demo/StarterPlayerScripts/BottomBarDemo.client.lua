--[[
TheNexusAvenger

Demo for the VR bottom bar.
--]]
--!strict

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local VRBottomBar = require(ReplicatedStorage:WaitForChild("VRBottomBar"))
local TopbarPlus = require(ReplicatedStorage:WaitForChild("Icon"))

--Create the fake bottom bar when not in VR.
if not UserInputService.VREnabled then
    local VRCorePanelParts = Instance.new("Folder")
    VRCorePanelParts.Name = "VRCorePanelParts"
    VRCorePanelParts.Parent = Workspace.CurrentCamera

    local BottomBarPart = Instance.new("Part")
    BottomBarPart.BrickColor = BrickColor.new("Really red")
    BottomBarPart.Transparency = 0.5
    BottomBarPart.Name = "BottomBar_Part"
    BottomBarPart.Anchored = true
    BottomBarPart.CanCollide = false
    BottomBarPart.Size = Vector3.new(1, 0.4, 0)
    BottomBarPart.Parent = VRCorePanelParts

    RunService:BindToRenderStep("FakeVRBottomBarUpdate", Enum.RenderPriority.Camera.Value + 1, function()
        BottomBarPart.CFrame = Workspace.CurrentCamera.CFrame * CFrame.new(0, 0.25, -1) * CFrame.Angles(0, math.pi, 0)
    end)
end

--Set up the bottom bar.
--Order does not matter.
--ONLY THE SETUP WHEN VrEnabled IS true.
VRBottomBar:SetUp()

local Buttons = {}
for i = 1, 4 do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.6 + (0.2 * i), 0, 1, 0)
    Button.SizeConstraint = Enum.SizeConstraint.RelativeYY
    Button.TextScaled = true
    Button.Text = tostring(i)
    --Button.Parent = Somewhere --Make sure to parent any frames somewhere so that there is a fallback option when this eventually breaks.
    table.insert(Buttons, Button)
end

VRBottomBar:Add(Buttons[4])
VRBottomBar:AddBefore(Buttons[1], Buttons[4])
VRBottomBar:AddAfter(Buttons[2], Buttons[1])
VRBottomBar:Add(Buttons[3], 3)

local TopbarPlusContext = VRBottomBar:WithTopbarPlus(TopbarPlus)
TopbarPlusContext:AddNexusVRCharacterModelMenuButton(1)

--Demo error cases.
xpcall(function()
    VRBottomBar:Add(Buttons[1])
    warn("Error not thrown for a duplicate addition.")
end, function()
    print("Error thrown for a duplicate addition.")
end)

xpcall(function()
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 0)
    VRBottomBar:Add(Frame)
    warn("Error not thrown for a relative width frame without RelativeYY size constraint.")
end, function()
    print("Error thrown for a relative width frame without RelativeYY size constraint.")
end)

xpcall(function()
    VRBottomBar:AddBefore(Instance.new("Frame"), Instance.new("Frame"))
    warn("Error not thrown for a relative addition with an unknown frame.")
end, function()
    print("Error thrown for a relative addition with an unknown frame.")
end)