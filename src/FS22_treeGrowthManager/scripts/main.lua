-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

source(Utils.getFilename("scripts/utils/TgmL10nImporter.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/utils/TgmTableUtil.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/utils/TgmUnitUtil.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/events/TgmGroupVariationsChangedEvent.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/events/TgmGrowthRateChangedEvent.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/events/TgmShowControlHintChangedEvent.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/events/TgmSynchronizeConfigurationEvent.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/gui/TgmGui.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/gui/TgmSettingsGui.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/TgmConfigurationV1.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/TgmConfiguration.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/TreeGrowthManager.lua", g_currentModDirectory))

source(Utils.getFilename("scripts/extensions/FSBaseMissionEx.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/extensions/FSCareerMissionInfoEx.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/extensions/Mission00Ex.lua", g_currentModDirectory))

g_treeGrowthManager = TreeGrowthManager.new(g_currentModDirectory)

FSBaseMissionEx.initialize()
FSCareerMissionInfoEx.initialize()
Mission00Ex.initialize()
