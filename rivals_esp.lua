local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Variables Setup
_G.Aimbot = false
_G.FOV = 150
_G.ESP_Box = false
_G.ESP_Name = false
_G.ESP_Health = false

-- --- 1. GUI CREATION (With Safe Load) ---
local GUI = Instance.new("ScreenGui")
GUI.Name = "AbhishekPremium"
-- Executor safe parent
local success = pcall(function() GUI.Parent = CoreGui end)
if not success then GUI.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- --- 2. MAIN MENU FRAME ---
local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 360, 0, 240)
Main.Position = UDim2.new(0.5, -180, 0.5, -120)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 127)
Instance.new("UIStroke", Main).Thickness = 2

-- --- 3. FLOATING LOGO ---
local Logo = Instance.new("TextButton", GUI)
Logo.Size = UDim2.new(0, 45, 0, 45)
Logo.Position = UDim2.new(0.05, 0, 0.15, 0)
Logo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Logo.Text = "AM"
Logo.TextColor3 = Color3.fromRGB(0, 255, 127)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 18
Logo.Visible = false
Logo.Active = true
Logo.Draggable = true
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Logo).Color = Color3.fromRGB(0, 255, 127)
Instance.new("UIStroke", Logo).Thickness = 2

Logo.MouseButton1Click:Connect(function()
    Main.Visible = true
    Logo.Visible = false
    Main.Position = UDim2.new(0.5, -180, 0.5, -120) -- Center reset
end)

-- Header Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Text = "  ABHISHEK MOD v2"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Logo.Visible = true
end)

-- --- 4. TABS SETUP ---
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 90, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -100, 1, -40)
Pages.Position = UDim2.new(0, 95, 0, 40)
Pages.BackgroundTransparency = 1

local PageMain = Instance.new("Frame", Pages)
PageMain.Size = UDim2.new(1, 0, 1, 0)
PageMain.BackgroundTransparency = 1
local LayoutMain = Instance.new("UIListLayout", PageMain)
LayoutMain.Padding = UDim.new(0, 8)
LayoutMain.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PageVis = Instance.new("Frame", Pages)
PageVis.Size = UDim2.new(1, 0, 1, 0)
PageVis.BackgroundTransparency = 1
PageVis.Visible = false
local LayoutVis = Instance.new("UIListLayout", PageVis)
LayoutVis.Padding = UDim.new(0, 8)
LayoutVis.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateTabBtn(name, pos, openPage, closePage)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        openPage.Visible = true
        closePage.Visible = false
        for _, v in pairs(Sidebar:GetChildren()) do
            if v:IsA("TextButton") then
                v.TextColor3 = Color3.fromRGB(180, 180, 180)
                v.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            end
        end
        btn.TextColor3 = Color3.fromRGB(0, 255, 127)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
    return btn
end

local TabMain = CreateTabBtn("MAIN", 10, PageMain, PageVis)
TabMain.TextColor3 = Color3.fromRGB(0, 255, 127)
TabMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local TabVis = CreateTabBtn("VISUALS", 55, PageVis, PageMain)

-- --- 5. TOGGLES & SLIDER ---
local function CreateToggle(parent, text, varName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = text .. (_G[varName] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = _G[varName] and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    end)
end

-- Main Page Elements
CreateToggle(PageMain, "Enable Aimbot", "Aimbot")

local sliderFrame = Instance.new("Frame", PageMain)
sliderFrame.Size = UDim2.new(0.95, 0, 0, 45)
sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)

local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(1, 0, 0.5, 0)
sliderLabel.Text = "Aimbot FOV: " .. _G.FOV
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.Font = Enum.Font.GothamBold
sliderLabel.TextSize = 11
sliderLabel.BackgroundTransparency = 1

local sliderBtn = Instance.new("TextButton", sliderFrame)
sliderBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
sliderBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
sliderBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBtn.Text = ""
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame", sliderBtn)
sliderFill.Size = UDim2.new(0.3, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local dragging = false
sliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation().X
        local relPos = mousePos - sliderBtn.AbsolutePosition.X
        local percent = math.clamp(relPos / sliderBtn.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        _G.FOV = math.floor(50 + (percent * 350))
        sliderLabel.Text = "Aimbot FOV: " .. _G.FOV
    end
end)

-- Visuals Page Elements
CreateToggle(PageVis, "Box ESP", "ESP_Box")
CreateToggle(PageVis, "Name ESP", "ESP_Name")
CreateToggle(PageVis, "Health ESP", "ESP_Health")

-- --- 6. LOGIC (AIMBOT + WALL CHECK + ESP) ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.fromRGB(0, 255, 127); FOVCircle.Filled = false

local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local ray = RaycastParams.new()
    ray.FilterType = Enum.RaycastFilterType.Exclude
    ray.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    return workspace:Raycast(origin, part.Position - origin, ray) == nil
end

local function GetTarget()
    local target = nil
    local dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, screen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if screen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist and IsVisible(v.Character.Head) then
                    dist = mag; target = v
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
        local t = GetTarget()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Character.Head.Position), 0.5)
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            -- Wallhack Box
            local h = p.Character:FindFirstChild("AB_H") or Instance.new("Highlight", p.Character)
            h.Name = "AB_H"; h.Enabled = _G.ESP_Box; h.FillTransparency = 1; h.OutlineColor = Color3.fromRGB(0, 255, 127)
            
            -- Name & Health
            local head = p.Character:FindFirstChild("Head")
            if head then
                local b = head:FindFirstChild("AB_B") or Instance.new("BillboardGui", head)
                b.Name = "AB_B"; b.AlwaysOnTop = true; b.Size = UDim2.new(0, 100, 0, 40); b.ExtentsOffset = Vector3.new(0, 2, 0)
                
                local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
                l.Name = "L"; l.BackgroundTransparency = 1; l.Size = UDim2.new(1,0,1,0); l.TextColor3 = Color3.fromRGB(255,255,255)
                l.Font = Enum.Font.GothamBold; l.TextSize = 10
                
                local txt = ""
                if _G.ESP_Name then txt = txt .. p.Name .. "\n" end
                if _G.ESP_Health and p.Character:FindFirstChild("Humanoid") then txt = txt .. math.floor(p.Character.Humanoid.Health) .. " HP" end
                l.Text = txt; l.Visible = (_G.ESP_Name or _G.ESP_Health)
            end
        end
    end
end)
