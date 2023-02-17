-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TreeGrowthManager = {}

local TreeGrowthManager_mt = Class(TreeGrowthManager)

function TreeGrowthManager.new()
    local self = {}
    setmetatable(self, TreeGrowthManager_mt)

    self.mission = nil
    self.isServer = false
    self.l10nImporter = TgmL10nImporter.new()
    self.configuration = TgmConfiguration.new()
    self.settingsGui = TgmSettingsGui.new()
    self.defaultGrowthHours = {}

    return self
end

function TreeGrowthManager:captureDefaultGrowthRates()
    for _, treeType in pairs(g_treePlantManager.nameToTreeType) do
        self.defaultGrowthHours[treeType.name] = treeType.growthTimeHours
    end
end

function TreeGrowthManager:invalidateGrowthRate(species)
    local growthRate = self.configuration.growthRates[species]
    if (growthRate == nil) then
        return
    end

    local hours = self.defaultGrowthHours[species]
    hours = math.floor(((hours * (growthRate / 100)) + 0.5))
    g_treePlantManager.nameToTreeType[species].growthTimeHours = hours

    self.settingsGui:invalidateGrowthRate(species)
end

function TreeGrowthManager:invalidateGrowthRates()
    for _, treeType in pairs(g_treePlantManager.treeTypes) do
        self:invalidateGrowthRate(treeType.name)
    end
end

function TreeGrowthManager:loadConfiguration()
    if (not self.isServer) then
        return
    end

    local savegameDirectory = self.mission.missionInfo.savegameDirectory
    self.configuration:loadFromFile(savegameDirectory)
end

function TreeGrowthManager:onClientConnected(connection)
    connection:sendEvent(TgmSynchronizeConfigurationEvent.new(self.configuration))
end

function TreeGrowthManager:onLoadFinished()
    self.l10nImporter:import()
    self:captureDefaultGrowthRates()
    self:invalidateGrowthRates()
end

function TreeGrowthManager:onLoadStarting(mission00)
    self.mission = mission00
    self.isServer = mission00:getIsServer()

    self:loadConfiguration()
end

function TreeGrowthManager:saveConfiguration()
    if (not self.isServer) then
        return
    end

    local savegameDirectory = self.mission.missionInfo.savegameDirectory
    self.configuration:saveToFile(savegameDirectory)
end

function TreeGrowthManager:replaceConfiguration(configuration)
    self.configuration = configuration
    self:invalidateGrowthRates()
end
