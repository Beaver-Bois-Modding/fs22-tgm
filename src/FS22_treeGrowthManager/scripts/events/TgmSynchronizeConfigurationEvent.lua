-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.1.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmSynchronizeConfigurationEvent = {}

local TgmSynchronizeConfigurationEvent_mt = Class(TgmSynchronizeConfigurationEvent, Event)

InitEventClass(TgmSynchronizeConfigurationEvent, "TgmSynchronizeConfigurationEvent")

function TgmSynchronizeConfigurationEvent.emptyNew()
    local self = Event.new(TgmSynchronizeConfigurationEvent_mt)

    return self
end

function TgmSynchronizeConfigurationEvent.new(configuration)
    local self = TgmSynchronizeConfigurationEvent.emptyNew()

    self.configuration = configuration

    return self
end

function TgmSynchronizeConfigurationEvent:readStream(streamId, connection)
    self.configuration = TgmConfiguration.new()

    self.configuration.showControlHint = streamReadBool(streamId)
    self.configuration.groupVariations = streamReadBool(streamId)

    local growthRateCount = streamReadInt8(streamId)
    if (growthRateCount > 0) then
        for i=1, growthRateCount do
            local name = streamReadString(streamId)
            local growthRate = streamReadInt32(streamId)
            self.configuration.growthRates[name] = growthRate
        end
    end

    self:run(connection)
end

function TgmSynchronizeConfigurationEvent:run(connection)
    if (connection:getIsServer()) then
        g_treeGrowthManager:replaceConfiguration(self.configuration)
    end
end

function TgmSynchronizeConfigurationEvent:writeStream(streamId, connection)
    local growthRateCount = 0
    for _ in pairs(self.configuration.growthRates) do
        growthRateCount = (growthRateCount + 1)
    end

    streamWriteBool(streamId, self.configuration.showControlHint)
    streamWriteBool(streamId, self.configuration.groupVariations)
    streamWriteInt8(streamId, growthRateCount)
    if (growthRateCount > 0) then
        for name, growthRate in pairs(self.configuration.growthRates) do
            streamWriteString(streamId, name)
            streamWriteInt32(streamId, growthRate)
        end
    end
end
