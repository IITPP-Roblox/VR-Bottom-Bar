--[[
TheNexusAvenger

Types uses by the VR bottom bar.
--]]
--!strict

export type VRBottomBar = {
    Frames: {GuiObject},
    SurfaceGui: SurfaceGui?,
    FrameContainer: Frame?,

    GetFrameIndex: (self: VRBottomBar, Frame: GuiObject) -> (number?),
    UpdateFrames: (self: VRBottomBar) -> (),
    Add: (self: VRBottomBar, Frame: GuiObject, Index: number?) -> (),
    AddRelative: (self: VRBottomBar, Frame: GuiObject, RelativeFrame: GuiObject, Offset: number) -> (),
    AddBefore: (self: VRBottomBar, Frame: GuiObject, RelativeFrame: GuiObject) -> (),
    AddAfter: (self: VRBottomBar, Frame: GuiObject, RelativeFrame: GuiObject) -> (),
    ForceSetUp: (self: VRBottomBar) -> (),
    SetUp: (self: VRBottomBar) -> (),
}

return true