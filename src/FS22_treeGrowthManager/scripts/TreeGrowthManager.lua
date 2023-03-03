-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TreeGrowthManager = {}

local TreeGrowthManager_mt = Class(TreeGrowthManager)

function TreeGrowthManager.new(modDirectory)
    local self = {}
    setmetatable(self, TreeGrowthManager_mt)

    self.modDirectory = modDirectory
    self.mission = nil
    self.isServer = false
    self.l10nImporter = TgmL10nImporter.new()
    self.configuration = TgmConfiguration.new()
    self.settingsGui = TgmSettingsGui.new()
    self.showSettingsGuiEventId = nil
    self.defaultGrowthHours = {}

    return self
end

function TreeGrowthManager:captureDefaultGrowthRates()
    for _, treeType in pairs(g_treePlantManager.nameToTreeType) do
        self.defaultGrowthHours[treeType.name] = treeType.growthTimeHours
    end
end

function TreeGrowthManager:invalidateGroupVariations()
    self.settingsGui:invalidateGroupVariations()
    self.settingsGui:toggleGrowthRates()
    self:invalidateGrowthRates()
end

function TreeGrowthManager:invalidateGrowthRate(species)
    for _, singleSpecies in pairs(species:split("|")) do
        local growthRate = self.configuration.growthRates[singleSpecies]
        if (growthRate ~= nil) then
            local hours = self.defaultGrowthHours[singleSpecies]
            hours = math.floor(((hours * ((200 - growthRate) / 100)) + 0.5))
            g_treePlantManager.nameToTreeType[singleSpecies].growthTimeHours = hours
        else
            g_treePlantManager.nameToTreeType[singleSpecies].growthTimeHours = self.defaultGrowthHours[singleSpecies]
        end
    end
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

function TreeGrowthManager:loadGui()
    g_gui:loadGui(Utils.getFilename("data/gui/TgmSettingsGui.xml", self.modDirectory), "TgmSettingsGui", self.settingsGui)
end

function TreeGrowthManager:onClientConnected(connection)
    connection:sendEvent(TgmSynchronizeConfigurationEvent.new(self.configuration))
end

function TreeGrowthManager:onLoadFinished()
    self.l10nImporter:import()
    self:captureDefaultGrowthRates()
    self:invalidateGrowthRates()
    self:loadGui()
    self:subscribeToMessages()
end

function TreeGrowthManager:onLoadStarting(mission00)
    self.mission = mission00
    self.isServer = mission00:getIsServer()

    self:loadConfiguration()
end

function TreeGrowthManager:onMasterUserAdded(user)
    if (user:getId() == self.mission.player.userId) then
        g_inputBinding:setActionEventTextVisibility(showSettingsEventId, true)
    end
end

function TreeGrowthManager:registerActionEvents()
    local _, showSettingsEventId = g_gui.inputManager:registerActionEvent(
        InputAction.TGM_SHOW_SETTINGS, self, self.showSettingsGui,
        false, true, false, true, nil, nil, true
    )
    self.showSettingsGuiEventId = showSettingsEventId
    g_inputBinding:setActionEventTextPriority(showSettingsEventId, GS_PRIO_VERY_LOW)
    g_inputBinding:setActionEventTextVisibility(showSettingsEventId, self.mission.isMasterUser)
end

function TreeGrowthManager:replaceConfiguration(configuration)
    self.configuration = configuration
    self:invalidateGrowthRates()
end

function TreeGrowthManager:saveConfiguration()
    if (not self.isServer) then
        return
    end

    local savegameDirectory = self.mission.missionInfo.savegameDirectory
    self.configuration:saveToFile(savegameDirectory)
end

function TreeGrowthManager:showSettingsGui()
    if (not self.mission.isMasterUser or g_gui:getIsGuiVisible()) then
        return
    end
    g_gui:showGui("TgmSettingsGui")
end

function TreeGrowthManager:subscribeToMessages()
    g_messageCenter:subscribe(MessageType.MASTERUSER_ADDED, self.onMasterUserAdded, self)
end

function TreeGrowthManager:unload()
    g_gui.inputManager:removeActionEventsByTarget(self)
    g_messageCenter:unsubscribeAll(self)
end
