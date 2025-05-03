local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ClickGUI Library
local ClickGUI = {}
ClickGUI.__index = ClickGUI

-- Create a new ClickGUI instance
function ClickGUI.new()
local self = setmetatable({}, ClickGUI)

-- Create ScreenGui
self.ScreenGui = Instance.new("ScreenGui")
self.ScreenGui.Name = "ClickGUI"
self.ScreenGui.Parent = game.CoreGui
self.ScreenGui.ResetOnSpawn = false

-- Create Main Frame
self.MainFrame = Instance.new("Frame")
self.MainFrame.Size = UDim2.new(0, 500, 0, 300)
self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
self.MainFrame.BorderSizePixel = 0
self.MainFrame.Visible = false
self.MainFrame.Parent = self.ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = self.MainFrame

-- Create Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = self.MainFrame

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

-- Make GUI Draggable (using TopBar)
local dragging = false
local dragStartPos, startPos
TopBar.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
dragStartPos = input.Position
startPos = self.MainFrame.Position
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
self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)

-- Create Sidebar
self.Sidebar = Instance.new("Frame")
self.Sidebar.Size = UDim2.new(0, 120, 0, 270)
self.Sidebar.Position = UDim2.new(0, 0, 0, 30)
self.Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
self.Sidebar.BorderSizePixel = 0
self.Sidebar.Parent = self.MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = self.Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 10)
SidebarList.Parent = self.Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 5)
SidebarPadding.PaddingRight = UDim.new(0, 5)
SidebarPadding.Parent = self.Sidebar

-- Create Content Area
self.Content = Instance.new("Frame")
self.Content.Size = UDim2.new(0, 380, 0, 270)
self.Content.Position = UDim2.new(0, 120, 0, 30)
self.Content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
self.Content.BorderSizePixel = 0
self.Content.Parent = self.MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = self.Content

-- Tab Management
self.Tabs = {}
self.TabButtons = {}
self.CurrentTab = nil

-- Notification System
self.Notifications = {}

return self
end

-- Create a new tab
function ClickGUI:CreateTab(name)
local TabButton = Instance.new("TextButton")
TabButton.Size = UDim2.new(1, 0, 0, 40)
TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TabButton.Text = name
TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TabButton.Font = Enum.Font.SourceSansBold
TabButton.TextSize = 18
TabButton.BorderSizePixel = 0
TabButton.Parent = self.Sidebar
TabButton.LayoutOrder = #self.Tabs + 1

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
TabContent.Parent = self.Content

local ContentList = Instance.new("UIListLayout")
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, 10)
ContentList.Parent = TabContent

ContentList.Changed:Connect(function()
TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
end)

self.Tabs[name] = TabContent
self.TabButtons[name] = TabButton

TabButton.MouseButton1Click:Connect(function()
if self.CurrentTab ~= name then
if self.CurrentTab then
self.Tabs[self.CurrentTab].Visible = false
self.TabButtons[self.CurrentTab].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end
self.CurrentTab = name
self.Tabs[name].Visible = true
self.TabButtons[name].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end
end)
end

-- Show Notification
function ClickGUI:ShowNotification(message)
local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "FunctionNotification"
NotificationGui.Parent = game.CoreGui

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0, 200, 0, 50)
NotificationFrame.Position = UDim2.new(1, 10, 1, -60 - (#self.Notifications * 60))
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

table.insert(self.Notifications, NotificationFrame)

-- Fly-in animation
local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -210, 1, -60 - (#self.Notifications * 60))})
tweenIn:Play()
tweenIn.Completed:Wait()

wait(2)

-- Fly-out animation
local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 1, -60 - (#self.Notifications * 60))})
tweenOut:Play()
tweenOut.Completed:Wait()

table.remove(self.Notifications, 1)
for i, notif in ipairs(self.Notifications) do
notif.Position = UDim2.new(1, -210, 1, -60 - (i * 60))
end
NotificationGui:Destroy()
end

-- Create a Function Module
function ClickGUI:CreateFunctionModule(tabName, funcName, defaultBind, callback, options)
options = options or {}
local hasSlider = options.hasSlider or false
local hasEspToggles = options.hasEspToggles or false
local hasColorPicker = options.hasColorPicker or false

local height = 70
if hasSlider then height = height + 40 end
if hasEspToggles then height = height + 30 end
if hasColorPicker then height = height + 40 end

local FuncFrame = Instance.new("Frame")
FuncFrame.Size = UDim2.new(1, -10, 0, height)
FuncFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FuncFrame.BorderSizePixel = 0
FuncFrame.Parent = self.Tabs[tabName]

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

-- Slider (if applicable)
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

-- ESP Toggles (if applicable)
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

-- Color Picker (if applicable)
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
self:ShowNotification(funcName .. " was " .. (isEnabled and "Enabled" or "Disabled"))
if callback then
if hasEspToggles then
callback(isEnabled, espSettings, Color3.fromRGB(colorSettings.r, colorSettings.g, colorSettings.b))
elseif hasColorPicker then
callback(isEnabled, Color3.fromRGB(colorSettings.r, colorSettings.g, colorSettings.b))
else
callback(isEnabled, SliderValue)
end
end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentBind then
isEnabled = not isEnabled
ToggleButton.Text = isEnabled and "ON" or "OFF"
ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
self:ShowNotification(funcName .. " was " .. (isEnabled and "Enabled" or "Disabled"))
if callback then
if hasEspToggles then
callback(isEnabled, espSettings, Color3.fromRGB(colorSettings.r, colorSettings.g, colorSettings.b))
elseif hasColorPicker then
callback(isEnabled, Color3.fromRGB(colorSettings.r, colorSettings.g, colorSettings.b))
else
callback(isEnabled, SliderValue)
end
end
end
end)
end

-- Toggle GUI Visibility
function ClickGUI:Toggle()
local guiVisible = not self.MainFrame.Visible
self.MainFrame.Visible = guiVisible
if guiVisible and not self.CurrentTab then
self.CurrentTab = next(self.Tabs)
if self.CurrentTab then
self.Tabs[self.CurrentTab].Visible = true
self.TabButtons[self.CurrentTab].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end
end
end

-- Destroy GUI
function ClickGUI:Destroy()
self.ScreenGui:Destroy()
end

return ClickGUI
