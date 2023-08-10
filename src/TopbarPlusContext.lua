--[[
TheNexusAvenger

Context for managing actions within TopbarPlus.
--]]
--!strict

local Types = require(script.Parent:WaitForChild("Types"))

local TopbarPlusContext = {} :: Types.TopbarPlusContext
TopbarPlusContext.__index = {}



--[[
Creates a TopbarPlus context.
--]]
function TopbarPlusContext.new(VRBottomBar: Types.VRBottomBar, TopbarPlus: any): Types.TopbarPlusContext
    local self = {}
    setmetatable({self}, TopbarPlusContext)
    self.VRBottomBar = VRBottomBar
    self.TopbarPlus = TopbarPlus

    return (self :: any) :: Types.TopbarPlusContext
end

--[[
Adds a TopbarPlus icon, either to the end or a given index.
--]]
function TopbarPlusContext:Add(TopbarPlusIcon: any, Index: number?): ()
    local IconFrame = Instance.new("Frame")
    IconFrame.BackgroundTransparency = 1
    IconFrame.Size = UDim2.new(1, 0, 1, 0)
    IconFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
    
    local IconButton = TopbarPlusIcon.instances.iconButton
    IconButton.Parent = IconFrame
    TopbarPlusIcon.instances.iconOverlay.Parent = IconButton
    self.VRBottomBar:Add(IconFrame, Index)
end



return TopbarPlusContext