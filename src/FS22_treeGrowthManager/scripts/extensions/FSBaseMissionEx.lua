-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

FSBaseMissionEx = {}

function FSBaseMissionEx.initialize()
    FSBaseMission.delete = Utils.appendedFunction(FSBaseMission.delete, FSBaseMissionEx.postDelete)
    FSBaseMission.onConnectionFinishedLoading = Utils.appendedFunction(FSBaseMission.onConnectionFinishedLoading, FSBaseMissionEx.postOnConnectionFinishedLoading)
end

function FSBaseMissionEx.postDelete()
    g_treeGrowthManager = nil
end

function FSBaseMissionEx.postOnConnectionFinishedLoading(instance, connection)
    g_treeGrowthManager:onClientConnected(connection)
end
