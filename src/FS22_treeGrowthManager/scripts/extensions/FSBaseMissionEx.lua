-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.2.0-dev
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

FSBaseMissionEx = {}

function FSBaseMissionEx.initialize()
    FSBaseMission.delete = Utils.appendedFunction(FSBaseMission.delete, FSBaseMissionEx.postDelete)
    FSBaseMission.onConnectionFinishedLoading = Utils.appendedFunction(FSBaseMission.onConnectionFinishedLoading, FSBaseMissionEx.postOnConnectionFinishedLoading)
    FSBaseMission.registerActionEvents = Utils.appendedFunction(FSBaseMission.registerActionEvents, FSBaseMissionEx.postRegisterActionEvents)
end

function FSBaseMissionEx.postDelete()
    g_treeGrowthManager:unload()
    g_treeGrowthManager = nil
end

function FSBaseMissionEx.postOnConnectionFinishedLoading(instance, connection)
    g_treeGrowthManager:onClientConnected(connection)
end

function FSBaseMissionEx.postRegisterActionEvents()
    g_treeGrowthManager:registerActionEvents()
end
