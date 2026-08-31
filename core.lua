local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Core = {}
local HUB_VERSION = "v1.5"
local CONFIG_FILE = "C4Hub_Config.json"

local ALL_KEYS = {
    "P", "RightShift", "LeftShift", "Insert", "Home", "End", "PageUp", "PageDown",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
    "N", "O", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Zero",
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
    "LeftControl", "RightControl", "LeftAlt", "RightAlt", "Tab", "CapsLock",
    "Up", "Down", "Left", "Right", "Slash", "Period", "Comma", "Semicolon",
    "LeftBracket", "RightBracket", "Minus", "Equals", "Quote", "Backslash",
    "Backspace", "Delete", "Escape", "Space", "Return", "Backquote",
}

local KEY_VALID_MAP = {}
for _, k in ipairs(ALL_KEYS) do
    KEY_VALID_MAP[k] = true
end

local DEFAULT_CONFIG = {
    Theme = "Violet",
    AutoReconnect = false,
    Language = "TH",
    Transparency = 0,
    ToggleUIKey = "P",
}

local CONFIG_VALIDATORS = {
    Theme = function(v)
        local valid = { Dark = true, Light = true, Emerald = true, Plant = true, Midnight = true, Violet = true, Rose = true, MonokaiPro = true }
        return type(v) == "string" and valid[v] and v or nil
    end,
    AutoReconnect = function(v)
        return type(v) == "boolean" and v or nil
    end,
    Language = function(v)
        return (v == "TH" or v == "EN") and v or nil
    end,
    Transparency = function(v)
        if type(v) ~= "number" then return nil end
        if v < 0 then v = 0 end
        if v > 80 then v = 80 end
        return v
    end,
    ToggleUIKey = function(v)
        return type(v) == "string" and KEY_VALID_MAP[v] and v or nil
    end,
}

local LANG = {
    TH = {
        home = "หน้าแรก",
        profileSection = "โปรไฟล์ผู้เล่น",
        version = "เวอร์ชั่น ",
        discord = "เข้าร่วม Discord",
        discordCopied = "คัดลอกลิงก์แล้ว",
        discordDesc = "วางในเบราว์เซอร์เพื่อเข้าร่วม Discord",
        discordFallback = "คัดลอกอัตโนมัติไม่ได้ กรุณาพิมพ์ลิงก์เอง: ",
        settings = "การตั้งค่า",
        general = "การตั้งค่าทั่วไป",
        generalDesc = "ปรับแต่งการทำงานของ Hub",
        theme = "ธีม",
        connection = "การเชื่อมต่อ",
        connectionDesc = "จัดการการหลุดเซิร์ฟเวอร์",
        autoreconnect = "Auto Reconnect",
        autoreconnectDesc = "เข้าเกมใหม่อัตโนมัติถ้าหลุดเซิร์ฟเวอร์",
        language = "ภาษา",
        languageDesc = "มีผลกับหน้าแรกและการตั้งค่า (ต้องเข้าเกมใหม่ถึงจะเห็นผลเต็มที่)",
        appearance = "รูปลักษณ์",
        appearanceDesc = "ปรับความโปร่งใสของหน้าต่าง Hub",
        transparency = "ความโปร่งใส",
        keybindSection = "ปุ่มลัด",
        keybindDesc = "กดที่กรอบปุ่มเพื่อตั้งค่าใหม่",
        toggleUIKey = "ปุ่มซ่อน/เปิด Hub",
        stats = "แสดงสถิติ",
        statsDesc = "โชว์กรอบ FPS/Ping มุมจอ",
        showStats = "แสดง FPS/Ping",
        configSection = "การตั้งค่าที่บันทึกไว้",
        configDesc = "บันทึก/รีเซ็ตการตั้งค่าทั้งหมด",
        saveConfig = "บันทึกการตั้งค่า",
        savedMsg = "บันทึกการตั้งค่าแล้ว",
        resetConfig = "รีเซ็ตการตั้งค่าทั้งหมด",
        resetMsg = "รีเซ็ตเรียบร้อยแล้ว เข้าเกมใหม่เพื่อให้มีผลเต็มที่",
        togglehub = "ซ่อน/เปิด Hub",
        transparencyUnsupported = "WindUI เวอร์ชันนี้ยังไม่รองรับการปรับความโปร่งใส",
        uiHidden = "Hub ถูกซ่อนแล้ว",
        uiShown = "Hub แสดงแล้ว",
        pressAnyKey = "กดปุ่มที่ต้องการบนคีย์บอร์ด...",
        keybindSet = "ตั้งค่าเป็น: ",
        keybindCancelled = "ยกเลิกการตั้งค่า",
    },
    EN = {
        home = "Home",
        profileSection = "Player Profile",
        version = "Version ",
        discord = "Join Discord",
        discordCopied = "Link copied",
        discordDesc = "Paste it in your browser to join Discord",
        discordFallback = "Couldn\'t copy automatically. Please copy this link manually: ",
        settings = "Settings",
        general = "General Settings",
        generalDesc = "Customize how the Hub works",
        theme = "Theme",
        connection = "Connection",
        connectionDesc = "Manage server disconnects",
        autoreconnect = "Auto Reconnect",
        autoreconnectDesc = "Auto rejoin if you get disconnected",
        language = "Language",
        languageDesc = "Affects Home and Settings tabs (rejoin for full effect)",
        appearance = "Appearance",
        appearanceDesc = "Adjust the Hub window transparency",
        transparency = "Transparency",
        keybindSection = "Keybind",
        keybindDesc = "Click the key box to set a new key",
        toggleUIKey = "Toggle UI key",
        stats = "Show Stats",
        statsDesc = "Show an FPS/Ping overlay on screen",
        showStats = "Show FPS/Ping",
        configSection = "Saved Settings",
        configDesc = "Save/reset all settings",
        saveConfig = "Save Settings",
        savedMsg = "Settings saved",
        resetConfig = "Reset All Settings",
        resetMsg = "Reset done. Rejoin for full effect.",
        togglehub = "Toggle Hub",
        transparencyUnsupported = "This WindUI version does not support transparency yet",
        uiHidden = "Hub is now hidden",
        uiShown = "Hub is now visible",
        pressAnyKey = "Press any key on your keyboard...",
        keybindSet = "Set to: ",
        keybindCancelled = "Keybind cancelled",
    },
}

local function LoadConfig()
    local cfg = {}
    for k, v in pairs(DEFAULT_CONFIG) do
        cfg[k] = v
    end
    local needsResave = false
    if isfile and isfile(CONFIG_FILE) then
        local ok, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(CONFIG_FILE))
        end)
        if ok and type(data) == "table" then
            for k, validate in pairs(CONFIG_VALIDATORS) do
                local raw = data[k]
                if raw == nil then
                    needsResave = true
                else
                    local clean = validate(raw)
                    if clean == nil then
                        needsResave = true
                    else
                        cfg[k] = clean
                    end
                end
            end
        else
            needsResave = true
        end
    end
    return cfg, needsResave
end

local function SaveConfigToFile(cfg)
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, game:GetService("HttpService"):JSONEncode(cfg))
        end)
    end
end

do
    local cfg, needsResave = LoadConfig()
    Core.Config = cfg
    if needsResave then
        SaveConfigToFile(Core.Config)
    end
end

local TITLE_TEXT_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHex("#B39CFF")),
    ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8A5CFF")),
    ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF")),
})

local function TryGetWindowBackground()
    local ok, bg = pcall(function()
        return WindUI:Gradient({
            ["0"] = { Color = Color3.fromHex("#150826"), Transparency = 0 },
            ["100"] = { Color = Color3.fromHex("#C9B8FF"), Transparency = 0.75 },
        }, {
            Rotation = 90,
        })
    end)
    if ok then
        return bg
    end
    return nil
end

local function TryStyleTitleText(titleString)
    task.spawn(function()
        task.wait(0.5)
        pcall(function()
            local Players = game:GetService("Players")
            local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    for _, obj in ipairs(gui:GetDescendants()) do
                        if obj:IsA("TextLabel") and obj.Text == titleString then
                            local gradient = obj:FindFirstChildOfClass("UIGradient")
                            if not gradient then
                                gradient = Instance.new("UIGradient")
                                gradient.Parent = obj
                            end
                            gradient.Color = TITLE_TEXT_GRADIENT
                            obj.TextColor3 = Color3.fromHex("#FFFFFF")
                        end
                    end
                end
            end
        end)
    end)
end

function Core.Init(mapName)
    local T = LANG[Core.Config.Language] or LANG.TH
    local windowTitle = "C4rDev Hub X " .. mapName
    local windowOptions = {
        Title = windowTitle,
        Icon = "rbxthumb://type=Asset&id=81755635423577&w=420&h=420",
        Theme = Core.Config.Theme,
    }
    local bg = TryGetWindowBackground()
    if bg then
        windowOptions.Background = bg
    end
    local Window = WindUI:CreateWindow(windowOptions)
    TryStyleTitleText(windowTitle)

    Core._Window = Window
    Core._isUIOpen = true

    local UserInputService = game:GetService("UserInputService")
    local toggleConn
    toggleConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local keyEnum = Enum.KeyCode[Core.Config.ToggleUIKey]
            if keyEnum and input.KeyCode == keyEnum then
                Core._isUIOpen = not Core._isUIOpen
                pcall(function()
                    if Core._isUIOpen then
                        Window:Show()
                    else
                        Window:Hide()
                    end
                end)
            end
        end
    end)
    Core._toggleConn = toggleConn

    return Window, WindUI
end

function Core.Settings(Window, WindUI)
    local T = LANG[Core.Config.Language] or LANG.TH
    local Players = game:GetService("Players")
    local SettingsTab = Window:Tab({ Title = T.settings, Icon = "settings" })
    SettingsTab:Section({ Title = T.general, Desc = T.generalDesc })
    SettingsTab:Dropdown({
        Title = T.theme,
        Values = { "Dark", "Light", "Emerald", "Plant", "Midnight", "Violet", "Rose", "MonokaiPro" },
        Value = Core.Config.Theme,
        Callback = function(selected)
            Core.Config.Theme = selected
            WindUI:SetTheme(selected)
        end,
    })
    SettingsTab:Section({ Title = T.connection, Desc = T.connectionDesc })
    local TeleportService = game:GetService("TeleportService")
    SettingsTab:Toggle({
        Title = T.autoreconnect,
        Desc = T.autoreconnectDesc,
        Value = Core.Config.AutoReconnect,
        Callback = function(state)
            Core.Config.AutoReconnect = state
            WindUI:Notify({
                Title = T.settings,
                Content = T.autoreconnect .. ": " .. (state and "ON" or "OFF"),
                Duration = 2,
            })
        end,
    })
    game:BindToClose(function()
        if Core.Config.AutoReconnect then
            pcall(function()
                TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
            end)
        end
    end)
    SettingsTab:Section({ Title = T.language, Desc = T.languageDesc })
    SettingsTab:Dropdown({
        Title = T.language,
        Values = { "TH", "EN" },
        Value = Core.Config.Language,
        Callback = function(selected)
            Core.Config.Language = selected
        end,
    })
    SettingsTab:Section({ Title = T.appearance, Desc = T.appearanceDesc })
    SettingsTab:Slider({
        Title = T.transparency,
        Value = { Min = 0, Max = 80, Default = Core.Config.Transparency },
        Callback = function(value)
            Core.Config.Transparency = value
            local applied = false
            pcall(function()
                Window:SetTransparency(value / 100)
                applied = true
            end)
            if not applied then
                pcall(function()
                    Window.Transparency = value / 100
                    applied = true
                end)
            end
            if not applied then
                WindUI:Notify({
                    Title = T.appearance,
                    Content = T.transparencyUnsupported,
                    Duration = 3,
                })
            end
        end,
    })

    -- ============================================
    -- CUSTOM KEYBIND COMPONENT (Rayfield Style)
    -- ============================================
    SettingsTab:Section({ Title = T.keybindSection, Desc = T.keybindDesc })

    task.spawn(function()
        task.wait(0.8)
        pcall(function()
            local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
            local sectionLabel = nil
            local targetGui = nil

            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    for _, obj in ipairs(gui:GetDescendants()) do
                        if obj:IsA("TextLabel") and obj.Text == T.keybindSection then
                            sectionLabel = obj
                            targetGui = gui
                            break
                        end
                    end
                end
                if sectionLabel then break end
            end

            if not sectionLabel then return end

            local sectionParent = sectionLabel.Parent
            if not sectionParent then return end

            -- Create Keybind Row
            local row = Instance.new("Frame")
            row.Name = "C4THKeybindRow"
            row.Size = UDim2.new(1, -20, 0, 40)
            row.BackgroundTransparency = 1
            row.Parent = sectionParent

            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -80, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = T.toggleUIKey
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row

            -- Key Box (Rayfield Style)
            local keyBox = Instance.new("TextButton")
            keyBox.Name = "KeyBox"
            keyBox.Size = UDim2.new(0, 55, 0, 28)
            keyBox.Position = UDim2.new(1, -55, 0.5, -14)
            keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            keyBox.BorderSizePixel = 0
            keyBox.Text = Core.Config.ToggleUIKey
            keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            keyBox.Font = Enum.Font.GothamBold
            keyBox.TextSize = 13
            keyBox.AutoButtonColor = true
            keyBox.Parent = row

            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = keyBox

            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromRGB(70, 70, 85)
            boxStroke.Thickness = 1
            boxStroke.Parent = keyBox

            -- Hover effects
            keyBox.MouseEnter:Connect(function()
                if not keyBox:GetAttribute("Listening") then
                    keyBox.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
                    boxStroke.Color = Color3.fromRGB(90, 90, 110)
                end
            end)

            keyBox.MouseLeave:Connect(function()
                if not keyBox:GetAttribute("Listening") then
                    keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                    boxStroke.Color = Color3.fromRGB(70, 70, 85)
                end
            end)

            -- Listening logic
            local inputConn = nil
            local cancelConn = nil

            keyBox.MouseButton1Click:Connect(function()
                if keyBox:GetAttribute("Listening") then return end
                keyBox:SetAttribute("Listening", true)
                keyBox.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
                keyBox.Text = "..."
                boxStroke.Color = Color3.fromRGB(0, 170, 255)

                WindUI:Notify({
                    Title = T.keybindSection,
                    Content = T.pressAnyKey,
                    Duration = 4,
                })

                local UserInputService = game:GetService("UserInputService")

                inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

                    local keyName = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")

                    -- Validate key
                    if not KEY_VALID_MAP[keyName] then
                        keyName = "P"
                    end

                    Core.Config.ToggleUIKey = keyName
                    SaveConfigToFile(Core.Config)

                    keyBox.Text = keyName
                    keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                    boxStroke.Color = Color3.fromRGB(70, 70, 85)
                    keyBox:SetAttribute("Listening", false)

                    WindUI:Notify({
                        Title = T.keybindSection,
                        Content = T.keybindSet .. keyName,
                        Duration = 2,
                    })

                    if inputConn then
                        inputConn:Disconnect()
                        inputConn = nil
                    end
                    if cancelConn then
                        cancelConn:Disconnect()
                        cancelConn = nil
                    end
                end)

                -- Cancel on mouse click outside
                cancelConn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = keyBox.AbsolutePosition
                        local absSize = keyBox.AbsoluteSize
                        if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
                           mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
                            keyBox.Text = Core.Config.ToggleUIKey
                            keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                            boxStroke.Color = Color3.fromRGB(70, 70, 85)
                            keyBox:SetAttribute("Listening", false)

                            WindUI:Notify({
                                Title = T.keybindSection,
                                Content = T.keybindCancelled,
                                Duration = 2,
                            })

                            if inputConn then
                                inputConn:Disconnect()
                                inputConn = nil
                            end
                            if cancelConn then
                                cancelConn:Disconnect()
                                cancelConn = nil
                            end
                        end
                    end
                end)

                -- Auto cancel after 5 seconds
                task.delay(5, function()
                    if keyBox:GetAttribute("Listening") then
                        keyBox.Text = Core.Config.ToggleUIKey
                        keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                        boxStroke.Color = Color3.fromRGB(70, 70, 85)
                        keyBox:SetAttribute("Listening", false)

                        if inputConn then
                            inputConn:Disconnect()
                            inputConn = nil
                        end
                        if cancelConn then
                            cancelConn:Disconnect()
                            cancelConn = nil
                        end
                    end
                end)
            end)
        end)
    end)

    SettingsTab:Section({ Title = T.stats, Desc = T.statsDesc })
    local StatsGui = nil
    local StatsConnection = nil
    local function CreateStatsOverlay()
        local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local existing = playerGui:FindFirstChild("C4THStatsOverlay")
        if existing then
            existing:Destroy()
        end
        StatsGui = Instance.new("ScreenGui")
        StatsGui.Name = "C4THStatsOverlay"
        StatsGui.ResetOnSpawn = false
        StatsGui.Parent = playerGui
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 110, 0, 50)
        frame.Position = UDim2.new(0, 10, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
        frame.BackgroundTransparency = 0.3
        frame.Parent = StatsGui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Size = UDim2.new(1, 0, 0.5, 0)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.Text = "FPS: --"
        fpsLabel.TextColor3 = Color3.new(1, 1, 1)
        fpsLabel.Font = Enum.Font.GothamBold
        fpsLabel.TextSize = 14
        fpsLabel.Parent = frame
        local pingLabel = Instance.new("TextLabel")
        pingLabel.Size = UDim2.new(1, 0, 0.5, 0)
        pingLabel.Position = UDim2.new(0, 0, 0.5, 0)
        pingLabel.BackgroundTransparency = 1
        pingLabel.Text = "Ping: --"
        pingLabel.TextColor3 = Color3.new(1, 1, 1)
        pingLabel.Font = Enum.Font.GothamBold
        pingLabel.TextSize = 14
        pingLabel.Parent = frame
        local RunService = game:GetService("RunService")
        local frameCount = 0
        local lastTime = tick()
        StatsConnection = RunService.Heartbeat:Connect(function()
            frameCount = frameCount + 1
            local now = tick()
            if now - lastTime >= 1 then
                fpsLabel.Text = "FPS: " .. frameCount
                frameCount = 0
                lastTime = now
                pcall(function()
                    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                    pingLabel.Text = "Ping: " .. math.floor(ping) .. " ms"
                end)
            end
        end)
    end
    local function DestroyStatsOverlay()
        if StatsConnection then
            StatsConnection:Disconnect()
            StatsConnection = nil
        end
        if StatsGui then
            StatsGui:Destroy()
            StatsGui = nil
        end
    end
    SettingsTab:Toggle({
        Title = T.showStats,
        Value = false,
        Callback = function(state)
            if state then
                CreateStatsOverlay()
            else
                DestroyStatsOverlay()
            end
        end,
    })
    SettingsTab:Section({ Title = T.configSection, Desc = T.configDesc })
    SettingsTab:Button({
        Title = T.saveConfig,
        Icon = "save",
        Callback = function()
            SaveConfigToFile(Core.Config)
            WindUI:Notify({ Title = T.settings, Content = T.savedMsg, Duration = 2 })
        end,
    })
    SettingsTab:Button({
        Title = T.resetConfig,
        Icon = "rotate-ccw",
        Callback = function()
            local fresh = {}
            for k, v in pairs(DEFAULT_CONFIG) do
                fresh[k] = v
            end
            Core.Config = fresh
            SaveConfigToFile(Core.Config)
            WindUI:SetTheme(Core.Config.Theme)
            WindUI:Notify({ Title = T.settings, Content = T.resetMsg, Duration = 4 })
        end,
    })
    SettingsTab:Button({
        Title = T.togglehub,
        Icon = "eye",
        Callback = function()
            Core._isUIOpen = not Core._isUIOpen
            pcall(function()
                if Core._isUIOpen then
                    Window:Show()
                    WindUI:Notify({ Title = "C4rDev Hub", Content = T.uiShown, Duration = 1.5 })
                else
                    Window:Hide()
                    WindUI:Notify({ Title = "C4rDev Hub", Content = T.uiHidden, Duration = 1.5 })
                end
            end)
        end,
    })
end

return Core
