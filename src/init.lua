--[[
TheNexusAvenger

Creates a second VR menu bar for small icons.

NOTE: This module is NOT supported by Roblox. Any changes
to the VR bottom bar risk this script breaking. Make sure to
have an automatic fail-over case (parent buttons somewheere
safe, and then add them to the bar).
--]]
--!strict

local UserInputService = game:GetService("UserInputService")

local VRBottomBar = {}
VRBottomBar.Frames = {}



--[[
Adds a button, either to the end or a given index.
--]]
function VRBottomBar:Add(Frame: GuiObject, Index: number?): ()
	
end

--[[
Sets up the bottom bar regardless if VR is enabled or not.
--]]
function VRBottomBar:ForceSetUp(): ()

end

--[[
Sets up the bottom bar if VR is enabled.
--]]
function VRBottomBar:SetUp(): ()
    if not UserInputService.VREnabled then return end
	task.spawn(self.ForceSetUp, self)
end



return VRBottomBar