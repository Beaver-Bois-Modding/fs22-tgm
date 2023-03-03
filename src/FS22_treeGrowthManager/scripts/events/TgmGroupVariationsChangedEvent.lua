-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmGroupVariationsChangedEvent = {}

local TgmGroupVariationsChangedEvent_mt = Class(TgmGroupVariationsChangedEvent, Event)

InitEventClass(TgmGroupVariationsChangedEvent, "TgmGroupVariationsChangedEvent")

function TgmGroupVariationsChangedEvent.emptyNew()
    local self = Event.new(TgmGroupVariationsChangedEvent_mt)

    return self
end

function TgmGroupVariationsChangedEvent.new(groupVariations)
    local self = TgmGroupVariationsChangedEvent.emptyNew()

    self.groupVariations = groupVariations

    return self
end

function TgmGroupVariationsChangedEvent:readStream(streamId, connection)
    self.groupVariations = streamReadBool(streamId)

    self:run(connection)
end

function TgmGroupVariationsChangedEvent:run(connection)
    g_treeGrowthManager.configuration.groupVariations = self.groupVariations
    g_treeGrowthManager.configuration.growthRates = {}
    g_treeGrowthManager:invalidateGroupVariations()

    if (g_server ~= nil) then
        g_server:broadcastEvent(self, false)
    end
end

function TgmGroupVariationsChangedEvent:writeStream(streamId, connection)
    streamWriteBool(streamId, self.groupVariations)
end
