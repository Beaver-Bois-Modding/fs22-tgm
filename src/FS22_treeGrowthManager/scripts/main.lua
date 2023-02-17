-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

source(Utils.getFilename("scripts/utils/TgmL10nImporter.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/utils/TgmTableUtil.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/events/TgmGrowthRateChangedEvent.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/events/TgmSynchronizeConfigurationEvent.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/gui/TgmSettingsGui.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/TgmConfiguration.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/TreeGrowthManager.lua", g_currentModDirectory))

source(Utils.getFilename("scripts/extensions/FSBaseMissionEx.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/extensions/FSCareerMissionInfoEx.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/extensions/InGameMenuGameSettingsFrameEx.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/extensions/Mission00Ex.lua", g_currentModDirectory))

g_treeGrowthManager = TreeGrowthManager.new()

FSBaseMissionEx.initialize()
FSCareerMissionInfoEx.initialize()
InGameMenuGameSettingsFrameEx.initialize()
Mission00Ex.initialize()
