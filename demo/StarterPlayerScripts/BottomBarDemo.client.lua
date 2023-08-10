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
if UserInputService.VREnabled then
    VRBottomBar:SetUp()
else
    --DO NOT RUN THIS IN NORMAL GAMES. THIS IS ONLY FOR THE DEMO.
    VRBottomBar:ForceSetUp()
end