--[[
TheNexusAvenger

Types uses by the VR bottom bar.
--]]
--!strict

export type VRBottomBar = {
    Frames: {GuiObject},
    SurfaceGui: SurfaceGui?,
    FrameContainer: Frame?,
    TopbarPlusContext: TopbarPlusContext?,

    GetFrameIndex: (self: VRBottomBar, Frame: GuiObject) -> (number?),
    UpdateFrames: (self: VRBottomBar) -> (),
    Add: (self: VRBottomBar, Frame: GuiObject, Index: number?) -> (),
    AddRelative: (self: VRBottomBar, Frame: GuiObject, RelativeFrame: GuiObject, Offset: number) -> (),
    AddBefore: (self: VRBottomBar, Frame: GuiObject, RelativeFrame: GuiObject) -> (),
    AddAfter: (self: VRBottomBar, Frame: GuiObject, RelativeFrame: GuiObject) -> (),
    WithTopbarPlus: (self: VRBottomBar, TopbarPlus: any) -> (TopbarPlusContext),
    SetUp: (self: VRBottomBar) -> (),
}

export type TopbarPlusContext = {
    TopbarPlus: any,
    VRBottomBar: VRBottomBar,
    __index: any,

    new: (VRBottomBar: VRBottomBar, TopbarPlus: any) -> (TopbarPlusContext),
    Add: (self: TopbarPlusContext, TopbarPlusIcon: any, Index: number?) -> (),
    AddNexusVRCharacterModelMenuButton: (self: TopbarPlusContext, Index: number?) -> (),
}

return true