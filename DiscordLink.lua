-- DiscordLink Addon (version 3 liens + checkbox exclusives)
local DIDI_PREFIX = "DIDI_SYNC"
local DIDI_COOLDOWN = 10
local lastSentTime = 0
local cooldownTimeRemaining

-- UI objects (déclarés en scope global local)
local frame, editBox, editBox2, editBox3
local saveButton, shareButton
local intercomCheckbox, soundCheckbox
local langDropdown, langLabel
local checkbox1, checkbox2, checkbox3
local cooldownFrame, intercomAlert

local L = {
    fr = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.3|r",
        DESCRIPTION = "Lien Discord à partager dans le groupe",
        BUTTON = "Enregistrer",
        BUTTON_SHARE = "Partager",
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
        HELP_LINE_HELP = "/didi help - Affiche cette aide",
        SOUND_ENABLE = "Son de l'intercom"
    },
    en = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.3|r",
        DESCRIPTION = "Discord link to share in group",
        BUTTON = "Save",
        BUTTON_SHARE = "Share",
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
        HELP_LINE_HELP = "/didi help - Shows this help",
        SOUND_ENABLE = "Intercom sound"
    },
    es = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.3|r",
        DESCRIPTION = "Enlace de Discord para compartir con el grupo",
        BUTTON = "Guardar",
        BUTTON_SHARE = "Compartir",
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
        HELP_LINE_HELP = "/didi help - Muestra esta ayuda",
        SOUND_ENABLE = "Sonido del intercomunicador"
    },
    de = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.3|r",
        DESCRIPTION = "Discord-Link zur Freigabe in der Gruppe",
        BUTTON = "Speichern",
        BUTTON_SHARE = "Teilen",
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
        HELP_LINE_HELP = "/didi help - Zeigt diese Hilfe an",
        SOUND_ENABLE = "Intercom-Sound"
    },
    ru = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96Version 2.3|r",
        DESCRIPTION = "Ссылка Discord для группы",
        BUTTON = "Сохранить",
        BUTTON_SHARE = "Поделиться",
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
        HELP_LINE_HELP = "/didi help - Показывает эту справку",
        SOUND_ENABLE = "Звук интеркома"
    },
    zh = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96版本 2.3|r",
        DESCRIPTION = "在小队中分享的 Discord 链接",
        BUTTON = "保存",
        BUTTON_SHARE = "分享",
        LABEL = "Discord 链接：",
        GROUP_LINK_MESSAGE = "在这里加入我们的 Discord：",
        NOT_IN_GROUP = "你不在小队中。链接：",
        COOLDOWN_WAIT = "请等待 %d 秒后再发送链接。",
        ENABLE_INTERCOM = "启用对讲机",
        INVALID_LINK = "链接必须以 https://discord.gg/ 或 https://discord.com/invite/ 开头。",
        LANGUAGE = "语言",
        LINK_UPDATED = "链接已更新。",
        INTERCOM_TITLE = "%s 分享了一个 Discord 链接：",
        HELP_TITLE = "可用命令：",
        HELP_LINE_UI = "/didiui - 打开设置菜单",
        HELP_LINE_SEND = "/didi - 发送 Discord 链接到小队聊天",
        HELP_LINE_SET = "/didi set <链接> - 设置新的 Discord 链接",
        HELP_LINE_HELP = "/didi help - 显示此帮助信息",
        SOUND_ENABLE = "对讲声音"
    },
    ko = {
        TITLE = "|cFF5865F2DiscordLink|r |cff00ff96버전 2.3|r",
        DESCRIPTION = "그룹에서 공유할 Discord 링크",
        BUTTON = "저장",
        BUTTON_SHARE = "공유",
        LABEL = "Discord 링크:",
        GROUP_LINK_MESSAGE = "여기에서 Discord에 참여하세요: ",
        NOT_IN_GROUP = "그룹에 속해 있지 않습니다. 링크: ",
        COOLDOWN_WAIT = "%d초 후에 다시 링크를 보낼 수 있습니다.",
        ENABLE_INTERCOM = "인터콤 활성화",
        INVALID_LINK = "링크는 https://discord.gg/ 또는 https://discord.com/invite/ 로 시작해야 합니다.",
        LANGUAGE = "언어",
        LINK_UPDATED = "링크가 업데이트되었습니다.",
        INTERCOM_TITLE = "%s 님이 Discord 링크를 공유했습니다:",
        HELP_TITLE = "사용 가능한 명령어:",
        HELP_LINE_UI = "/didiui - 설정 메뉴 열기",
        HELP_LINE_SEND = "/didi - 그룹 채팅에 Discord 링크 보내기",
        HELP_LINE_SET = "/didi set <링크> - 새로운 Discord 링크 설정",
        HELP_LINE_HELP = "/didi help - 이 도움말 표시",
        SOUND_ENABLE = "인터콤 소리"
    }
}

-- Validation de lien Discord (acceptant https et optionnel www)
local function IsValidDiscordLink(link)
    if not link or type(link) ~= "string" then
        return false
    end
    local s = link:lower()
    -- accepte https://discord.gg/..., https://www.discord.gg/..., https://discord.com/invite/..., https://www.discord.com/invite/...
    if s:match("^https://discord%.gg/") or s:match("^https://www%.discord%.gg/") then
        return true
    end
    if s:match("^https://discord%.com/invite/") or s:match("^https://www%.discord%.com/invite/") then
        return true
    end
    return false
end

local function GetCurrentLang()
    if DidiSaved and DidiSaved.language and L[DidiSaved.language] then
        return DidiSaved.language
    end
    return "fr"
end

-- retourne le label affiché pour le dropdown
local function GetLanguageLabel(code)
    if code == "fr" then return "Français" end
    if code == "en" then return "English" end
    if code == "es" then return "Español" end
    if code == "de" then return "Deutsch" end
    if code == "ru" then return "Русский" end
    if code == "ko" then return "한국어" end
    if code == "zh" then return "中文" end
    return "Français"
end

-- Met à jour le texte UI selon la langue
local function UpdateUI()
    local lang = GetCurrentLang()
    if not frame then return end

    frame.title:SetText(L[lang].TITLE)
    frame.label:SetText(L[lang].LABEL)
    saveButton:SetText(L[lang].BUTTON)
    shareButton:SetText(L[lang].BUTTON_SHARE)
    intercomCheckbox.text:SetText(L[lang].ENABLE_INTERCOM)
    langLabel:SetText(L[lang].LANGUAGE)
    if soundCheckbox then
        soundCheckbox.text:SetText(L[lang].SOUND_ENABLE)
    end

    -- labels pour les champs supplémentaires (simple numérotation)
    if frame.label2 then
        frame.label2:SetText(L[lang].LABEL .. " 2:")
    end
    if frame.label3 then
        frame.label3:SetText(L[lang].LABEL .. " 3:")
    end
end

-- Active un lien (radio-style) : met à jour DidiSaved.activeLink et cases cochées
local function SetActiveLink(id)
    if not DidiSaved then DidiSaved = {} end
    DidiSaved.activeLink = id or 1
    if checkbox1 then checkbox1:SetChecked(DidiSaved.activeLink == 1) end
    if checkbox2 then checkbox2:SetChecked(DidiSaved.activeLink == 2) end
    if checkbox3 then checkbox3:SetChecked(DidiSaved.activeLink == 3) end
end

-- Fonction centralisée d'envoi (appelée par /didi et par le bouton "Partager")
local function SendDiscordLink()
    if not DidiSaved then DidiSaved = {} end
    local lang = GetCurrentLang()
    local now = GetTime()
    local remaining = DIDI_COOLDOWN - (now - lastSentTime)

    if remaining > 0 then
        print("|cffff0000[DiscordLink]|r " .. string.format(L[lang].COOLDOWN_WAIT, math.ceil(remaining)))
        cooldownTimeRemaining = remaining
        if cooldownFrame then cooldownFrame:Show() end
        return
    end

    local linkID = DidiSaved.activeLink or 1
    local savedLink =
        (linkID == 1 and DidiSaved.discordLink) or
        (linkID == 2 and DidiSaved.discordLink2) or
        (linkID == 3 and DidiSaved.discordLink3) or
        DidiSaved.discordLink

    savedLink = savedLink or ""

    if not IsValidDiscordLink(savedLink) then
        print("|cffff0000[DiscordLink]|r " .. L[lang].INVALID_LINK)
        return
    end

    lastSentTime = now
    local message = L[lang].GROUP_LINK_MESSAGE .. savedLink

    -- envoi dans le bon canal de groupe
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        SendChatMessage(message, "INSTANCE_CHAT")
    elseif IsInRaid() then
        SendChatMessage(message, "RAID")
    elseif IsInGroup() then
        SendChatMessage(message, "PARTY")
    else
        print("|cffff0000[DiscordLink]|r " .. L[lang].NOT_IN_GROUP .. savedLink)
    end

    -- envoi intercom (addon message) si activé : choisit le channel adapté
    if DidiSaved.intercomEnabled then
        local ok, err = pcall(function()
            local channel = nil
            if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
                channel = "INSTANCE_CHAT"
            elseif IsInRaid() then
                channel = "RAID"
            elseif IsInGroup() then
                channel = "PARTY"
            end
            if channel then
                C_ChatInfo.SendAddonMessage(DIDI_PREFIX, savedLink, channel)
            end
        end)
        if not ok then
            -- ne pas spammer l'utilisateur en cas d'erreur non critique
            -- print("|cffff0000[DiscordLink]|r Erreur intercom : " .. tostring(err))
        end
    end
end

-- Crée l'UI principale et widgets
local function CreateUI()
    frame = CreateFrame("Frame", "DiscordLinkFrame", UIParent, "BasicFrameTemplateWithInset")
    table.insert(UISpecialFrames, "DiscordLinkFrame")
    frame:SetSize(600, 325)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)

    -- EditBox 1
    editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox:SetSize(260, 24)
    editBox:SetPoint("TOP", frame, "TOP", -60, -50)
    editBox:SetAutoFocus(false)

    frame.label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.label:SetPoint("BOTTOM", editBox, "TOP", 0, 5)

    -- Checkbox 1 (à côté du editbox1)
    checkbox1 = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    checkbox1:SetPoint("LEFT", editBox, "RIGHT", 10, 0)
    checkbox1:SetScript("OnClick", function() SetActiveLink(1) end)

    -- EditBox 2
    editBox2 = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox2:SetSize(260, 24)
    editBox2:SetPoint("TOP", editBox, "BOTTOM", 0, -40)
    editBox2:SetAutoFocus(false)

    frame.label2 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.label2:SetPoint("BOTTOM", editBox2, "TOP", 0, 5)

    checkbox2 = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    checkbox2:SetPoint("LEFT", editBox2, "RIGHT", 10, 0)
    checkbox2:SetScript("OnClick", function() SetActiveLink(2) end)

    -- EditBox 3
    editBox3 = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox3:SetSize(260, 24)
    editBox3:SetPoint("TOP", editBox2, "BOTTOM", 0, -40)
    editBox3:SetAutoFocus(false)

    frame.label3 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.label3:SetPoint("BOTTOM", editBox3, "TOP", 0, 5)

    checkbox3 = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    checkbox3:SetPoint("LEFT", editBox3, "RIGHT", 10, 0)
    checkbox3:SetScript("OnClick", function() SetActiveLink(3) end)




    -- Bouton Save
    saveButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    saveButton:SetPoint("BOTTOM", frame, "BOTTOM", 60, 25)
    saveButton:SetSize(120, 25)
    saveButton:SetScript("OnClick", function()
        local lang = GetCurrentLang()
        -- récupérer textes
        local l1 = editBox:GetText() or ""
        local l2 = editBox2:GetText() or ""
        local l3 = editBox3:GetText() or ""
        local updated = false

        if l1 ~= "" then
            if IsValidDiscordLink(l1) then
                DidiSaved.discordLink = l1
                updated = true
            else
                print("|cffff0000[DiscordLink]|r " .. L[lang].INVALID_LINK .. " (1)")
            end
        end
        if l2 ~= "" then
            if IsValidDiscordLink(l2) then
                DidiSaved.discordLink2 = l2
                updated = true
            else
                print("|cffff0000[DiscordLink]|r " .. L[lang].INVALID_LINK .. " (2)")
            end
        end
        if l3 ~= "" then
            if IsValidDiscordLink(l3) then
                DidiSaved.discordLink3 = l3
                updated = true
            else
                print("|cffff0000[DiscordLink]|r " .. L[lang].INVALID_LINK .. " (3)")
            end
        end

        if updated then
            print("|cff00ff00[DiscordLink]|r " .. L[lang].LINK_UPDATED)
        else
            -- si rien de valide fourni, on ne change rien
            -- mais on peut informer l'utilisateur
            -- print("|cffffff00[DiscordLink]|r Aucun lien valide fourni.")
        end
    end)

        -- Bouton "Partager" (envoie /didi)
shareButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
shareButton:SetSize(120, 25)
shareButton:SetPoint("LEFT", saveButton, "RIGHT", 8, 0)
shareButton:SetScript("OnClick", function()
    SendDiscordLink()
end)

    -- Intercom checkbox
    intercomCheckbox = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    intercomCheckbox:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 30)
    intercomCheckbox:SetScript("OnClick", function(self) DidiSaved.intercomEnabled = self:GetChecked() end)
    intercomCheckbox.text = intercomCheckbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    intercomCheckbox.text:SetPoint("LEFT", intercomCheckbox, "RIGHT", 5, 0)

    -- Sound checkbox
    soundCheckbox = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    soundCheckbox:SetPoint("BOTTOMLEFT", intercomCheckbox, "BOTTOMLEFT", 0, -25)
    soundCheckbox:SetScript("OnClick", function(self) DidiSaved.soundEnabled = self:GetChecked() end)
    soundCheckbox.text = soundCheckbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    soundCheckbox.text:SetPoint("LEFT", soundCheckbox, "RIGHT", 5, 0)

    -- Dropdown langue
    langDropdown = CreateFrame("Frame", "DiscordLangDropdown", frame, "UIDropDownMenuTemplate")
    langDropdown:SetPoint("BOTTOM", saveButton, "TOP", 0, 0)
    UIDropDownMenu_SetWidth(langDropdown, 140)

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
        createLangOption("ko", "한국어")
        createLangOption("zh", "中文")
    end)

    langLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    langLabel:SetPoint("BOTTOM", langDropdown, "TOP", 0, 5)

    UpdateUI()
end

-- Frame principal pour events
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("CHAT_MSG_ADDON")

f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- defaults safe
        if not DidiSaved then DidiSaved = {} end
        if not DidiSaved.discordLink then DidiSaved.discordLink = "https://discord.gg/" end
        if not DidiSaved.discordLink2 then DidiSaved.discordLink2 = "https://discord.gg/" end
        if not DidiSaved.discordLink3 then DidiSaved.discordLink3 = "https://discord.gg/" end
        if not DidiSaved.language then DidiSaved.language = "fr" end
        if DidiSaved.intercomEnabled == nil then DidiSaved.intercomEnabled = true end
        if DidiSaved.soundEnabled == nil then DidiSaved.soundEnabled = true end
        if not DidiSaved.activeLink then DidiSaved.activeLink = 1 end

        -- enregistrer prefix addon
        C_ChatInfo.RegisterAddonMessagePrefix(DIDI_PREFIX)

        -- crée l'UI
        CreateUI()

        -- slash commands (déclarées après PLAYER_LOGIN)
        SLASH_DIDI1 = "/didi"
        SlashCmdList["DIDI"] = function(msg)
            local lang = GetCurrentLang()
            local args = {}
            for word in msg:gmatch("%S+") do table.insert(args, word) end
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
                    -- set for currently active link
                    if not DidiSaved then DidiSaved = {} end
                    local id = DidiSaved.activeLink or 1
                    if id == 1 then DidiSaved.discordLink = link
                    elseif id == 2 then DidiSaved.discordLink2 = link
                    elseif id == 3 then DidiSaved.discordLink3 = link end
                    print("|cff00ff00[DiscordLink]|r " .. L[lang].LINK_UPDATED)
                else
                    print("|cffff0000[DiscordLink]|r " .. L[lang].INVALID_LINK)
                end
                return
            end

            -- appel centralisé
            SendDiscordLink()
        end

        SLASH_DIDIUI1 = "/didiui"
        SlashCmdList["DIDIUI"] = function()
            if frame:IsShown() then
                frame:Hide()
            else
                -- remplir champs
                editBox:SetText(DidiSaved.discordLink or "")
                editBox2:SetText(DidiSaved.discordLink2 or "")
                editBox3:SetText(DidiSaved.discordLink3 or "")
                if intercomCheckbox then intercomCheckbox:SetChecked(DidiSaved.intercomEnabled) end
                if soundCheckbox then soundCheckbox:SetChecked(DidiSaved.soundEnabled) end

                -- dropdown texte
                UIDropDownMenu_SetText(langDropdown, GetLanguageLabel(DidiSaved.language or "fr"))

                -- checkboxes selon activeLink
                SetActiveLink(DidiSaved.activeLink or 1)

                frame:Show()
            end
        end

        -- initial states widgets
        if intercomCheckbox then intercomCheckbox:SetChecked(DidiSaved.intercomEnabled) end
        if soundCheckbox then soundCheckbox:SetChecked(DidiSaved.soundEnabled) end
        SetActiveLink(DidiSaved.activeLink or 1)

        -- cooldown frame pour comptage visuel (silencieux)
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

        -- pop intercom
        intercomAlert = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        intercomAlert:SetSize(360, 80)
        intercomAlert:SetPoint("TOP", UIParent, "TOP", 0, -200)
        intercomAlert:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = {left = 3, right = 3, top = 3, bottom = 3}
        })
        intercomAlert:SetBackdropColor(0, 0, 0, 0.75)
        intercomAlert:Hide()

        intercomAlert.title = intercomAlert:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        intercomAlert.title:SetPoint("TOP", 0, -10)

        intercomAlert.link = intercomAlert:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        intercomAlert.link:SetPoint("TOP", intercomAlert.title, "BOTTOM", 0, -10)

        -- fermer ESC
        frame:SetPropagateKeyboardInput(true)
        frame:SetScript("OnKeyDown", function(self, key)
            if key == "ESCAPE" then self:Hide() end
        end)

    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        if prefix == DIDI_PREFIX and sender ~= UnitName("player") and DidiSaved and DidiSaved.intercomEnabled then
            local lang = GetCurrentLang()
            print("|cff00ff00[DiscordLink]|r " .. sender .. " : " .. L[lang].GROUP_LINK_MESSAGE .. message)

            local titleText = (L[lang] and L[lang].INTERCOM_TITLE and string.format(L[lang].INTERCOM_TITLE, sender)) or (sender .. " shared a Discord link:")
            intercomAlert.title:SetText(titleText)
            intercomAlert.link:SetText("|cff00ccff" .. message .. "|r")

            if DidiSaved.soundEnabled then
                local ok, err = pcall(function()
                    if PlaySound and SOUNDKIT and SOUNDKIT.RAID_WARNING then
                        PlaySound(SOUNDKIT.RAID_WARNING, "Master")
                    elseif PlaySoundFile then
                        PlaySoundFile("Sound\\Interface\\RaidWarning.ogg", "Master")
                    end
                end)
                if not ok then
                    print("|cffff0000[DiscordLink]|r Erreur audio : " .. tostring(err))
                end
            end

            intercomAlert:Show()
            C_Timer.After(6, function() intercomAlert:Hide() end)
        end
    end
end)
