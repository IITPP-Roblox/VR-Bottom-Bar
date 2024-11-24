--Context for managing actions within TopbarPlus.
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TopbarPlusContext = {}
TopbarPlusContext.__index = TopbarPlusContext

export type TopbarPlusContext = {
    VRBottomBar: any,
    TopbarPlus: any,
} & typeof(setmetatable({}, TopbarPlusContext))



--[[
Creates a TopbarPlus context.
--]]
function TopbarPlusContext.new(VRBottomBar: any, TopbarPlus: any): TopbarPlusContext
    return setmetatable({
        VRBottomBar = VRBottomBar,
        TopbarPlus = TopbarPlus,
    }, TopbarPlusContext) :: TopbarPlusContext
end

--[[
Adds a TopbarPlus icon, either to the end or a given index.
--]]
function TopbarPlusContext.Add(self: TopbarPlusContext, TopbarPlusIcon: any, Index: number?): ()
    local IconFrame = Instance.new("Frame")
    IconFrame.BackgroundTransparency = 1
    IconFrame.Size = UDim2.new(1, 0, 1, 0)
    IconFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
    
    local IconButton = TopbarPlusIcon.instances.iconButton
    IconButton.Parent = IconFrame
    TopbarPlusIcon.instances.iconOverlay.Parent = IconButton
    self.VRBottomBar:Add(IconFrame, Index)
end

--[[
Adds a button for opening the Nexus VR Character Model menu.
Not recommended to be called outside of VR.
--]]
function TopbarPlusContext.AddNexusVRCharacterModelMenuButton(self: TopbarPlusContext, Index: number?): ()
    --Create and add the button.
    local NexusVRCharacterModelMenuIcon = self.TopbarPlus.new()
        :setName("NexusVRCharacterModelMenu")
        :setImage("rbxassetid://14034301935")
    self:Add(NexusVRCharacterModelMenuIcon, Index)

    --Connect the button to the menu API.
    --Done in the background in case Nexus VR Character Model is not loaded.
    task.spawn(function()
        local NexusVRCharacterModel = require(ReplicatedStorage:WaitForChild("NexusVRCharacterModel")) :: any
        local MenuApi = NexusVRCharacterModel.Api:WaitFor("Menu")
        NexusVRCharacterModelMenuIcon:bindEvent("selected", function(self)
            MenuApi:Open()
        end)
        NexusVRCharacterModelMenuIcon:bindEvent("deselected", function(self)
            MenuApi:Close()
        end)
    end)
end



return TopbarPlusContext