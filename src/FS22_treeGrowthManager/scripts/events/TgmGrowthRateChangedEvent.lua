-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmGrowthRateChangedEvent = {}

local TgmGrowthRateChangedEvent_mt = Class(TgmGrowthRateChangedEvent, Event)

InitEventClass(TgmGrowthRateChangedEvent, "TgmGrowthRateChangedEvent")

function TgmGrowthRateChangedEvent.emptyNew()
    local self = Event.new(TgmGrowthRateChangedEvent_mt)

    return self
end

function TgmGrowthRateChangedEvent.new(species, growthRate)
    local self = TgmGrowthRateChangedEvent.emptyNew()

    self.species = species
    self.growthRate = growthRate

    return self
end

function TgmGrowthRateChangedEvent:readStream(streamId, connection)
    self.species = streamReadString(streamId)
    self.growthRate = streamReadInt32(streamId)

    self:run(connection)
end

function TgmGrowthRateChangedEvent:run(connection)
    for _, species in ipairs(self.species:split("|")) do
        g_treeGrowthManager.configuration.growthRates[species] = self.growthRate
    end
    g_treeGrowthManager:invalidateGrowthRate(self.species)

    if (g_server ~= nil) then
        g_server:broadcastEvent(self, false)
    end
end

function TgmGrowthRateChangedEvent:writeStream(streamId, connection)
    streamWriteString(streamId, self.species)
    streamWriteInt32(streamId, self.growthRate)
end
