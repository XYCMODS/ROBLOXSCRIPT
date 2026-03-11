local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Toggle Variable
_G.ESP_Enabled = false

-- --- UI SECTION ---
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainButton = Instance.new("TextButton", ScreenGui)
local UICorner = Instance.new("UICorner", MainButton)
local UIStroke = Instance.new("UIStroke", MainButton)

MainButton.Size = UDim2.new(0, 70, 0, 70)
MainButton.Position = UDim2.new(0.1, 0, 0.5, 0)
MainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainButton.Text = "ESP OFF"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Font = Enum.Font.GothamBold
MainButton.TextSize = 14
UICorner.CornerRadius = UDim.new(0, 15)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 0)

-- Draggable Logic
local dragging, dragInput, dragStart, startPos
MainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
MainButton.InputEnded:Connect(function(input) dragging = false end)

-- --- ESP FEATURES LOGIC ---
local function CreateESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = "FullESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "InfoGui"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.ExtentsOffset = Vector3.new(0, 3, 0)
    
    local label = Instance.new("TextLabel", billboard)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12

    local function Update()
        if _G.ESP_Enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            highlight.Parent = player.Character
            billboard.Parent = player.Character:FindFirstChild("HumanoidRootPart")
            
            local dist = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
            label.Text = string.format("%s\n[%s m]", player.Name, dist)
        else
            highlight.Parent = nil
            billboard.Parent = nil
        end
    end

    RunService.RenderStepped:Connect(Update)
end

-- Toggle Function
MainButton.MouseButton1Click:Connect(function()
    _G.ESP_Enabled = not _G.ESP_Enabled
    if _G.ESP_Enabled then
        MainButton.Text = "ESP ON"
        MainButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        UIStroke.Color = Color3.fromRGB(255, 255, 255)
    else
        MainButton.Text = "ESP OFF"
        MainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        UIStroke.Color = Color3.fromRGB(255, 0, 0)
    end
end)

-- Apply to everyone
for _, p in pairs(Players:GetPlayers()) do
    if p ~= Players.LocalPlayer then CreateESP(p) end
end
Players.PlayerAdded:Connect(function(p) CreateESP(p) end)
