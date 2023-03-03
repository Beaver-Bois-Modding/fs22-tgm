-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmGui = {}

local TgmGui_mt = Class(TgmGui, ScreenElement)

function TgmGui.new(target, custom_mt)
    local self = ScreenElement.new(target, (custom_mt or TgmGui_mt))

    return self
end

function TgmGui:linkFocusElements(sourceElement, direction, targetElement)
    if (sourceElement ~= nil) then
        FocusManager:linkElements(sourceElement, direction, targetElement)
    end
    if (direction == "top") then
        direction = "bottom"
    elseif (direction == "bottom") then
        direction = "top"
    end
    if (targetElement ~= nil) then
        FocusManager:linkElements(targetElement, direction, sourceElement)
    end
end

function TgmGui:onClose()
    TgmGui:superClass().onClose(self)

    g_currentMission:resetGameState()
    g_depthOfFieldManager:popArea()
end

function TgmGui:onOpen()
    TgmGui:superClass().onOpen(self)

    g_gameStateManager:setGameState(GameState.MENU_INGAME)
    g_depthOfFieldManager:pushArea(0, 0, 1, 1)
end

function TgmGui:resetFocusLinkage(element, hard)
    if (hard) then
        FocusManager:removeElement(element)
    else
        element.focusId = nil
        element.focusChangeData = nil
    end
end

function TgmGui:setMtoTooltip(element, tooltip)
    element.elements[6]:setText(tooltip)
end
