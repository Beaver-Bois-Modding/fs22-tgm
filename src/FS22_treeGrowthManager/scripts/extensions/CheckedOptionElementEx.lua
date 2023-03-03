-- ---------------------------------------------------------------------------
-- Game: Farming Simulator 22
-- Name: Tree Growth Manager
-- Version: 1.1.0.0
-- Author: Beaver Bois Modding
-- ---------------------------------------------------------------------------

CheckedOptionElementEx = {}

function CheckedOptionElementEx.initialize()
    CheckedOptionElement.addElement = Utils.appendedFunction(CheckedOptionElement.addElement, CheckedOptionElementEx.postAddElement)
    CheckedOptionElement.loadFromXML = Utils.appendedFunction(CheckedOptionElement.loadFromXML, CheckedOptionElementEx.postLoadFromXml)
end

function CheckedOptionElementEx.postAddElement(instance, element)
    if (#instance.elements == 3) then
        if (instance.subType == "yesNo") then
            instance:setTexts({g_i18n:getText("ui_no"), g_i18n:getText("ui_yes")})
        end
    end
end

function CheckedOptionElementEx.postLoadFromXml(instance, xmlFile, key)
    instance.subType = getXMLString(xmlFile, ("%s#subType"):format(key))
end
