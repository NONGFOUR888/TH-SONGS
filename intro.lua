local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Intro = {}

local LOGO_ID = "rbxthumb://type=Asset&id=81755635423577&w=420&h=420"

local function ShowSplash()
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
        local size = base * 0.6
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
    logo.Image = LOGO_ID
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
end

function Intro.Show(onNext)
    ShowSplash()
    if onNext then
        onNext()
    end
end

return Intro
