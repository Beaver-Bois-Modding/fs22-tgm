-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.0.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmSettingsGui = {}

local TgmSettingsGui_mt = Class(TgmSettingsGui)

function TgmSettingsGui.new()
    local self = {}
    setmetatable(self, TgmSettingsGui_mt)

    self.isInitialized = false
    self.elements = {}

    return self
end

function TgmSettingsGui.convertGrowthRateToState(growthRate)
    return (growthRate / 5)
end

function TgmSettingsGui.convertStateToGrowthRate(state)
    return (state * 5)
end

function TgmSettingsGui.getUnitText(value)
    if (value == 1) then
        return g_i18n:getText("treeGrowthManager_settingsGui_hour")
    end

    return g_i18n:getText("treeGrowthManager_settingsGui_hours")
end

function TgmSettingsGui.setTooltip(element, currentHours, defaultHours)
    local textCurrent = g_i18n:getText("treeGrowthManager_settingsGui_current")
    local textDefault = g_i18n:getText("treeGrowthManager_settingsGui_default")

    local current = (textCurrent..": "..tostring(currentHours).." "..TgmSettingsGui.getUnitText(currentHours))
    local default = (textDefault..": "..tostring(defaultHours).." "..TgmSettingsGui.getUnitText(defaultHours))

    element.elements[6]:setText(current.."; "..default)
end

function TgmSettingsGui:initialize(gameSettingsFrame)
    if (self.isInitialized) then
        return
    end

    local target = g_treeGrowthManager

    local title = TextElement.new()
    title:applyProfile("settingsMenuSubtitle", true)
    title:setText(g_i18n:getText("treeGrowthManager_settingsGui_title"))
    gameSettingsFrame.boxLayout:addElement(title)

    local template = gameSettingsFrame.economicDifficulty:clone()
    template.target = target
    template.id = nil
    template.focusId = nil
    template.focusChangeData = nil
    template.onClickCallback = self.onStateChanged
    template.buttonLRChange = self.onStateChanged
    template.texts = {}
    for i=5,195,5 do
        table.insert(template.texts, tostring(i).."%")
    end
    template.elements[4]:setText("")
    template.elements[6]:setText("")
    template:setState(20)

    local variations = {}
    local lastElement = FocusManager:getNextFocusElement(gameSettingsFrame.buttonPauseGame, "top")
    for _, treeType in TgmTableUtil.orderedPairs(g_treePlantManager.nameToTreeType) do
        local element = template:clone()
        element.id = (treeType.name.."_growthRate")
        element.__species = treeType.name
        FocusManager:loadElementFromCustomValues(element, nil, {top=lastElement.focusId}, false, false)
        lastElement.focusChangeData["bottom"] = element.focusId
        lastElement = element
        local growthRate = target.configuration.growthRates[treeType.name]
        if (growthRate ~= nil) then
            element:setState(TgmSettingsGui.convertGrowthRateToState(growthRate))
        end
        local displayName = g_i18n:getText(treeType.nameI18N)
        if (variations[treeType.nameI18N] ~= nil) then
            displayName = (displayName.." #"..variations[treeType.nameI18N])
            variations[treeType.nameI18N] = (variations[treeType.nameI18N] + 1)
        else
            variations[treeType.nameI18N] = 2
        end
        element.elements[4]:setText(g_i18n:getText("treeGrowthManager_settingsGui_growthRate").." ("..displayName..")")
        TgmSettingsGui.setTooltip(element, treeType.growthTimeHours, target.defaultGrowthHours[treeType.name])

        self.elements[treeType.name] = element
        gameSettingsFrame[element.id] = element
        gameSettingsFrame.boxLayout:addElement(element)
    end
    lastElement.focusChangeData["bottom"] = gameSettingsFrame.buttonPauseGame.focusId
    gameSettingsFrame.buttonPauseGame.focusChangeData["top"] = lastElement.focusId

    gameSettingsFrame.boxLayout:invalidateLayout()
    self.isInitialized = true
end

function TgmSettingsGui:onStateChanged(state, sender)
    local growthRate = TgmSettingsGui.convertStateToGrowthRate(state)
    g_client:getServerConnection():sendEvent(TgmGrowthRateChangedEvent.new(sender.__species, growthRate))
end

function TgmSettingsGui:invalidateGrowthRate(species)
    if (not self.isInitialized) then
        return
    end

    local growthRate = g_treeGrowthManager.configuration.growthRates[species]
    self.elements[species]:setState(TgmSettingsGui.convertGrowthRateToState(growthRate))
    TgmSettingsGui.setTooltip(self.elements[species], g_treePlantManager.nameToTreeType[species].growthTimeHours, g_treeGrowthManager.defaultGrowthHours[species])
end
