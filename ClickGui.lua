local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Notification System
local notifications = {}
local function showNotification(message)
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "FunctionNotification"
    NotificationGui.Parent = game.CoreGui

    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(0, 200, 0, 50)
    NotificationFrame.Position = UDim2.new(1, 10, 1, -60 - (#notifications * 60))
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Parent = NotificationGui

    local NotificationCorner = Instance.new("UICorner")
    NotificationCorner.CornerRadius = UDim.new(0, 6)
    NotificationCorner.Parent = NotificationFrame

    local NotificationLabel = Instance.new("TextLabel")
    NotificationLabel.Size = UDim2.new(1, -10, 1, -10)
    NotificationLabel.Position = UDim2.new(0, 5, 0, 5)
    NotificationLabel.BackgroundTransparency = 1
    NotificationLabel.Text = message
    NotificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotificationLabel.Font = Enum.Font.SourceSans
    NotificationLabel.TextSize = 14
    NotificationLabel.TextWrapped = true
    NotificationLabel.Parent = NotificationFrame

    table.insert(notifications, NotificationFrame)

    local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -210, 1, -60 - (#notifications * 60))})
    tweenIn:Play()
    tweenIn.Completed:Wait()

    wait(2)

    local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 1, -60 - (#notifications * 60))})
    tweenOut:Play()
    tweenOut.Completed:Wait()

    table.remove(notifications, 1)
    for i, notif in ipairs(notifications) do
        notif.Position = UDim2.new(1, -210, 1, -60 - (i * 60))
    end
    NotificationGui:Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Create Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Create Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "CrazyHueta"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Make GUI Draggable
local dragging = false
local dragStartPos, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = input.Position
        startPos = MainFrame.Position
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartPos
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Create Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 0, 270)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 10)
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 5)
SidebarPadding.PaddingRight = UDim.new(0, 5)
SidebarPadding.Parent = Sidebar

-- Create Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(0, 380, 0, 270)
Content.Position = UDim2.new(0, 120, 0, 30)
Content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Content.BorderSizePixel = 0
Content.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = Content

-- Tab Management
local Tabs = {}
local TabButtons = {}
local CurrentTab = nil

local function createTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 18
    TabButton.BorderSizePixel = 0
    TabButton.Parent = Sidebar
    TabButton.LayoutOrder = #Tabs + 1

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = TabButton

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -10, 1, -10)
    TabContent.Position = UDim2.new(0, 5, 0, 5)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 4
    TabContent.Visible = false
    TabContent.Parent = Content

    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 10)
    ContentList.Parent = TabContent

    ContentList.Changed:Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
    end)

    Tabs[name] = TabContent
    TabButtons[name] = TabButton

    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab ~= name then
            if CurrentTab then
                Tabs[CurrentTab].Visible = false
                TabButtons[CurrentTab].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
            CurrentTab = name
            Tabs[name].Visible = true
            TabButtons[name].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
    end)
end

for _, name in ipairs({"Combat", "Movement", "Visuals", "Exploits", "Utils"}) do
    createTab(name)
end

-- Function Module
local function createFunctionModule(tabName, funcName, defaultBind, callback, options)
    options = options or {}
    local hasSlider = options.hasSlider or false

    local height = 70
    if hasSlider then height = height + 40 end

    local FuncFrame = Instance.new("Frame")
    FuncFrame.Size = UDim2.new(1, -10, 0, height)
    FuncFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    FuncFrame.BorderSizePixel = 0
    FuncFrame.Parent = Tabs[tabName]

    local FuncCorner = Instance.new("UICorner")
    FuncCorner.CornerRadius = UDim.new(0, 6)
    FuncCorner.Parent = FuncFrame

    local FuncLabel = Instance.new("TextLabel")
    FuncLabel.Size = UDim2.new(1, -10, 0, 30)
    FuncLabel.Position = UDim2.new(0, 5, 0, 5)
    FuncLabel.BackgroundTransparency = 1
    FuncLabel.Text = funcName
    FuncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FuncLabel.Font = Enum.Font.SourceSansBold
    FuncLabel.TextSize = 16
    FuncLabel.TextXAlignment = Enum.TextXAlignment.Left
    FuncLabel.Parent = FuncFrame

    local isEnabled = false
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 60, 0, 25)
    ToggleButton.Position = UDim2.new(1, -65, 0, 35)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.TextSize = 14
    ToggleButton.Parent = FuncFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 4)
    ToggleCorner.Parent = ToggleButton

    local currentBind = defaultBind
    local BindButton = Instance.new("TextButton")
    BindButton.Size = UDim2.new(0, 60, 0, 25)
    BindButton.Position = UDim2.new(0, 5, 0, 35)
    BindButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    BindButton.Text = currentBind.Name
    BindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindButton.Font = Enum.Font.SourceSans
    BindButton.TextSize = 14
    BindButton.Parent = FuncFrame

    local BindCorner = Instance.new("UICorner")
    BindCorner.CornerRadius = UDim.new(0, 4)
    BindCorner.Parent = BindButton

    local waitingForBind = false
    BindButton.MouseButton1Click:Connect(function()
        waitingForBind = true
        BindButton.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if waitingForBind and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
            currentBind = input.KeyCode
            BindButton.Text = currentBind.Name
            waitingForBind = false
        end
    end)

    local SliderValue = 0
    if hasSlider then
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -90, 0, 20)
        SliderFrame.Position = UDim2.new(0, 15, 0, 65)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SliderFrame.Parent = FuncFrame

        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 4)
        SliderCorner.Parent = SliderFrame

        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(0, 0, 0, 10)
        SliderBar.Position = UDim2.new(0, 0, 0.5, -5)
        SliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        SliderBar.Parent = SliderFrame

        local SliderBarCorner = Instance.new("UICorner")
        SliderBarCorner.CornerRadius = UDim.new(0, 4)
        SliderBarCorner.Parent = SliderBar

        local SliderDragging = false
        local SliderButton = Instance.new("TextButton")
        SliderButton.Size = UDim2.new(0, 10, 0, 10)
        SliderButton.Position = UDim2.new(0, 0, 0.5, -5)
        SliderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        SliderButton.BorderSizePixel = 0
        SliderButton.Text = ""
        SliderButton.Parent = SliderFrame

        local SliderButtonCorner = Instance.new("UICorner")
        SliderButtonCorner.CornerRadius = UDim.new(0, 4)
        SliderButtonCorner.Parent = SliderButton

        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(0, 50, 0, 20)
        SliderLabel.Position = UDim2.new(1, 20, 0, 65)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = "0.0"
        SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderLabel.Font = Enum.Font.SourceSans
        SliderLabel.TextSize = 14
        SliderLabel.Parent = FuncFrame

        SliderButton.MouseButton1Down:Connect(function()
            SliderDragging = true
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                SliderDragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if SliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouseX = input.Position.X
                local frameX = SliderFrame.AbsolutePosition.X
                local frameWidth = SliderFrame.AbsoluteSize.X
                local relativeX = math.clamp((mouseX - frameX) / frameWidth, 0, 1)
                SliderValue = math.floor(relativeX * 100)
                SliderBar.Size = UDim2.new(relativeX, 0, 0, 10)
                SliderButton.Position = UDim2.new(relativeX, -5, 0.5, -5)
                SliderLabel.Text = string.format("%.1f", SliderValue) .. ".0"
            end
        end)
    end

    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        ToggleButton.Text = isEnabled and "ON" or "OFF"
        ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
        showNotification(funcName .. " was " .. (isEnabled and "Enabled" or "Disabled"))
        if callback then
            callback(isEnabled, SliderValue)
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentBind then
            isEnabled = not isEnabled
            ToggleButton.Text = isEnabled and "ON" or "OFF"
            ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
            showNotification(funcName .. " was " .. (isEnabled and "Enabled" or "Disabled"))
            if callback then
                callback(isEnabled, SliderValue)
            end
        end
    end)
end

-- Aimbot Implementation
local aimbotConnection
local fovCircle
createFunctionModule("Combat", "Aimbot", Enum.KeyCode.Q, function(isEnabled)
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    if fovCircle then
        fovCircle:Remove()
        fovCircle = nil
    end

    if isEnabled then
        local FOV = 30
        local maxDistance = math.huge
        local target = nil

        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = true
        fovCircle.Radius = (math.tan(math.rad(FOV)) * Camera.FieldOfView * Camera.ViewportSize.X) / (2 * math.tan(math.rad(Camera.FieldOfView) / 2))
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Thickness = 2
        fovCircle.Color = Color3.fromRGB(255, 255, 255)

        aimbotConnection = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation()
            local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
            if not localPos then
                fovCircle.Color = Color3.fromRGB(255, 255, 255)
                target = nil
                return
            end

            if target and target.Character and target.Character:FindFirstChild("Head") and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                local headPos = target.Character.Head.Position
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                if onScreen then
                    local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    local fovCheck = distance * (180 / math.pi) / Camera.FieldOfView
                    if fovCheck <= FOV then
                        local delta = Vector2.new(screenPos.X, screenPos.Y) - mousePos
                        mousemoverel(delta.X / 5, delta.Y / 5)
                        fovCircle.Color = Color3.fromRGB(255, 0, 0)
                        return
                    else
                        target = nil
                    end
                else
                    target = nil
                end
            else
                target = nil
            end

            local closestDistance = maxDistance
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local headPos = player.Character.Head.Position
                    local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                    if onScreen then
                        local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        local worldDistance = (localPos - headPos).Magnitude
                        local fovCheck = distance * (180 / math.pi) / Camera.FieldOfView
                        if fovCheck <= FOV and worldDistance < closestDistance then
                            closestDistance = worldDistance
                            target = player
                        end
                    end
                end
            end

            if target then
                local headPos = target.Character.Head.Position
                local screenPos = Camera:WorldToViewportPoint(headPos)
                local delta = Vector2.new(screenPos.X, screenPos.Y) - mousePos
                mousemoverel(delta.X / 5, delta.Y / 5)
                fovCircle.Color = Color3.fromRGB(255, 0, 0)
            else
                fovCircle.Color = Color3.fromRGB(255, 255, 255)
            end
        end)
    end
end, {hasSlider = false})

-- Speed Hack
local speedConnections = {}
createFunctionModule("Movement", "Speed Hack", Enum.KeyCode.E, function(isEnabled, value)
    local baseSpeed = 16
    local speed = baseSpeed + value
    local teleportDistance = 5
    local teleportInterval = 0.1

    for _, conn in pairs(speedConnections) do
        if conn then conn:Disconnect() end
    end
    speedConnections = {}

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = isEnabled and speed or baseSpeed
    end

    if isEnabled then
        local function teleportInDirection(direction)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = LocalPlayer.Character.HumanoidRootPart
                rootPart.CFrame = rootPart.CFrame + (direction * teleportDistance)
            end
        end

        local keysDown = {}
        local function onInputBegan(input, gameProcessed)
            if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.W then
                    keysDown.W = true
                elseif input.KeyCode == Enum.KeyCode.A then
                    keysDown.A = true
                elseif input.KeyCode == Enum.KeyCode.S then
                    keysDown.S = true
                elseif input.KeyCode == Enum.KeyCode.D then
                    keysDown.D = true
                end
            end
        end

        local function onInputEnded(input, gameProcessed)
            if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.W then
                    keysDown.W = false
                elseif input.KeyCode == Enum.KeyCode.A then
                    keysDown.A = false
                elseif input.KeyCode == Enum.KeyCode.S then
                    keysDown.S = false
                elseif input.KeyCode == Enum.KeyCode.D then
                    keysDown.D = false
                end
            end
        end

        table.insert(speedConnections,ijections, UserInputService.InputBegan:Connect(onInputBegan))
        table.insert(speedConnections, UserInputService.InputEnded:Connect(onInputEnded))

        local lastTeleport = tick()
        table.insert(speedConnections, RunService.RenderStepped:Connect(function()
            if tick() - lastTeleport >= teleportInterval then
                local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end

                local direction = Vector3.new()
                if keysDown.W then direction = direction + rootPart.CFrame.LookVector end
                if keysDown.S then direction = direction - rootPart.CFrame.LookVector end
                if keysDown.A then direction = direction - rootPart.CFrame.RightVector end
                if keysDown.D then direction = direction + rootPart.CFrame.RightVector end

                if direction.Magnitude > 0 then
                    teleportInDirection(direction.Unit)
                    lastTeleport = tick()
                end
            end
        end))
    end
end, {hasSlider = true})

-- Fly Implementation
local flyConnection
createFunctionModule("Movement", "Fly", Enum.KeyCode.F, function(isEnabled, speed)
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if isEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character.Humanoid
        humanoid.PlatformStand = true

        local bodyVelocity
        if not rootPart:FindFirstChild("FlyVelocity") then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "FlyVelocity"
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = rootPart
        else
            bodyVelocity = rootPart:FindFirstChild("FlyVelocity")
        end

        flyConnection = RunService.RenderStepped:Connect(function(deltaTime)
            local moveDirection = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = Camera.CFrame.LookVector
            end

            bodyVelocity.Velocity = moveDirection * (speed + 20)
        end)

        table.insert(speedConnections, UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W and bodyVelocity then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end))
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and rootPart:FindFirstChild("FlyVelocity") then
                rootPart.FlyVelocity:Destroy()
            end
        end
    end
end, {hasSlider = true})

-- Noclip
createFunctionModule("Exploits", "Noclip", Enum.KeyCode.T, function(isEnabled)
    local noclipConnection
    if isEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end, {hasSlider = false})

-- Unhook
createFunctionModule("Utils", "Unhook", Enum.KeyCode.F, function(isEnabled)
    if isEnabled then
        ScreenGui:Destroy()
        if aimbotConnection then
            aimbotConnection:Disconnect()
        end
        if fovCircle then
            fovCircle:Remove()
        end
        if flyConnection then
            flyConnection:Disconnect()
        end
        for _, conn in pairs(speedConnections) do
            if conn then conn:Disconnect() end
        end
        print("Unhooked Xeno GUI")
    end
end, {hasSlider = false})

-- Toggle GUI
local guiVisible = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        MainFrame.Visible = guiVisible
        if guiVisible and not CurrentTab then
            CurrentTab = "Combat"
            Tabs["Combat"].Visible = true
            TabButtons["Combat"].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
    end
end)

showNotification("CrazyHueta ClickGUI Injected!")
print("Xeno ClickGUI Loaded. Press RCTRL to toggle.")
