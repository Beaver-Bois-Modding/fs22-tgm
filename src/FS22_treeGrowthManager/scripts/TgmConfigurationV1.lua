-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.1.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmConfigurationV1 = {}
TgmConfigurationV1.VERSION = 1

local TgmConfigurationV1_mt = Class(TgmConfigurationV1)

function TgmConfigurationV1.new()
    local self = {}
    setmetatable(self, TgmConfigurationV1_mt)

    self.growthRates = {}

    return self
end

function TgmConfigurationV1.getPercentage(xmlFile, xmlPath, defaultValue)
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

function TgmConfigurationV1:load(xmlFile)
    if (xmlFile == nil) then
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
end
