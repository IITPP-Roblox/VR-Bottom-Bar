--[[
TheNexusAvenger

Creates a second VR menu bar for small icons.

NOTE: This module is NOT supported by Roblox. Any changes
to the VR bottom bar risk this script breaking. Make sure to
have an automatic fail-over case (parent buttons somewheere
safe, and then add them to the bar).
--]]
--!strict

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local VRBottomBar = {}
VRBottomBar.Frames = {} :: {GuiObject}



--[[
Returns the index of a frame.
Throws an error if the frame is not found.
--]]
function VRBottomBar:GetFrameIndex(Frame: GuiObject): number
    for i, OtherFrame in self.Frames do
        if Frame ~= OtherFrame then continue end
        return i
    end
    error("Frame "..tostring(Frame).." not found.")
end

--[[
Updates the adorned frames.
--]]
function VRBottomBar:UpdateFrames(): ()
    --Update the layout of the frames.
    for i, Frame in self.Frames do
        Frame.LayoutOrder = i
    end

    --Update the visibility.
    if self.SurfaceGui then
        self.SurfaceGui.Enabled = (#self.Frames > 0)
    end
end

--[[
Adds a frame, either to the end or a given index.
Throws an error if there is a problem with the button (scale width used without RelativeYY size constraint.)
--]]
function VRBottomBar:Add(Frame: GuiObject, Index: number?): ()
    --Throw an error if a width scale is used without RelativeYY.
	if Frame.Size.Width.Scale ~= 0 and Frame.SizeConstraint ~= Enum.SizeConstraint.RelativeYY then
		error("Frame has a non-zero relative width but SizeConstraint is not RelativeYY. This will cause problems with bar sizing.")
	end

    --Add the button.
    if self.FrameContainer then
        Frame.Parent = self.FrameContainer
    end
    if Index then
        table.insert(self.Frames, Index, Frame)
    else
        table.insert(self.Frames, Frame)
    end
    self:UpdateFrames()
end

--[[
Adds a frame relative to the position of another.
Throws an error if the frame is not part of the bottom bar.
--]]
function VRBottomBar:AddRelative(Frame: GuiObject, RelativeFrame: GuiObject, Offset: number): ()
    self:Add(Frame, (self:GetFrameIndex(RelativeFrame) :: number) + Offset)
end

--[[
Adds a frame right before another.
Throws an error if the frame is not part of the bottom bar.
--]]
function VRBottomBar:AddBefore(Frame: GuiObject, RelativeFrame: GuiObject): ()
    self:AddRelative(Frame, RelativeFrame, 0)
end

--[[
Adds a frame right after another.
Throws an error if the frame is not part of the bottom bar.
--]]
function VRBottomBar:AddAfter(Frame: GuiObject, RelativeFrame: GuiObject): ()
    self:AddRelative(Frame, RelativeFrame, 1)
end

--[[
Sets up the bottom bar regardless if VR is enabled or not.
--]]
function VRBottomBar:ForceSetUp(): ()
    --Find the bottom bar.
    --This is expected to break at some point in the future. A simple rename or changing the parent will break this.
    local BottomBar = Workspace.CurrentCamera:WaitForChild("VRCorePanelParts"):WaitForChild("BottomBar_Part") :: BasePart

    --Create the new bottom bar.
    local SecondaryBottomBar = Instance.new("Part")
    SecondaryBottomBar.Transparency = 1
    SecondaryBottomBar.Name = "ExtendedBottomBar"
    SecondaryBottomBar.CanCollide = false
    SecondaryBottomBar.CanTouch = false
    SecondaryBottomBar.Parent = BottomBar.Parent

    local SurfaceGui = Instance.new("SurfaceGui")
    SurfaceGui.Name = "VRSecondaryBottomBar"
    SurfaceGui.ResetOnSpawn = false
    SurfaceGui.AlwaysOnTop = true
    SurfaceGui.CanvasSize = Vector2.new(0, 210)
    SurfaceGui.Adornee = SecondaryBottomBar
    SurfaceGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    self.SurfaceGui = SurfaceGui

    local Background = Instance.new("Frame")
    Background.BackgroundTransparency = 0.25
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
    Background.Parent = SurfaceGui

    local BackgroundUICorner = Instance.new("UICorner")
    BackgroundUICorner.CornerRadius = UDim.new(0.1, 0)
    BackgroundUICorner.Parent = Background

    local FrameContainer = Instance.new("Frame")
    FrameContainer.BackgroundTransparency = 1
    FrameContainer.Size = UDim2.new(1, -20, 1, -20)
    FrameContainer.Position = UDim2.new(0, 10, 0, 10)
    FrameContainer.Parent = Background
    self.FrameContainer = FrameContainer

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Parent = FrameContainer

    for _, Frame in self.Frames do
        Frame.Parent = FrameContainer
    end

    local Weld = Instance.new("Weld")
    Weld.Part0 = BottomBar
    Weld.Part1 = SecondaryBottomBar
    Weld.Parent = SecondaryBottomBar

    Weld.AncestryChanged:Connect(function()
        if Weld.Parent then return end
        Weld = Instance.new("Weld")
        Weld.Part0 = BottomBar
        Weld.Part1 = SecondaryBottomBar
        Weld.Parent = SecondaryBottomBar
    end)

    RunService:BindToRenderStep("ExtendedVRBottomBarUpdate", Enum.RenderPriority.First.Value + 1, function()
        local ContentSizeX = UIListLayout.AbsoluteContentSize.X + 20
        UIListLayout.Padding = UDim.new(0, 0.05 * 220)
        SecondaryBottomBar.Size = Vector3.new(BottomBar.Size.Y * (ContentSizeX / 220), BottomBar.Size.Y, BottomBar.Size.Z)
        Weld.C1 = CFrame.new(0, 1.1 * BottomBar.Size.Y, 0)
        SurfaceGui.CanvasSize = Vector2.new(ContentSizeX, 220)
    end)
    self:UpdateFrames()
end

--[[
Sets up the bottom bar if VR is enabled.
--]]
function VRBottomBar:SetUp(): ()
    if not UserInputService.VREnabled then return end
    task.spawn(self.ForceSetUp, self)
end



return VRBottomBar