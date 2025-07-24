local DIDI_PREFIX = "DIDI_SYNC"
local DIDI_COOLDOWN = 10
local lastSentTime = 0
local cooldownTimeRemaining

local L = {
    fr = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.1|r",
        DESCRIPTION = "Lien Discord à partager dans le groupe",
        BUTTON = "Enregistrer",
        LABEL = "Lien Discord :",
        GROUP_LINK_MESSAGE = "Rejoignez le Discord ici : ",
        NOT_IN_GROUP = "Vous n'êtes pas dans un groupe. Lien : ",
        COOLDOWN_WAIT = "Veuillez attendre %d secondes avant de renvoyer le lien.",
        ENABLE_INTERCOM = "Activer l’intercom",
        INVALID_LINK = "Le lien doit commencer par https://discord.gg/ ou https://discord.com/invite/",
        LANGUAGE = "Langue",
        LINK_UPDATED = "Lien mis à jour.",
        INTERCOM_TITLE = "%s partage un lien Discord :",
        HELP_TITLE = "Commandes disponibles :",
        HELP_LINE_UI = "/didiui - Ouvre le menu de configuration",
        HELP_LINE_SEND = "/didi - Envoie le lien Discord dans le chat de groupe",
        HELP_LINE_SET = "/didi set <lien> - Définit un nouveau lien Discord",
        HELP_LINE_HELP = "/didi help - Affiche cette aide"
    },
    en = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.1|r",
        DESCRIPTION = "Discord link to share in group",
        BUTTON = "Save",
        LABEL = "Discord Link:",
        GROUP_LINK_MESSAGE = "Join our Discord here: ",
        NOT_IN_GROUP = "You are not in a group. Link: ",
        COOLDOWN_WAIT = "Please wait %d seconds before resending the link.",
        ENABLE_INTERCOM = "Enable intercom",
        INVALID_LINK = "Link must start with https://discord.gg/ or https://discord.com/invite/",
        LANGUAGE = "Language",
        LINK_UPDATED = "Link updated.",
        INTERCOM_TITLE = "%s shared a Discord link:",
        HELP_TITLE = "Available commands:",
        HELP_LINE_UI = "/didiui - Opens the configuration menu",
        HELP_LINE_SEND = "/didi - Sends the Discord link to the group chat",
        HELP_LINE_SET = "/didi set <link> - Sets a new Discord link",
        HELP_LINE_HELP = "/didi help - Shows this help"
    },
    es = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.1|r",
        DESCRIPTION = "Enlace de Discord para compartir con el grupo",
        BUTTON = "Guardar",
        LABEL = "Enlace de Discord:",
        GROUP_LINK_MESSAGE = "Únete a nuestro Discord aquí: ",
        NOT_IN_GROUP = "No estás en un grupo. Enlace: ",
        COOLDOWN_WAIT = "Por favor espera %d segundos antes de reenviar el enlace.",
        ENABLE_INTERCOM = "Activar intercomunicador",
        INVALID_LINK = "El enlace debe comenzar con https://discord.gg/ o https://discord.com/invite/",
        LANGUAGE = "Idioma",
        LINK_UPDATED = "Enlace actualizado.",
        INTERCOM_TITLE = "%s compartió un enlace de Discord:",
        HELP_TITLE = "Comandos disponibles:",
        HELP_LINE_UI = "/didiui - Abre el menú de configuración",
        HELP_LINE_SEND = "/didi - Envía el enlace de Discord al chat del grupo",
        HELP_LINE_SET = "/didi set <enlace> - Define un nuevo enlace de Discord",
        HELP_LINE_HELP = "/didi help - Muestra esta ayuda"
    },
    de = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.1|r",
        DESCRIPTION = "Discord-Link zur Freigabe in der Gruppe",
        BUTTON = "Speichern",
        LABEL = "Discord-Link:",
        GROUP_LINK_MESSAGE = "Tritt unserem Discord hier bei: ",
        NOT_IN_GROUP = "Du bist nicht in einer Gruppe. Link: ",
        COOLDOWN_WAIT = "Bitte warte %d Sekunden, bevor du den Link erneut sendest.",
        ENABLE_INTERCOM = "Intercom aktivieren",
        INVALID_LINK = "Der Link muss mit https://discord.gg/ oder https://discord.com/invite/ beginnen.",
        LANGUAGE = "Sprache",
        LINK_UPDATED = "Link aktualisiert.",
        INTERCOM_TITLE = "%s hat einen Discord-Link geteilt:",
        HELP_TITLE = "Verfügbare Befehle:",
        HELP_LINE_UI = "/didiui - Öffnet das Konfigurationsmenü",
        HELP_LINE_SEND = "/didi - Sendet den Discord-Link in den Gruppenchat",
        HELP_LINE_SET = "/didi set <link> - Setzt einen neuen Discord-Link",
        HELP_LINE_HELP = "/didi help - Zeigt diese Hilfe an"
    },
    ru = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.1|r",
        DESCRIPTION = "Ссылка Discord для группы",
        BUTTON = "Сохранить",
        LABEL = "Ссылка Discord:",
        GROUP_LINK_MESSAGE = "Присоединитесь к нашему Discord здесь: ",
        NOT_IN_GROUP = "Вы не в группе. Ссылка: ",
        COOLDOWN_WAIT = "Пожалуйста, подождите %d секунд перед повторной отправкой ссылки.",
        ENABLE_INTERCOM = "Включить интерком",
        INVALID_LINK = "Ссылка должна начинаться с https://discord.gg/ или https://discord.com/invite/",
        LANGUAGE = "Язык",
        LINK_UPDATED = "Ссылка обновлена.",
        INTERCOM_TITLE = "%s поделился ссылкой на Discord:",
        HELP_TITLE = "Доступные команды:",
        HELP_LINE_UI = "/didiui - Открывает меню настроек",
        HELP_LINE_SEND = "/didi - Отправляет ссылку Discord в чат группы",
        HELP_LINE_SET = "/didi set <ссылка> - Устанавливает новую ссылку Discord",
        HELP_LINE_HELP = "/didi help - Показывает эту справку"
    }
}

local function IsValidDiscordLink(link)
    return link:match("^https://discord%.gg/[%w-_]+$") or link:match("^https://discord%.com/invite/[%w-_]+$")
end

local frame, editBox, saveButton, intercomCheckbox, langDropdown, langLabel

local function UpdateUI()
    local lang = DidiSaved.language or "fr"
    if frame then
        frame.title:SetText(L[lang].TITLE)
        frame.label:SetText(L[lang].LABEL)
        saveButton:SetText(L[lang].BUTTON)
        intercomCheckbox.text:SetText(L[lang].ENABLE_INTERCOM)
        langLabel:SetText(L[lang].LANGUAGE)
    end
end

local function CreateUI()
    frame = CreateFrame("Frame", "DiscordLinkFrame", UIParent, "BasicFrameTemplateWithInset")
    table.insert(UISpecialFrames, "DiscordLinkFrame")
    frame:SetSize(420, 240) -- élargi pour le dropdown et labels
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)

    editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox:SetSize(200, 20)
    editBox:SetPoint("TOP", frame, "TOP", 0, -50)
    editBox:SetAutoFocus(false)

    frame.label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.label:SetPoint("BOTTOM", editBox, "TOP", 0, 5)

    saveButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    saveButton:SetPoint("BOTTOM", frame, "BOTTOM", 60, 25)
    saveButton:SetSize(120, 25)
    saveButton:SetScript("OnClick", function()
        local newLink = editBox:GetText()
        local lang = DidiSaved.language or "fr"
        if IsValidDiscordLink(newLink) then
            DidiSaved.discordLink = newLink
            print("|cff00ff00[DiscordLink]|r " .. L[lang].LINK_UPDATED)
        else
            print("|cffff0000[DiscordLink]|r " .. L[lang].INVALID_LINK)
        end
    end)

    intercomCheckbox = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    intercomCheckbox:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 30)
    intercomCheckbox:SetScript("OnClick", function(self)
        DidiSaved.intercomEnabled = self:GetChecked()
    end)

    intercomCheckbox.text = intercomCheckbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    intercomCheckbox.text:SetPoint("LEFT", intercomCheckbox, "RIGHT", 5, 0)

    langDropdown = CreateFrame("Frame", "DiscordLangDropdown", frame, "UIDropDownMenuTemplate")
    langDropdown:SetPoint("BOTTOM", saveButton, "TOP", 0, 5)
    UIDropDownMenu_SetWidth(langDropdown, 120)
    UIDropDownMenu_Initialize(langDropdown, function(self, level)
        local function createLangOption(code, label)
            local info = UIDropDownMenu_CreateInfo()
            info.text = label
            info.func = function()
                DidiSaved.language = code
                UIDropDownMenu_SetText(langDropdown, label)
                UpdateUI()
            end
            UIDropDownMenu_AddButton(info)
        end
        createLangOption("fr", "Français")
        createLangOption("en", "English")
        createLangOption("es", "Español")
        createLangOption("de", "Deutsch")
        createLangOption("ru", "Русский")
    end)
    UIDropDownMenu_SetText(langDropdown, DidiSaved.language and (DidiSaved.language == "fr" and "Français" or "English") or "Français")

    langLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    langLabel:SetPoint("BOTTOM", langDropdown, "TOP", 0, 5)

    UpdateUI()
end

local cooldownFrame, cooldownTimeRemaining
local intercomAlert

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("CHAT_MSG_ADDON")

f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not DidiSaved then DidiSaved = {} end
        if not DidiSaved.discordLink then DidiSaved.discordLink = "https://discord.gg/" end
        if not DidiSaved.language then DidiSaved.language = "fr" end
        if DidiSaved.intercomEnabled == nil then DidiSaved.intercomEnabled = true end

        C_ChatInfo.RegisterAddonMessagePrefix(DIDI_PREFIX)

        CreateUI()

SLASH_DIDI1 = "/didi"
SlashCmdList["DIDI"] = function(msg)
    local lang = DidiSaved.language or "fr"
    local args = {}
    for word in msg:gmatch("%S+") do
        table.insert(args, word)
    end
    local command = args[1] and args[1]:lower()
    local link = args[2]

    if command == "help" then
        print("|cFF5865F2DiscordLink|r " .. L[lang].HELP_TITLE)
        print(" - " .. L[lang].HELP_LINE_UI)
        print(" - " .. L[lang].HELP_LINE_SEND)
        print(" - " .. L[lang].HELP_LINE_SET)
        print(" - " .. L[lang].HELP_LINE_HELP)
        return
    end

    if command == "set" and link then
        if IsValidDiscordLink(link) then
            DidiSaved.discordLink = link
            print("|cff00ff00[DiscordLink]|r " .. L[lang].LINK_UPDATED)
        else
            print("|cffff0000[DiscordLink]|r " .. L[lang].INVALID_LINK)
        end
        return
    end

    -- Code existant de cooldown / envoi
    local now = time()
    local savedLink = DidiSaved.discordLink or ""
    local remaining = DIDI_COOLDOWN - (now - lastSentTime)

    if remaining > 0 then
        print("|cffff0000[DiscordLink]|r " .. string.format(L[lang].COOLDOWN_WAIT, remaining))
        cooldownTimeRemaining = remaining
        cooldownFrame:Show()
        return
    end

    if not IsValidDiscordLink(savedLink) then
        print("|cffff0000[DiscordLink]|r " .. L[lang].INVALID_LINK)
        return
    end

    lastSentTime = now
    local message = L[lang].GROUP_LINK_MESSAGE .. savedLink

    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        SendChatMessage(message, "INSTANCE_CHAT")
    elseif IsInRaid() then
        SendChatMessage(message, "RAID")
    elseif IsInGroup() then
        SendChatMessage(message, "PARTY")
    else
        print("|cffff0000[DiscordLink]|r " .. L[lang].NOT_IN_GROUP .. savedLink)
    end

    if DidiSaved.intercomEnabled and (IsInGroup() or IsInRaid()) then
        C_ChatInfo.SendAddonMessage(DIDI_PREFIX, savedLink, "RAID")
    end
end

        SLASH_DIDIUI1 = "/didiui"
        SlashCmdList["DIDIUI"] = function()
            if frame:IsShown() then
                frame:Hide()
            else
                editBox:SetText(DidiSaved.discordLink or "")
                intercomCheckbox:SetChecked(DidiSaved.intercomEnabled)
                UIDropDownMenu_SetText(langDropdown, DidiSaved.language and (DidiSaved.language == "fr" and "Français" or "English") or "Français")
                frame:Show()
            end
        end

        cooldownFrame = CreateFrame("Frame", nil, UIParent)
        cooldownFrame:SetScript("OnUpdate", function(self, elapsed)
            if cooldownTimeRemaining then
                cooldownTimeRemaining = cooldownTimeRemaining - elapsed
                if cooldownTimeRemaining <= 0 then
                    self:Hide()
                    cooldownTimeRemaining = nil
                end
            end
        end)
        cooldownFrame:Hide()

        intercomAlert = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        intercomAlert:SetSize(360, 80)
        intercomAlert:SetPoint("TOP", UIParent, "TOP", 0, -200)
        intercomAlert:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        intercomAlert:SetBackdropColor(0, 0, 0, 0.75)
        intercomAlert:Hide()

        intercomAlert.title = intercomAlert:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        intercomAlert.title:SetPoint("TOP", 0, -10)

        intercomAlert.link = intercomAlert:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        intercomAlert.link:SetPoint("TOP", intercomAlert.title, "BOTTOM", 0, -10)

        -- Gestion de la touche ECHAP pour fermer la fenêtre
        frame:SetPropagateKeyboardInput(true)
        frame:SetScript("OnKeyDown", function(self, key)
            if key == "ESCAPE" then
                self:Hide()
            end
        end)

    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        if prefix == DIDI_PREFIX and sender ~= UnitName("player") and DidiSaved.intercomEnabled then
            local lang = DidiSaved.language or "fr"
            print("|cff00ff00[DiscordLink]|r " .. sender .. " : " .. L[lang].GROUP_LINK_MESSAGE .. message)

            if DidiSaved.intercomEnabled then
                local titleText = L[lang] and L[lang].INTERCOM_TITLE and string.format(L[lang].INTERCOM_TITLE, sender)
                    or (sender .. " shared a Discord link:")

                intercomAlert.title:SetText(titleText)
                intercomAlert.link:SetText("|cff00ccff" .. message .. "|r")
                intercomAlert:Show()

                C_Timer.After(6, function()
                    intercomAlert:Hide()
                end)
            end
        end
    end
end)