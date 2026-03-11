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

-- Window Style
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 127)
Stroke.Thickness = 2

Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "ABHISHEK MOD"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- --- BUTTON CREATOR ---
local function CreateToggleButton(name, varName)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = name .. (_G[varName] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(40, 40, 40)
    end)
end

-- Create Menu Buttons
CreateToggleButton("AIMBOT", "Aimbot")
CreateToggleButton("ESP BOX (Wallhack)", "ESP_Box")
CreateToggleButton("ESP NAME", "ESP_Name")
CreateToggleButton("ESP HEALTH", "ESP_Health")

-- --- FOV CIRCLE ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 127)
FOVCircle.Visible = true
FOVCircle.Radius = _G.FOV

-- --- SMART AIMBOT LOGIC ---
local function GetClosestPlayer()
    local target = nil
    local shortestDistance = _G.FOV

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local head = v.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        target = v
                    end
                end
            end
        end
    end
    return target
end

-- --- ESP LOGIC ---
local function ApplyESP(p)
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        local char = p.Character
        
        -- Box/Highlight
        local h = char:FindFirstChild("AB_High") or Instance.new("Highlight", char)
        h.Name = "AB_High"
        h.Enabled = _G.ESP_Box
        h.FillColor = Color3.fromRGB(255, 0, 0)

        -- Info Label
        local head = char:FindFirstChild("Head")
        if head then
            local b = head:FindFirstChild("AB_Info") or Instance.new("BillboardGui", head)
            b.Name = "AB_Info"
            b.AlwaysOnTop = true
            b.Size = UDim2.new(0, 100, 0, 40)
            b.ExtentsOffset = Vector3.new(0, 2, 0)
            
            local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
            l.Name = "L"
            l.BackgroundTransparency = 1
            l.Size = UDim2.new(1, 0, 1, 0)
            l.TextColor3 = Color3.fromRGB(255, 255, 255)
            l.Font = Enum.Font.GothamBold
            l.TextSize = 11

            local text = ""
            if _G.ESP_Name then text = text .. p.Name .. "\n" end
            if _G.ESP_Health then text = text .. math.floor(char.Humanoid.Health) .. " HP" end
            l.Text = text
            l.Visible = (_G.ESP_Name or _G.ESP_Health)
        end
    end
end

-- --- MAIN LOOP ---
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Visible = _G.Aimbot

    if _G.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character:FindFirstChild("Head") then
            -- Smooth Lock
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then ApplyESP(p) end
    end
end)
