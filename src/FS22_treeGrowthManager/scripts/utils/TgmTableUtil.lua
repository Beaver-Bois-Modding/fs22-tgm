-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmTableUtil = {}

function TgmTableUtil.orderedPairs(srcTable)
    local orderedIndex = {}
    for key in pairs(srcTable) do
        table.insert(orderedIndex, key)
    end
    table.sort(orderedIndex)

    local i = 0
    local iterator = function()
        i = (i + 1)
        if (orderedIndex[i] == nil) then
            return nil
        else
            return orderedIndex[i], srcTable[orderedIndex[i]]
        end
    end

    return iterator
end
