-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmShowControlHintChangedEvent = {}

local TgmShowControlHintChangedEvent_mt = Class(TgmShowControlHintChangedEvent, Event)

InitEventClass(TgmShowControlHintChangedEvent, "TgmShowControlHintChangedEvent")

function TgmShowControlHintChangedEvent.emptyNew()
    local self = Event.new(TgmShowControlHintChangedEvent_mt)

    return self
end

function TgmShowControlHintChangedEvent.new(showControlHint)
    local self = TgmShowControlHintChangedEvent.emptyNew()

    self.showControlHint = showControlHint

    return self
end

function TgmShowControlHintChangedEvent:readStream(streamId, connection)
    self.showControlHint = streamReadBool(streamId)

    self:run(connection)
end

function TgmShowControlHintChangedEvent:run(connection)
    g_treeGrowthManager.configuration.showControlHint = self.showControlHint
    g_treeGrowthManager:invalidateShowControlHint()

    if (g_server ~= nil) then
        g_server:broadcastEvent(self, false)
    end
end

function TgmShowControlHintChangedEvent:writeStream(streamId, connection)
    streamWriteBool(streamId, self.showControlHint)
end
