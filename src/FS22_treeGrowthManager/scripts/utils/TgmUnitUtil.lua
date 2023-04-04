-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.2.0-dev
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmUnitUtil = {}

function TgmUnitUtil.formatHourText(hours)
    local key = "treeGrowthManager_units_hour"
    if (hours > 1) then
        key = "treeGrowthManager_units_hours"
    end

    return ("%d %s"):format(hours, g_i18n:getText(key))
end
