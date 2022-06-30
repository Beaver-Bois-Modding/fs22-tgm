-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

InGameMenuGameSettingsFrameEx = {}

function InGameMenuGameSettingsFrameEx.initialize()
    InGameMenuGameSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuGameSettingsFrame.onFrameOpen, InGameMenuGameSettingsFrameEx.postOnFrameOpen)
end

function InGameMenuGameSettingsFrameEx.postOnFrameOpen(instance)
    g_treeGrowthManager.settingsGui:initialize(instance)
end
