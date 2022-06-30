-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

Mission00Ex = {}

function Mission00Ex.initialize()
    Mission00.load = Utils.prependedFunction(Mission00.load, Mission00Ex.preLoad)
    Mission00.loadMission00Finished = Utils.appendedFunction(Mission00.loadMission00Finished, Mission00Ex.postLoadMission00Finished)
end

function Mission00Ex.postLoadMission00Finished()
    g_treeGrowthManager:onLoadFinished()
end

function Mission00Ex.preLoad(mission00)
    g_treeGrowthManager:onLoadStarting(mission00)
end
