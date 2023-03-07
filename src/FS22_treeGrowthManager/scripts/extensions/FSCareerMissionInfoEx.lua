-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.1.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

FSCareerMissionInfoEx = {}

function FSCareerMissionInfoEx.initialize()
    FSCareerMissionInfo.saveToXMLFile = Utils.appendedFunction(FSCareerMissionInfo.saveToXMLFile, FSCareerMissionInfoEx.postSaveToXMLFile)
end

function FSCareerMissionInfoEx.postSaveToXMLFile()
    g_treeGrowthManager:saveConfiguration()
end
