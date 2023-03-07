-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.1.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

TgmSettingsGui = {}
TgmSettingsGui.CONTROLS = {
    BOX_LAYOUT = "boxLayout",
    SHOW_CONTROL_HINT = "showControlHint",
    GROUP_VARIATIONS = "groupVariations",
    GROWTH_RATE_TEMPLATE = "growthRateTemplate"
}

local TgmSettingsGui_mt = Class(TgmSettingsGui, TgmGui)

function TgmSettingsGui.new(target)
    local self = TgmGui.new(target, TgmSettingsGui_mt)

    self.groupGrowthRates = {}
    self.singleGrowthRates = {}
    self.speciesToGrowthRateMappings = {
        group = {},
        single = {}
    }

    self:registerControls(self.CONTROLS)

    return self
end

function TgmSettingsGui:convertGrowthRateToState(growthRate)
    return (growthRate / 5)
end

function TgmSettingsGui:convertStateToGrowthRate(state)
    return (state * 5)
end

function TgmSettingsGui:drawGrowthRate(species, label, options, isGroup)
    local originalSpecies = species
    if (isGroup) then
        species = species:split("|")[1]
    end

    local element = self.growthRateTemplate:clone()
    element.__species = originalSpecies
    element:setLabel(label)
    element:setTexts(options)

    self:setMtoTooltip(
        element,
        self:formatGrowthRateTooltip(
            g_treePlantManager.nameToTreeType[species].growthTimeHours,
            g_treeGrowthManager.defaultGrowthHours[species]
        )
    )

    local growthRate = g_treeGrowthManager.configuration.growthRates[species]
    if (growthRate == nil) then
        growthRate = 100
    end
    element:setState(self:convertGrowthRateToState(growthRate))

    self:resetFocusLinkage(element)
    FocusManager:loadElementFromCustomValues(element, nil, nil, false, false)
    local lastElement = nil
    if (isGroup and (#self.groupGrowthRates > 0)) then
        lastElement = self.groupGrowthRates[#self.groupGrowthRates]
    elseif (not isGroup and (#self.singleGrowthRates > 0)) then
        lastElement = self.singleGrowthRates[#self.singleGrowthRates]
    else
        lastElement = FocusManager:getElementById(self.growthRateTemplate.focusChangeData.top)
    end
    self:linkFocusElements(element, "top", lastElement)

    if (isGroup) then
        table.insert(self.groupGrowthRates, element)
        self.speciesToGrowthRateMappings.group[species] = element
    else
        table.insert(self.singleGrowthRates, element)
        self.speciesToGrowthRateMappings.single[species] = element
    end
    self.boxLayout:addElement(element)
end

function TgmSettingsGui:drawGrowthRates()
    local groups = {}
    for species, treeType in TgmTableUtil.orderedPairs(g_treePlantManager.nameToTreeType) do
        local defaultGrowthHours = g_treeGrowthManager.defaultGrowthHours[species]
        local group = groups[treeType.nameI18N]
        if (group == nil) then
            group = {
                isValid = true,
                defaultGrowthHours = defaultGrowthHours,
                species = {}
            }
            groups[treeType.nameI18N] = group
        elseif (group.defaultGrowthHours ~= defaultGrowthHours) then
            group.isValid = false
        end
        table.insert(group.species, species)
    end

    local labelsToGroupSpecies = {}
    local labelsToSingleSpecies = {}
    for nameI18n, group in pairs(groups) do
        local label = g_i18n:getText(nameI18n)
        if (#group.species > 1) then
            if (group.isValid) then
                labelsToGroupSpecies[label] = table.concat(group.species, "|")
            end
            for _, species in ipairs(group.species) do
                label = ("%s (%s)"):format(g_i18n:getText(nameI18n), species)
                labelsToSingleSpecies[label] = species
                if (not group.isValid) then
                    labelsToGroupSpecies[label] = species
                end
            end
        else
            labelsToGroupSpecies[label] = group.species[1]
            labelsToSingleSpecies[label] = group.species[1]
        end
    end

    local options = {}
    for i=5,195,5 do
        table.insert(options, ("%d%%"):format(i))
    end

    for label, species in TgmTableUtil.orderedPairs(labelsToGroupSpecies) do
        self:drawGrowthRate(species, label, options, true)
    end
    for label, species in TgmTableUtil.orderedPairs(labelsToSingleSpecies) do
        self:drawGrowthRate(species, label, options, false)
    end
    self:linkFocusElements(
        self.singleGrowthRates[#self.singleGrowthRates],
        "bottom",
        FocusManager:getElementById(self.growthRateTemplate.focusChangeData.bottom)
    )

    self:resetFocusLinkage(self.growthRateTemplate, true)
    self.growthRateTemplate:setDisabled(true)
    self.growthRateTemplate:setVisible(false)

    self:toggleGrowthRates()
end

function TgmSettingsGui:formatGrowthRateTooltip(currentHours, defaultHours)
    return ("%s: %s; %s: %s"):format(
        g_i18n:getText("treeGrowthManager_settingsGui_current"), TgmUnitUtil.formatHourText(currentHours),
        g_i18n:getText("treeGrowthManager_settingsGui_default"), TgmUnitUtil.formatHourText(defaultHours)
    )
end

function TgmSettingsGui:initializeScreen()
    TgmSettingsGui:superClass().initializeScreen(self)

    self:invalidateShowControlHint()
    self:invalidateGroupVariations()
    self:drawGrowthRates()

    self.boxLayout:invalidateLayout()
end

function TgmSettingsGui:invalidateGroupVariations()
    if (not self.isInitialized) then
        return
    end

    self.groupVariations:setIsChecked(g_treeGrowthManager.configuration.groupVariations)
end

function TgmSettingsGui:invalidateGrowthRate(species)
    if (not self.isInitialized) then
        return
    end

    local element = nil
    if (g_treeGrowthManager.configuration.groupVariations) then
        species = species:split("|")[1]
        element = self.speciesToGrowthRateMappings.group[species]
        if (element == nil) then
            return
        end
    else
        element = self.speciesToGrowthRateMappings.single[species]
    end

    local growthRate = g_treeGrowthManager.configuration.growthRates[species]
    if (growthRate == nil) then
        growthRate = 100
    end
    element:setState(self:convertGrowthRateToState(growthRate))

    self:setMtoTooltip(
        element,
        self:formatGrowthRateTooltip(
            g_treePlantManager.nameToTreeType[species].growthTimeHours,
            g_treeGrowthManager.defaultGrowthHours[species]
        )
    )
end

function TgmSettingsGui:invalidateShowControlHint()
    if (not self.isInitialized) then
        return
    end

    self.showControlHint:setIsChecked(g_treeGrowthManager.configuration.showControlHint)
end

function TgmSettingsGui:onClickBack()
    TgmSettingsGui:superClass().onClickBack(self)
    self:changeScreen(nil)
end

function TgmSettingsGui:onGroupVariationsStateChanged(state, sender)
    g_client:getServerConnection():sendEvent(TgmGroupVariationsChangedEvent.new(sender:getIsChecked()))
end

function TgmSettingsGui:onGrowthRateStateChanged(state, sender)
    local growthRate = self:convertStateToGrowthRate(state)
    g_client:getServerConnection():sendEvent(TgmGrowthRateChangedEvent.new(sender.__species, growthRate))
end

function TgmSettingsGui:onShowControlHintStateChanged(state, sender)
    g_client:getServerConnection():sendEvent(TgmShowControlHintChangedEvent.new(sender:getIsChecked()))
end

function TgmSettingsGui:toggleGrowthRates()
    if (not self.isInitialized) then
        return
    end

    local elementsToDisable = nil
    local elementsToEnable = nil
    if (g_treeGrowthManager.configuration.groupVariations) then
        elementsToDisable = self.singleGrowthRates
        elementsToEnable = self.groupGrowthRates
    else
        elementsToDisable = self.groupGrowthRates
        elementsToEnable = self.singleGrowthRates
    end

    for _, element in ipairs(elementsToDisable) do
        element:setDisabled(true)
        element:setVisible(false)
    end
    for _, element in ipairs(elementsToEnable) do
        element:setVisible(true)
        element:setDisabled(false)
    end

    self.boxLayout:invalidateLayout()
end
