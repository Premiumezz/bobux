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
ScreenGui.Name = "XenoESP"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Create Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 200)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
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
TitleLabel.Text = "CrazyHueta ESP"
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

-- Create Content Area
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -10, 1, -40)
Content.Position = UDim2.new(0, 5, 0, 35)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 4
Content.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, 10)
ContentList.Parent = Content

ContentList.Changed:Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
end)

-- Function Module
local function createFunctionModule(funcName, defaultBind, callback, options)
    options = options or {}
    local hasEspToggles = options.hasEspToggles or false
    local hasColorPicker = options.hasColorPicker or false

    local height = 70
    if hasEspToggles then height = height + 30 end
    if hasColorPicker then height = height + 40 end

    local FuncFrame = Instance.new("Frame")
    FuncFrame.Size = UDim2.new(1, -10, 0, height)
    FuncFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    FuncFrame.BorderSizePixel = 0
    FuncFrame.Parent = Content

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

    local espSettings = {showName = false, showHealth = false, showDistance = false, showItem = false}
    if hasEspToggles then
        local function createToggle(label, position, settingKey)
            local EspToggle = Instance.new("TextButton")
            EspToggle.Size = UDim2.new(0, 80, 0, 20)
            EspToggle.Position = position
            EspToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            EspToggle.Text = label .. ": OFF"
            EspToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            EspToggle.Font = Enum.Font.SourceSans
            Trigger.new("TextButton")
            EspToggle.TextSize = 12
            EspToggle.Parent = FuncFrame

            local EspToggleCorner = Instance.new("UICorner")
            EspToggleCorner.CornerRadius = UDim.new(0, 4)
            EspToggleCorner.Parent = EspToggle

            EspToggle.MouseButton1Click:Connect(function()
                espSettings[settingKey] = not espSettings[settingKey]
                EspToggle.Text = label .. (espSettings[settingKey] and ": ON" or ": OFF")
                EspToggle.BackgroundColor3 = espSettings[settingKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
            end)
        end

        createToggle("Name", UDim2.new(0, 5, 0, 65), "showName")
        createToggle("Health", UDim2.new(0, 90, 0, 65), "showHealth")
        createToggle("Distance", UDim2.new(0, 175, 0, 65), "showDistance")
        createToggle("Item", UDim2.new(0, 260, 0, 65), "showItem")
    end

    local colorSettings = {r = 0, g = 255, b = 50}
    if hasColorPicker then
        local function createColorSlider(label, position, colorKey, defaultValue)
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(0, 80, 0, 20)
            ColorFrame.Position = position
            ColorFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ColorFrame.Parent = FuncFrame

            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 4)
            ColorCorner.Parent = ColorFrame

            local ColorBar = Instance.new("Frame")
            ColorBar.Size = UDim2.new(0, 0, 0, 10)
            ColorBar.Position = UDim2.new(0, 0, 0.5, -5)
            ColorBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            ColorBar.Parent = ColorFrame

            local ColorBarCorner = Instance.new("UICorner")
            ColorBarCorner.CornerRadius = UDim.new(0, 4)
            ColorBarCorner.Parent = ColorBar

            local ColorDragging = false
            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(0, 10, 0, 10)
            ColorButton.Position = UDim2.new(defaultValue / 255, -5, 0.5, -5)
            ColorButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            ColorButton.BorderSizePixel = 0
            ColorButton.Text = ""
            ColorButton.Parent = ColorFrame

            local ColorButtonCorner = Instance.new("UICorner")
            ColorButtonCorner.CornerRadius = UDim.new(0, 4)
            ColorButtonCorner.Parent = ColorButton

            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(0, 20, 0, 20)
            ColorLabel.Position = UDim2.new(1, 5, 0, 0)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = tostring(defaultValue)
            ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ColorLabel.Font = Enum.Font.SourceSans
            ColorLabel.TextSize = 14
            ColorLabel.Parent = ColorFrame

            ColorButton.MouseButton1Down:Connect(function()
                ColorDragging = true
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    ColorDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if ColorDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouseX = input.Position.X
                    local frameX = ColorFrame.AbsolutePosition.X
                    local frameWidth = ColorFrame.AbsoluteSize.X
                    local relativeX = math.clamp((mouseX - frameX) / frameWidth, 0, 1)
                    colorSettings[colorKey] = math.floor(relativeX * 255)
                    ColorBar.Size = UDim2.new(relativeX, 0, 0, 10)
                    ColorButton.Position = UDim2.new(relativeX, -5, 0.5, -5)
                    ColorLabel.Text = tostring(colorSettings[colorKey])
                end
            end)

            ColorBar.Size = UDim2.new(defaultValue / 255, 0, 0, 10)
            ColorLabel.Text = tostring(defaultValue)
        end

        local colorPickerY = (hasEspToggles and 95 or 65)
        createColorSlider("R", UDim2.new(0, 5, 0, colorPickerY), "r", 0)
        createColorSlider("G", UDim2.new(0, 95, 0, colorPickerY), "g", 255)
        createColorSlider("B", UDim2.new(0, 185, 0, colorPickerY), "b", 50)
    end

    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        ToggleButton.Text = isEnabled and "ON" or "OFF"
        ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
        showNotification(funcName .. " was " .. (isEnabled and "Enabled" or "Disabled"))
        if callback then
            if hasEspToggles then
                callback(isEnabled, espSettings, Color3.fromRGB(colorSettings.r, colorSettings.g, colorSettings.b))
            elseif hasColorPicker then
                callback(isEnabled, Color3.fromRGB(colorSettings.r, colorSettings.g, colorSettings.b))
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentBind then
            isEnabled = not isEnabled
            ToggleButton.Text = isEnabled and "ON" or "OFF"
            ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
            showNotification(funcName .. " was " .. (isEnabled and "Enabled" or "Disabled"))
            if callback then
                if hasEspToggles then
                    callback(isEnabled, espSettings, Color3.fromRGB(colorSettings.r, colorSettings.g, colorSettings.b))
                elseif hasColorPicker then
                    callback(isEnabled, Color3.fromRGB(colorSettings.r, colorSettings.g, colorSettings.b))
                end
            end
        end
    end)

    return espSettings, colorSettings
end

-- ESP Implementation
local espConnections = {}
local espSettings = {}
createFunctionModule("ESP", Enum.KeyCode.R, function(isEnabled, settings, color)
    for _, data in pairs(espConnections) do
        for _, obj in pairs(data) do
            if obj then obj:Remove() end
        end
    end
    espConnections = {}

    if isEnabled then
        local function createESP(player)
            if player == LocalPlayer then return end

            local lines = {
                left = Drawing.new("Line"),
                right = Drawing.new("Line"),
                top = Drawing.new("Line"),
                bottom = Drawing.new("Line"),
                nameText = Drawing.new("Text"),
                healthText = Drawing.new("Text"),
                distanceText = Drawing.new("Text"),
                itemText = Drawing.new("Text")
            }

            for _, line in pairs({lines.left, lines.right, lines.top, lines.bottom}) do
                line.Visible = false
                line.Color = color
                line.Thickness = 1.4
                line.Transparency = 1
            end

            for _, text in pairs({lines.nameText, lines.healthText, lines.distanceText, lines.itemText}) do
                text.Visible = false
                text.Size = 16
                text.Color = Color3.fromRGB(255, 255, 255)
                text.Outline = true
            end

            espConnections[player.Name] = lines

            local connection
            connection = RunService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
                    local rootPart = player.Character.HumanoidRootPart
                    local humanoid = player.Character.Humanoid
                    local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                    if onScreen then
                        local headPos = Camera:WorldToViewportPoint(player.Character:FindFirstChild("Head").Position)
                        local feetPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                        local height = math.abs(headPos.Y - feetPos.Y)
                        local width = height / 2

                        local topLeft = Vector2.new(headPos.X - width / 2, headPos.Y)
                        local topRight = Vector2.new(headPos.X + width / 2, headPos.Y)
                        local bottomLeft = Vector2.new(headPos.X - width / 2, feetPos.Y)
                        local bottomRight = Vector2.new(headPos.X + width / 2, feetPos.Y)

                        lines.left.From = topLeft
                        lines.left.To = bottomLeft
                        lines.right.From = topRight
                        lines.right.To = bottomRight
                        lines.top.From = topLeft
                        lines.top.To = topRight
                        lines.bottom.From = bottomLeft
                        lines.bottom.To = bottomRight

                        local textOffset = 0
                        if settings.showName then
                            lines.nameText.Text = player.Name
                            lines.nameText.Position = Vector2.new(headPos.X - width / 2, headPos.Y - 20 - textOffset)
                            lines.nameText.Visible = true
                            textOffset = textOffset + 20
                        else
                            lines.nameText.Visible = false
                        end

                        if settings.showHealth then
                            lines.healthText.Text = "Health: " .. math.floor(humanoid.Health)
                            lines.healthText.Position = Vector2.new(headPos.X - width / 2, headPos.Y - 20 - textOffset)
                            lines.healthText.Visible = true
                            textOffset = textOffset + 20
                        else
                            lines.healthText.Visible = false
                        end

                        if settings.showDistance then
                            local distance = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude or 0
                            lines.distanceText.Text = "Distance: " .. math.floor(distance)
                            lines.distanceText.Position = Vector2.new(headPos.X - width / 2, headPos.Y - 20 - textOffset)
                            lines.distanceText.Visible = true
                            textOffset = textOffset + 20
                        else
                            lines.distanceText.Visible = false
                        end

                        if settings.showItem then
                            local tool = player.Character:FindFirstChildOfClass("Tool") and player.Character:FindFirstChildOfClass("Tool").Name or "None"
                            lines.itemText.Text = "Holding: " .. tool
                            lines.itemText.Position = Vector2.new(headPos.X - width / 2, headPos.Y - 20 - textOffset)
                            lines.itemText.Visible = true
                        else
                            lines.itemText.Visible = false
                        end

                        for _, line in pairs({lines.left, lines.right, lines.top, lines.bottom}) do
                            line.Visible = true
                            line.Color = color
                        end
                    else
                        for _, obj in pairs(lines) do
                            obj.Visible = false
                        end
                    end
                else
                    for _, obj in pairs(lines) do
                        obj.Visible = false
                    end
                    if not Players:FindFirstChild(player.Name) then
                        connection:Disconnect()
                    end
                end
            end)
        end

        for _, player in pairs(Players:GetPlayers()) do
            createESP(player)
        end

        Players.PlayerAdded:Connect(createESP)
    end
end, {hasEspToggles = true, hasColorPicker = true})

-- Tracer Implementation
local tracerConnections = {}
createFunctionModule("Tracer", Enum.KeyCode.T, function(isEnabled, color)
    for _, data in pairs(tracerConnections) do
        for _, obj in pairs(data) do
            if obj then obj:Remove() end
        end
    end
    tracerConnections = {}

    if isEnabled then
        local function createTracer(player)
            if player == LocalPlayer then return end

            local tracer = Drawing.new("Line")
            tracer.Visible = false
            tracer.Color = color
            tracer.Thickness = 1.4
            tracer.Transparency = 1

            tracerConnections[player.Name] = {tracer = tracer}

            local connection
            connection = RunService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
                    local rootPart = player.Character.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                    if onScreen then
                        tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        tracer.To = Vector2.new(pos.X, pos.Y)
                        tracer.Color = color
                        tracer.Visible = true
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                    if not Players:FindFirstChild(player.Name) then
                        connection:Disconnect()
                    end
                end
            end)
        end

        for _, player in pairs(Players:GetPlayers()) do
            createTracer(player)
        end

        Players.PlayerAdded:Connect(createTracer)
    end
end, {hasColorPicker = true})

-- Toggle GUI
local guiVisible = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightAlt then
        guiVisible = not guiVisible
        MainFrame.Visible = guiVisible
    end
end)

showNotification("CrazyHueta ESP Injected!")
print("Xeno ESP Loaded. Press RALT to toggle.")
