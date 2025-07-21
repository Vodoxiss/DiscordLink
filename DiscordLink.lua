-- === TABLE DE LANGUES ===
local L = {
    ["fr"] = {
        WELCOME = "Tapez /didi pour partager votre lien Discord, ou /didiui pour le modifier.",
        NOT_IN_GROUP = "Vous n'êtes pas dans un groupe. Voici le lien : ",
        COOLDOWN = "Veuillez attendre quelques secondes avant de renvoyer le lien.",
        LINK_UPDATED = "Lien Discord mis à jour !",
        LINK_EMPTY = "Le lien ne peut pas être vide.",
        UI_TITLE = "Modifier le lien Discord",
        SAVE_BUTTON = "Enregistrer",
        LANGUAGE_LABEL = "Langue :",
        GROUP_LINK_MESSAGE = "Rejoignez le Discord ici : ",
    },
    ["en"] = {
        WELCOME = "Type /didi to share your Discord link, or /didiui to modify it.",
        NOT_IN_GROUP = "You are not in a group. Here is the link: ",
        COOLDOWN = "Please wait a few seconds before resending the link.",
        LINK_UPDATED = "Discord link updated!",
        LINK_EMPTY = "The link cannot be empty.",
        UI_TITLE = "Edit Discord Link",
        SAVE_BUTTON = "Save",
        LANGUAGE_LABEL = "Language:",
        GROUP_LINK_MESSAGE = "Join our Discord here: ",
    }
}

-- === INITIALISATION ===
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function()
    if DidiSaved == nil then
        DidiSaved = {
            discordLink = "https://discord.gg/tonLienIci",
            language = "fr"
        }
    end
    local lang = DidiSaved.language or "fr"
    print("|cff00ff00[DiscordLink]|r " .. L[lang].WELCOME)
end)

-- === COOLDOWN ===
local DIDI_COOLDOWN = 10
local lastSentTime = 0

-- === COMMANDE /didi ===
SLASH_DIDI1 = "/didi"
SlashCmdList["DIDI"] = function()
    local now = time()
    local lang = DidiSaved.language or "fr"
    local link = DidiSaved.discordLink or ""

    if now - lastSentTime < DIDI_COOLDOWN then
        print("|cffff0000[DiscordLink]|r " .. L[lang].COOLDOWN)
        return
    end

    lastSentTime = now
    local message = L[lang].GROUP_LINK_MESSAGE .. link

    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        SendChatMessage(message, "INSTANCE_CHAT")
    elseif IsInGroup() then
        SendChatMessage(message, "PARTY")
    elseif IsInRaid() then
        SendChatMessage(message, "RAID")
    else
        print("|cffff0000[DiscordLink]|r " .. L[lang].NOT_IN_GROUP .. link)
    end
end

-- === COMMANDE /didiui ===
SLASH_DIDIUI1 = "/didiui"
SlashCmdList["DIDIUI"] = function()
    if not DiscordLinkUIFrame then
        local frame = CreateFrame("Frame", "DiscordLinkUIFrame", UIParent, "BasicFrameTemplateWithInset")
        frame:SetSize(360, 160)
        frame:SetPoint("CENTER")
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
        frame.title:SetText(L[DidiSaved.language or "fr"].UI_TITLE)

        local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
        editBox:SetSize(280, 30)
        editBox:SetPoint("TOP", 0, -40)
        editBox:SetAutoFocus(false)
        editBox:SetText(DidiSaved.discordLink or "")

        local langLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        langLabel:SetPoint("TOPLEFT", 20, -80)
        langLabel:SetText(L[DidiSaved.language or "fr"].LANGUAGE_LABEL)

        local langDropdown = CreateFrame("Frame", "DiscordLinkLangDropdown", frame, "UIDropDownMenuTemplate")
        langDropdown:SetPoint("LEFT", langLabel, "RIGHT", -10, -5)

        local saveButton -- déclaration avant fonction SetLanguage

        local function SetLanguage(langKey)
            DidiSaved.language = langKey
            if langKey == "fr" then
                UIDropDownMenu_SetText(langDropdown, "Français")
            else
                UIDropDownMenu_SetText(langDropdown, "English")
            end
            frame.title:SetText(L[langKey].UI_TITLE)
            langLabel:SetText(L[langKey].LANGUAGE_LABEL)
            if saveButton then
                saveButton:SetText(L[langKey].SAVE_BUTTON)
            end
        end

        UIDropDownMenu_Initialize(langDropdown, function()
            local info = UIDropDownMenu_CreateInfo()
            info.text = "Français"
            info.func = function() SetLanguage("fr") end
            UIDropDownMenu_AddButton(info)

            info = UIDropDownMenu_CreateInfo()
            info.text = "English"
            info.func = function() SetLanguage("en") end
            UIDropDownMenu_AddButton(info)
        end)

        saveButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
        saveButton:SetPoint("BOTTOM", 0, 10)
        saveButton:SetSize(100, 25)
        saveButton:SetText(L[DidiSaved.language or "fr"].SAVE_BUTTON)

        saveButton:SetScript("OnClick", function()
            local newLink = editBox:GetText()
            if newLink ~= "" then
                DidiSaved.discordLink = newLink
                print("|cff00ff00[DiscordLink]|r " .. L[DidiSaved.language].LINK_UPDATED)
                frame:Hide()
            else
                print("|cffff0000[DiscordLink]|r " .. L[DidiSaved.language].LINK_EMPTY)
            end
        end)

        SetLanguage(DidiSaved.language or "fr")

        table.insert(UISpecialFrames, "DiscordLinkUIFrame")
    else
        DiscordLinkUIFrame:Show()
    end
end