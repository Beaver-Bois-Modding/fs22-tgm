-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmConfiguration = {}
TgmConfiguration.VERSION = 1
TgmConfiguration.FILENAME = "treeGrowthManager.xml"

local TgmConfiguration_mt = Class(TgmConfiguration)

function TgmConfiguration.new()
    local self = {}
    setmetatable(self, TgmConfiguration_mt)

    self.growthRates = {}

    return self
end

function TgmConfiguration.buildFilePath(savegameDirectoryPath)
    return savegameDirectoryPath.."/"..TgmConfiguration.FILENAME
end

function TgmConfiguration.getPercentage(xmlFile, xmlPath, defaultValue)
    local percentage = xmlFile:getInt(xmlPath, defaultValue)
    if (percentage < 5) then
        percentage = 5
    elseif (percentage > 200) then
        percentage = 200
    elseif (percentage % 5 ~= 0) then
        percentage = 100
    end

    return percentage
end

function TgmConfiguration:loadFromFile(savegameDirectoryPath)
    if (savegameDirectoryPath == nil) then
        return
    end

    local filePath = self.buildFilePath(savegameDirectoryPath)
    if (not fileExists(filePath)) then
        return
    end

    local xmlFile = XMLFile.load("TreeGrowthManagerXML", filePath)
    if (xmlFile == nil) then
        return
    end

    local version = xmlFile:getInt("treeGrowthManager#version")
    if (version ~= self.VERSION) then
        return
    end

    xmlFile:iterate(
        "treeGrowthManager.species.species",
        function(_, key)
            local name = xmlFile:getString(key.."#name")
            if (name == nil) then
                return
            end
            local growthRate = self.getPercentage(xmlFile, key.."#growthRate")
            if (growthRate == nil) then
                return
            end

            self.growthRates[name] = growthRate
        end
    )

    xmlFile:delete()
end

function TgmConfiguration:saveToFile(savegameDirectoryPath)
    if (savegameDirectoryPath == nil) then
        return
    end

    local filePath = self.buildFilePath(savegameDirectoryPath)
    local xmlFile = XMLFile.create("TreeGrowthManagerXML", filePath, "treeGrowthManager")
    if (xmlFile == nil) then
        return
    end

    xmlFile:setInt("treeGrowthManager#version", self.VERSION)

    local i = 0
    for name, growthRate in pairs(self.growthRates) do
        local key = ("treeGrowthManager.species.species(%d)"):format(i)
        xmlFile:setString(key.."#name", name)
        xmlFile:setInt(key.."#growthRate", growthRate)

        i = (i + 1)
    end

    xmlFile:save()
    xmlFile:delete()
end
