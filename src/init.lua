--[[
TheNexusAvenger

Creates a second VR menu bar for small icons.

NOTE: This module is NOT supported by Roblox. Any changes
to the VR bottom bar risk this script breaking. Make sure to
have an automatic fail-over case (parent buttons somewheere
safe, and then add them to the bar).
--]]
--!strict

local FRAME_PADDING = 30
local BORDER_PADDING = 20

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local TopbarPlusContext = require(script:WaitForChild("TopbarPlusContext"))
local Types = require(script:WaitForChild("Types"))

local VRBottomBar = {} :: Types.VRBottomBar
VRBottomBar.SetUpCalled = false
VRBottomBar.Frames = {} :: {GuiObject}



--[[
Returns the index of a frame.
--]]
function VRBottomBar:GetFrameIndex(Frame: GuiObject): number?
    for i, OtherFrame in self.Frames do
        if Frame ~= OtherFrame then continue end
        return i
    end
    return nil
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
    --Throw an error if the frame already was added.
    if self:GetFrameIndex(Frame) then
        error("GuiObject "..tostring(Frame).." was already added.")
    end

    --Throw an error if a width scale is used without RelativeYY.
	if Frame.Size.Width.Scale ~= 0 and Frame.SizeConstraint ~= Enum.SizeConstraint.RelativeYY then
		error("GuiObject "..tostring(Frame).." has a non-zero relative width but SizeConstraint is not RelativeYY. This will cause problems with bar sizing.")
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
    local ExistingIndex = self:GetFrameIndex(RelativeFrame) :: number?
    if not ExistingIndex then
        error("GuiObject "..tostring(Frame).." not found.")
    end
    self:Add(Frame, ExistingIndex + Offset)
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
Creates a context for managing TopbarPlus.
--]]
function VRBottomBar:WithTopbarPlus(TopbarPlus: any): Types.TopbarPlusContext
    if not self.TopbarPlusContext then
        self.TopbarPlusContext = TopbarPlusContext.new(self, TopbarPlus)
    end
    return self.TopbarPlusContext :: Types.TopbarPlusContext
end

--[[
Sets up the bottom bar regardless if VR is enabled or not.
Make sure to check if VREnabled is true before running.
--]]
function VRBottomBar:SetUp(): ()
    --Return if SetUp was already called.
    if self.SetUpCalled then
        return
    end
    self.SetUpCalled = true :: any --Roblox typing sees SetUpCalled as false instead of boolean.

    task.spawn(function()
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
        SurfaceGui.CanvasSize = Vector2.new(0, 200 + (2 * BORDER_PADDING))
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
        FrameContainer.Size = UDim2.new(1, -(2 * BORDER_PADDING), 1, -(2 * BORDER_PADDING))
        FrameContainer.Position = UDim2.new(0, BORDER_PADDING, 0, BORDER_PADDING)
        FrameContainer.Parent = Background
        self.FrameContainer = FrameContainer

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.Padding = UDim.new(0, FRAME_PADDING)
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
            local ContentSizeX = UIListLayout.AbsoluteContentSize.X + (2 * BORDER_PADDING)
            local Height = 200 + (2 * BORDER_PADDING)
            SecondaryBottomBar.Size = Vector3.new(BottomBar.Size.Y * (ContentSizeX / Height), BottomBar.Size.Y, BottomBar.Size.Z)
            Weld.C1 = CFrame.new(0, 1.1 * BottomBar.Size.Y, 0)
            SurfaceGui.CanvasSize = Vector2.new(ContentSizeX, Height)
        end)
        self:UpdateFrames()
    end)
end



return VRBottomBar