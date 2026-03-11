local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- --- SETTINGS ---
_G.Aimbot = false
_G.ESP_Box = false
_G.ESP_Name = false
_G.ESP_Health = false
_G.FOV = 150 

-- --- UI CREATION ---
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local Layout = Instance.new("UIListLayout", MainFrame)
local Title = Instance.new("TextLabel", MainFrame)

MainFrame.Size = UDim2.new(0, 200, 0, 360) -- Height thodi badha di buttons ke liye
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 127)
Stroke.Thickness = 2

Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "ABHISHEK MODS"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- --- BUTTON CREATOR ---
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- --- FEATURES ---
CreateButton("AIMBOT: OFF", function(btn)
    _G.Aimbot = not _G.Aimbot
    btn.Text = _G.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    btn.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(40, 40, 40)
end)

CreateButton("FOV: " .. _G.FOV, function(btn)
    if _G.FOV >= 400 then _G.FOV = 100 else _G.FOV = _G.FOV + 50 end
    btn.Text = "FOV: " .. _G.FOV
end)

CreateButton("ESP BOX: OFF", function(btn)
    _G.ESP_Box = not _G.ESP_Box
    btn.Text = _G.ESP_Box and "ESP BOX: ON" or "ESP BOX: OFF"
    btn.BackgroundColor3 = _G.ESP_Box and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(40, 40, 40)
end)

CreateButton("ESP NAME: OFF", function(btn)
    _G.ESP_Name = not _G.ESP_Name
    btn.Text = _G.ESP_Name and "ESP NAME: ON" or "ESP NAME: OFF"
    btn.BackgroundColor3 = _G.ESP_Name and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(40, 40, 40)
end)

CreateButton("ESP HEALTH: OFF", function(btn)
    _G.ESP_Health = not _G.ESP_Health
    btn.Text = _G.ESP_Health and "ESP HEALTH: ON" or "ESP HEALTH: OFF"
    btn.BackgroundColor3 = _G.ESP_Health and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(40, 40, 40)
end)

CreateButton("CLOSE MENU (HIDE)", function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

-- --- FOV CIRCLE FIX ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 127)
FOVCircle.Filled = false -- <<-- YE FIX HAI, AB GOLA NAHI DIKHEGA
FOVCircle.Transparency = 1

-- --- AIMBOT & ESP LOGIC ---
local function GetClosest()
    local target = nil
    local dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.Aimbot
    FOVCircle.Radius = _G.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if _G.Aimbot then
        local t = GetClosest()
        if t then
            -- Smooth Look Logic
            local targetPos = Camera:WorldToScreenPoint(t.Character.Head.Position)
            local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            h.Enabled = _G.ESP_Box
            h.FillColor = Color3.fromRGB(255, 0, 0)
            
            local head = p.Character:FindFirstChild("Head")
            if head then
                local b = head:FindFirstChild("Info") or Instance.new("BillboardGui", head)
                b.Name = "Info"
                b.AlwaysOnTop = true
                b.Size = UDim2.new(0, 100, 0, 40)
                b.ExtentsOffset = Vector3.new(0, 2, 0)
                local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
                l.Name = "L"
                l.BackgroundTransparency = 1
                l.Size = UDim2.new(1,0,1,0)
                l.TextColor3 = Color3.fromRGB(255, 255, 255)
                l.Font = Enum.Font.GothamBold
                l.TextSize = 10
                
                local txt = ""
                if _G.ESP_Name then txt = txt .. p.Name .. "\n" end
                if _G.ESP_Health then txt = txt .. math.floor(p.Character.Humanoid.Health) .. " HP" end
                l.Text = txt
                l.Visible = (_G.ESP_Name or _G.ESP_Health)
            end
        end
    end
end)
