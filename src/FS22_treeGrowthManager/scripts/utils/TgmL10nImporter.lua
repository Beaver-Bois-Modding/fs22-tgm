-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmL10nImporter = {}

local TgmL10nImporter_mt = Class(TgmL10nImporter)

function TgmL10nImporter.new()
    local self = {}
    setmetatable(self, TgmL10nImporter_mt)

    self.hasImported = false
    self.database = nil

    return self
end

function TgmL10nImporter:initializeDatabase()
    if (self.database ~= nil) then
        return
    end

    self.database = {}
    for _, modEnv in pairs(getmetatable(g_i18n).__index.modEnvironments) do
        for key, value in pairs(modEnv.texts) do
            self.database[key] = value
        end
    end
end

function TgmL10nImporter:importTreeTypes()
    for _, treeType in pairs(g_treePlantManager.nameToTreeType) do
        if ((not g_i18n:hasText(treeType.nameI18N)) and (self.database[treeType.nameI18N] ~= nil)) then
            g_i18n:setText(treeType.nameI18N, self.database[treeType.nameI18N])
        end
    end
end

function TgmL10nImporter:import()
    if (self.hasImported) then
        return
    end

    self:initializeDatabase()
    self:importTreeTypes()
end
