local LOGO_URL = "rbxthumb://type=Asset&id=81755635423577&w=420&h=420"

local MarketplaceService = game:GetService("MarketplaceService")
local mapName = "Unknown Map"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        mapName = info.Name
    end
end)

local Core = loadstring(game:HttpGet("https://raw.githubusercontent.com/NONGFOUR888/TH-SONGS/refs/heads/main/core.lua"))()

local function RunIntro(onNext)
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local camera = workspace.CurrentCamera

    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "C4THSplash"
    splashGui.ResetOnSpawn = false
    splashGui.DisplayOrder = 100
    splashGui.IgnoreGuiInset = true
    splashGui.Parent = playerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(5, 2, 10)
    bg.BackgroundTransparency = 0.55
    bg.BorderSizePixel = 0
    bg.ZIndex = 1
    bg.Parent = splashGui

    local blur = Instance.new("BlurEffect")
    blur.Name = "C4THSplashBlur"
    blur.Size = 0
    blur.Parent = Lighting

    local function getLogoSize()
        local vp = camera.ViewportSize
        local base = math.min(vp.X, vp.Y)
        if base == 0 then base = 800 end
        local size = base * 0.35
        return UDim2.new(0, size, 0, size)
    end

    local logoHolder = Instance.new("Frame")
    logoHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    logoHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoHolder.Size = UDim2.new(0, 0, 0, 0)
    logoHolder.BackgroundTransparency = 1
    logoHolder.ZIndex = 2
    logoHolder.Parent = splashGui

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.BackgroundTransparency = 1
    logo.Image = LOGO_URL
    logo.ImageTransparency = 1
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ZIndex = 2
    logo.Parent = logoHolder

    local startTime = tick()
    while tick() - startTime < 3 do
        if logo.IsLoaded then
            break
        end
        task.wait(0.1)
    end

    local resizeConn
    resizeConn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if logoHolder and logoHolder.Parent then
            logoHolder.Size = getLogoSize()
        end
    end)

    local targetSize = getLogoSize()
    logo.ImageTransparency = 0

    local growTween = TweenService:Create(logoHolder, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = targetSize,
    })
    local blurTween = TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = 24,
    })

    growTween:Play()
    blurTween:Play()
    growTween.Completed:Wait()

    task.wait(1.2)

    local fadeLogo = TweenService:Create(logo, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        ImageTransparency = 1,
    })
    local fadeHolder = TweenService:Create(logoHolder, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset * 1.2, targetSize.Y.Scale, targetSize.Y.Offset * 1.2),
    })
    local fadeBg = TweenService:Create(bg, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
    })
    local fadeBlur = TweenService:Create(blur, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = 0,
    })

    fadeLogo:Play()
    fadeHolder:Play()
    fadeBg:Play()
    fadeBlur:Play()
    fadeLogo.Completed:Wait()

    if resizeConn then
        resizeConn:Disconnect()
    end
    if blur and blur.Parent then
        blur:Destroy()
    end
    if splashGui and splashGui.Parent then
        splashGui:Destroy()
    end

    if onNext then
        onNext()
    end
end

local function PatchTitleIcon(logoUrl, titleText)
    task.spawn(function()
        task.wait(1.0)
        pcall(function()
            local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    for _, obj in ipairs(gui:GetDescendants()) do
                        if obj:IsA("TextLabel") and obj.Text == titleText then
                            local parent = obj.Parent
                            if parent then
                                for _, sibling in ipairs(parent:GetChildren()) do
                                    if (sibling:IsA("ImageLabel") or sibling:IsA("ImageButton")) and sibling ~= obj then
                                        sibling.Image = logoUrl
                                        sibling.ImageColor3 = Color3.new(1, 1, 1)
                                    end
                                end
                                local grandParent = parent.Parent
                                if grandParent then
                                    for _, gpChild in ipairs(grandParent:GetChildren()) do
                                        if gpChild:IsA("ImageLabel") or gpChild:IsA("ImageButton") then
                                            if gpChild.AbsolutePosition.X < obj.AbsolutePosition.X then
                                                gpChild.Image = logoUrl
                                                gpChild.ImageColor3 = Color3.new(1, 1, 1)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)
end

local SongsLoadSuccess, Songs = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/RVXv2/RVX-hub/main/games/songs.lua"))()
end)

RunIntro(function()
    local Window, WindUI = Core.Init(mapName)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")

    PatchTitleIcon(LOGO_URL, "C4rDev Hub X " .. mapName)

    if SongsLoadSuccess and Songs then
        pcall(function()
            Songs.AddSongsTab(Window, WindUI, true)
        end)
    end

    local TeleportTab = Window:Tab({ Title = "เทเลพอต", Icon = "map-pin" })

    TeleportTab:Section({ Title = "วาปหาผู้เล่น", Desc = "เลือกผู้เล่นที่ต้องการเทเลพอตไปหา" })

    local function GetPlayerNames()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(names, p.Name)
            end
        end
        return names
    end

    local SelectedPlayer = nil
    local PlayerDropdown

    PlayerDropdown = TeleportTab:Dropdown({
        Title = "เลือกผู้เล่น",
        Values = GetPlayerNames(),
        Callback = function(selected)
            SelectedPlayer = selected
        end,
    })

    local function RefreshPlayerDropdown()
        local names = GetPlayerNames()
        pcall(function()
            if PlayerDropdown.Refresh then
                PlayerDropdown:Refresh(names)
            elseif PlayerDropdown.SetValues then
                PlayerDropdown:SetValues(names)
            end
        end)
    end

    Players.PlayerAdded:Connect(function()
        task.wait(0.5)
        RefreshPlayerDropdown()
    end)

    Players.PlayerRemoving:Connect(function(p)
        task.wait(0.2)
        RefreshPlayerDropdown()
        if SelectedPlayer == p.Name then
            SelectedPlayer = nil
        end
    end)

    TeleportTab:Button({
        Title = "รีเฟรชรายชื่อผู้เล่น",
        Icon = "refresh-cw",
        Callback = function()
            RefreshPlayerDropdown()
            WindUI:Notify({ Title = "เทเลพอต", Content = "อัปเดตรายชื่อแล้ว", Duration = 2 })
        end,
    })

    TeleportTab:Button({
        Title = "เทเลพอตไปหา",
        Icon = "navigation",
        Callback = function()
            if not SelectedPlayer then
                WindUI:Notify({ Title = "ผิดพลาด", Content = "กรุณาเลือกผู้เล่นก่อน", Duration = 3 })
                return
            end

            local target = Players:FindFirstChild(SelectedPlayer)
            local myChar = LocalPlayer.Character

            if target and target.Character and myChar then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")

                if targetRoot and myRoot then
                    myRoot.CFrame = targetRoot.CFrame + Vector3.new(3, 0, 0)
                    WindUI:Notify({ Title = "สำเร็จ", Content = "เทเลพอตไปหา " .. SelectedPlayer, Duration = 3 })
                end
            else
                WindUI:Notify({ Title = "ผิดพลาด", Content = "หาผู้เล่นไม่เจอ (อาจออกจากเกมไปแล้ว)", Duration = 3 })
                RefreshPlayerDropdown()
            end
        end,
    })

    local ProtectionTab = Window:Tab({ Title = "การป้องกัน", Icon = "shield" })

    local AntiSitAll = false
    local AntiSitChair = false
    local AntiSitVehicle = false
    local AntiKnockback = false
    local AntiRagdoll = false

    local function GetHumanoid()
        local char = LocalPlayer.Character
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    local function GetRoot()
        local char = LocalPlayer.Character
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function ApplyRagdollStates()
        local hum = GetHumanoid()
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not AntiRagdoll)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, not AntiKnockback)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not AntiKnockback)
    end

    local function ApplySitAllState()
        local hum = GetHumanoid()
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, not AntiSitAll)
    end

    local function HookCharacter(char)
        task.wait(1)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        ApplyRagdollStates()
        ApplySitAllState()

        hum.Seated:Connect(function(active, seatPart)
            if not active or not seatPart then return end
            if AntiSitAll then
                hum.Sit = false
                return
            end

            local isVehicle = seatPart:IsA("VehicleSeat")
            if isVehicle and AntiSitVehicle then
                hum.Sit = false
            elseif (not isVehicle) and AntiSitChair then
                hum.Sit = false
            end
        end)
    end

    LocalPlayer.CharacterAdded:Connect(HookCharacter)
    if LocalPlayer.Character then
        HookCharacter(LocalPlayer.Character)
    end

    local NORMAL_VELOCITY_LIMIT = 90

    RunService.Heartbeat:Connect(function()
        if not AntiKnockback then return end
        local root = GetRoot()
        if not root then return end

        local vel = root.AssemblyLinearVelocity
        local horizontalSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude

        if horizontalSpeed > NORMAL_VELOCITY_LIMIT then
            root.AssemblyLinearVelocity = Vector3.new(0, math.max(vel.Y, 0), 0)
        end
    end)

    ProtectionTab:Section({ Title = "การนั่ง", Desc = "ป้องกันไม่ให้ตัวละครนั่งได้" })

    ProtectionTab:Toggle({
        Title = "กันนั่งทุกอย่าง",
        Desc = "บล็อกทุกจุดพร้อมกัน (เก้าอี้ + รถ + อื่นๆ)",
        Value = false,
        Callback = function(state)
            AntiSitAll = state
            ApplySitAllState()
            WindUI:Notify({ Title = "การป้องกัน", Content = "กันนั่งทุกอย่าง: " .. (state and "เปิด" or "ปิด"), Duration = 2 })
        end,
    })

    ProtectionTab:Toggle({
        Title = "กันนั่งเก้าอี้",
        Desc = "เฉพาะที่นั่งทั่วไป ไม่รวมรถ",
        Value = false,
        Callback = function(state)
            AntiSitChair = state
            WindUI:Notify({ Title = "การป้องกัน", Content = "กันนั่งเก้าอี้: " .. (state and "เปิด" or "ปิด"), Duration = 2 })
        end,
    })

    ProtectionTab:Toggle({
        Title = "กันนั่งรถ",
        Desc = "เฉพาะเบาะรถ ไม่รวมเก้าอี้",
        Value = false,
        Callback = function(state)
            AntiSitVehicle = state
            WindUI:Notify({ Title = "การป้องกัน", Content = "กันนั่งรถ: " .. (state and "เปิด" or "ปิด"), Duration = 2 })
        end,
    })

    ProtectionTab:Section({ Title = "แรงกระแทก", Desc = "ป้องกันการถูกเหวี่ยง/ล้ม (ทั้งสถานะและแรงจริง)" })

    ProtectionTab:Toggle({
        Title = "กันโดนดีด",
        Desc = "ป้องกันการถูกดีดจากของในแมพ (หักล้างแรงกระแทกจริง ไม่ใช่แค่บล็อกสถานะ)",
        Value = false,
        Callback = function(state)
            AntiKnockback = state
            ApplyRagdollStates()
            WindUI:Notify({ Title = "การป้องกัน", Content = "กันโดนดีด: " .. (state and "เปิด" or "ปิด"), Duration = 2 })
        end,
    })

    ProtectionTab:Toggle({
        Title = "กันล้ม",
        Desc = "ป้องกัน Ragdoll",
        Value = false,
        Callback = function(state)
            AntiRagdoll = state
            ApplyRagdollStates()
            WindUI:Notify({ Title = "การป้องกัน", Content = "กันล้ม: " .. (state and "เปิด" or "ปิด"), Duration = 2 })
        end,
    })

    local MovementTab = Window:Tab({ Title = "การเคลื่อนไหว", Icon = "move" })

    MovementTab:Section({ Title = "บิน", Desc = "เปิดโหมดบินอิสระ รองรับมือถือ ความสูงคุมด้วยมุมกล้องเสมอ" })

    local FlyEnabled = false
    local FlySpeed = 50
    local FlyConnection = nil
    local FlyBodyVelocity = nil
    local FlyBodyGyro = nil

    local function StartFly()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        hum.PlatformStand = false

        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyBodyVelocity.Parent = root

        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyGyro.P = 3000
        FlyBodyGyro.CFrame = root.CFrame
        FlyBodyGyro.Parent = root

        FlyConnection = RunService.RenderStepped:Connect(function()
            local camera = workspace.CurrentCamera
            local currentChar = LocalPlayer.Character
            local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
            if not camera or not currentHum or not FlyBodyVelocity or not FlyBodyGyro then return end

            local moveDir = currentHum.MoveDirection
            local inputMagnitude = moveDir.Magnitude
            local camCFrame = camera.CFrame

            local horizontal = Vector3.new(0, 0, 0)
            if inputMagnitude > 0.02 then
                horizontal = moveDir.Unit * FlySpeed * inputMagnitude
            end

            local vertical = camCFrame.LookVector.Y * FlySpeed

            FlyBodyVelocity.Velocity = horizontal + Vector3.new(0, vertical, 0)
            FlyBodyGyro.CFrame = camCFrame
        end)
    end

    local function StopFly()
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        if FlyBodyVelocity then
            FlyBodyVelocity:Destroy()
            FlyBodyVelocity = nil
        end
        if FlyBodyGyro then
            FlyBodyGyro:Destroy()
            FlyBodyGyro = nil
        end
    end

    MovementTab:Toggle({
        Title = "เปิดโหมดบิน",
        Desc = "โยกจอยไปทางไหนก็บินไปทางนั้น เงย/ก้มกล้องเพื่อขึ้น-ลง แม้ถอยหลังก็ปรับความสูงได้",
        Value = false,
        Callback = function(state)
            FlyEnabled = state
            if FlyEnabled then
                StartFly()
                WindUI:Notify({ Title = "การเคลื่อนไหว", Content = "เปิดโหมดบินแล้ว", Duration = 2 })
            else
                StopFly()
                WindUI:Notify({ Title = "การเคลื่อนไหว", Content = "ปิดโหมดบินแล้ว", Duration = 2 })
            end
        end,
    })

    MovementTab:Slider({
        Title = "ความเร็วบิน",
        Desc = "ปรับความเร็วขณะบิน",
        Value = { Min = 10, Max = 200, Default = 50 },
        Callback = function(value)
            FlySpeed = value
        end,
    })

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if FlyEnabled then
            StartFly()
        end
    end)

    MovementTab:Section({ Title = "หมุนตัวละคร", Desc = "หมุนตัวเองอัตโนมัติต่อเนื่อง คนอื่นเห็นหมุนจริงลื่นๆ" })

    local SpinEnabled = false
    local SpinSpeed = 180
    local SpinBAV = nil

    local function StartSpin()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        if SpinBAV then
            SpinBAV:Destroy()
        end

        SpinBAV = Instance.new("BodyAngularVelocity")
        SpinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
        SpinBAV.P = 10000
        SpinBAV.AngularVelocity = Vector3.new(0, math.rad(SpinSpeed), 0)
        SpinBAV.Parent = root
    end

    local function StopSpin()
        if SpinBAV then
            SpinBAV:Destroy()
            SpinBAV = nil
        end
    end

    MovementTab:Toggle({
        Title = "เปิดหมุนตัวละคร",
        Desc = "ตัวละครจะหมุนรอบตัวเองต่อเนื่องอัตโนมัติ ใช้แรงหมุนจริงทำให้คนอื่นเห็นตรงกัน",
        Value = false,
        Callback = function(state)
            SpinEnabled = state
            if SpinEnabled then
                StartSpin()
                WindUI:Notify({ Title = "การเคลื่อนไหว", Content = "เปิดหมุนตัวละครแล้ว", Duration = 2 })
            else
                StopSpin()
                WindUI:Notify({ Title = "การเคลื่อนไหว", Content = "ปิดหมุนตัวละครแล้ว", Duration = 2 })
            end
        end,
    })

    MovementTab:Slider({
        Title = "ความเร็วหมุน",
        Desc = "หน่วยองศาต่อวินาที (ปรับได้เร็วขึ้นมาก)",
        Value = { Min = 30, Max = 2160, Default = 180 },
        Callback = function(value)
            SpinSpeed = value
            if SpinBAV then
                SpinBAV.AngularVelocity = Vector3.new(0, math.rad(SpinSpeed), 0)
            end
        end,
    })

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if SpinEnabled then
            StartSpin()
        end
    end)

    MovementTab:Section({ Title = "ล็อคตำแหน่ง", Desc = "ค้างตัวละครอยู่กับที่ แต่ยังเปลี่ยนท่าทาง/เล่นแอนิเมชันได้" })

    local PositionLocked = false

    local function ApplyPositionLock(state)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.Anchored = state
    end

    MovementTab:Toggle({
        Title = "ล็อคตำแหน่ง",
        Desc = "ตรึงตำแหน่งปัจจุบันไว้ ขยับที่ไม่ได้แต่ยังโพสท่า/เล่นแอนิเมชันได้",
        Value = false,
        Callback = function(state)
            PositionLocked = state
            ApplyPositionLock(state)
            WindUI:Notify({ Title = "การเคลื่อนไหว", Content = "ล็อคตำแหน่ง: " .. (state and "เปิด" or "ปิด"), Duration = 2 })
        end,
    })

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        PositionLocked = false
    end)

    MovementTab:Section({ Title = "ความเร็ววิ่ง", Desc = "ปรับ WalkSpeed และล็อคค่าไว้ตลอด แม้ถูกรีเซ็ตหรือตายก็คงเดิม" })

    local WalkSpeedValue = 16
    local WalkSpeedLocked = false

    local function ApplyWalkSpeed()
        local hum = GetHumanoid()
        if hum then
            hum.WalkSpeed = WalkSpeedValue
        end
    end

    MovementTab:Slider({
        Title = "ความเร็ววิ่ง",
        Desc = "ค่าเริ่มต้นของเกมคือ 16 (ล็อคไว้ตลอดอัตโนมัติเมื่อปรับ)",
        Value = { Min = 16, Max = 200, Default = 16 },
        Callback = function(value)
            WalkSpeedValue = value
            WalkSpeedLocked = true
            ApplyWalkSpeed()
        end,
    })

    MovementTab:Section({ Title = "ความสูงกระโดด", Desc = "ปรับ JumpPower และล็อคค่าไว้ตลอด แม้ถูกรีเซ็ตหรือตายก็คงเดิม" })

    local JumpPowerValue = 50
    local JumpPowerLocked = false

    local function ApplyJumpPower()
        local hum = GetHumanoid()
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = JumpPowerValue
        end
    end

    MovementTab:Slider({
        Title = "ความสูงกระโดด",
        Desc = "ค่าเริ่มต้นของเกมคือ 50 (ล็อคไว้ตลอดอัตโนมัติเมื่อปรับ)",
        Value = { Min = 50, Max = 300, Default = 50 },
        Callback = function(value)
            JumpPowerValue = value
            JumpPowerLocked = true
            ApplyJumpPower()
        end,
    })

    RunService.Heartbeat:Connect(function()
        local hum = GetHumanoid()
        if not hum then return end

        if WalkSpeedLocked and math.abs(hum.WalkSpeed - WalkSpeedValue) > 0.01 then
            hum.WalkSpeed = WalkSpeedValue
        end

        if JumpPowerLocked and math.abs(hum.JumpPower - JumpPowerValue) > 0.01 then
            hum.UseJumpPower = true
            hum.JumpPower = JumpPowerValue
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if WalkSpeedLocked then ApplyWalkSpeed() end
        if JumpPowerLocked then ApplyJumpPower() end
    end)

    if LocalPlayer.Character then
        if WalkSpeedLocked then ApplyWalkSpeed() end
        if JumpPowerLocked then ApplyJumpPower() end
    end

    if SongsLoadSuccess and Songs and Songs.AddSniffTab then
        pcall(function()
            Songs.AddSniffTab(Window, WindUI)
        end)
    end

    local PerformanceTab = Window:Tab({ Title = "ประสิทธิภาพ", Icon = "gauge" })

    PerformanceTab:Section({ Title = "ลดแลค", Desc = "ลบสิ่งของที่ไม่จำเป็นเพื่อเพิ่ม FPS" })

    local RemovedItems = {}

    PerformanceTab:Button({
        Title = "ลบต้นไม้/พุ่มไม้",
        Icon = "trash-2",
        Callback = function()
            local count = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = string.lower(obj.Name)
                    if string.find(n, "tree") or string.find(n, "bush") or string.find(n, "plant") then
                        obj.Transparency = 1
                        obj.CanCollide = false
                        table.insert(RemovedItems, obj)
                        count = count + 1
                    end
                end
            end
            WindUI:Notify({ Title = "Anti Lag", Content = "ซ่อนแล้ว " .. count .. " ชิ้น", Duration = 3 })
        end,
    })

    PerformanceTab:Button({
        Title = "ปิดเงา (Shadows)",
        Icon = "sun",
        Callback = function()
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
            game:GetService("Lighting").GlobalShadows = false
            WindUI:Notify({ Title = "Anti Lag", Content = "ปิดเงาและลดคุณภาพกราฟิกแล้ว", Duration = 3 })
        end,
    })

    PerformanceTab:Button({
        Title = "ลดระยะมองเห็น (Fog/Distance)",
        Icon = "eye-off",
        Callback = function()
            local Lighting = game:GetService("Lighting")
            Lighting.FogEnd = 300
            if workspace.StreamingTargetRadius then
                workspace.StreamingTargetRadius = 300
            end
            WindUI:Notify({ Title = "Anti Lag", Content = "ลดระยะ Render แล้ว", Duration = 3 })
        end,
    })

    PerformanceTab:Button({
        Title = "คืนค่าทั้งหมด",
        Icon = "rotate-ccw",
        Callback = function()
            for _, obj in ipairs(RemovedItems) do
                if obj and obj.Parent then
                    obj.Transparency = 0
                    obj.CanCollide = true
                end
            end
            table.clear(RemovedItems)
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end)
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").FogEnd = 100000
            WindUI:Notify({ Title = "Anti Lag", Content = "คืนค่าทุกอย่างแล้ว", Duration = 3 })
        end,
    })

    Core.Settings(Window, WindUI)

    WindUI:Notify({
        Title = "C4rDev Hub X",
        Content = "โหลดสำเร็จ! แมพ: " .. mapName,
        Duration = 4
    })
end)
