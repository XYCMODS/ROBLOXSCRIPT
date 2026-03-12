local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- --- SETTINGS & VARIABLES ---
_G.Aimbot = false
_G.AutoFire = false
_G.AimbotFOV = 150
_G.ESP_Box = false
_G.ESP_Lines = false
_G.ESP_Name = false
_G.TeamCheck = true
_G.ESP_ColorIndex = 1
_G.FOV_ColorIndex = 1

local ColorPresets = {
    {Name = "Premium Green", Color = Color3.fromRGB(0, 255, 127)},
    {Name = "Red", Color = Color3.fromRGB(255, 0, 0)},
    {Name = "Blue", Color = Color3.fromRGB(0, 100, 255)},
    {Name = "Pink", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "Yellow", Color = Color3.fromRGB(255, 255, 0)},
    {Name = "White", Color = Color3.fromRGB(255, 255, 255)}
}

local function GetESPColor() return ColorPresets[_G.ESP_ColorIndex].Color end
local function GetFOVColor() return ColorPresets[_G.FOV_ColorIndex].Color end

-- --- LOAD CUSTOM LOGO ---
local CustomLogoImage = ""
pcall(function()
    local url = "https://i.supaimg.com/8b0f695c-2b86-4162-bacc-ed123dddbfa7/4ee53c99-1d32-4298-aebd-fea26915d594.png"
    local imageData = game:HttpGet(url)
    writefile("AbhishekMod_Logo.png", imageData)
    CustomLogoImage = (getcustomasset or getsynasset)("AbhishekMod_Logo.png")
end)

-- --- 1. UI CREATION ---
local GUI = Instance.new("ScreenGui", CoreGui)
GUI.Name = "ABHISHEK MODS"

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 380, 0, 280)
Main.Position = UDim2.new(0.5, -190, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 127)

-- FLOATING LOGO BUTTON
local LogoButton = Instance.new("ImageButton", GUI)
LogoButton.Size = UDim2.new(0, 55, 0, 55)
LogoButton.Position = UDim2.new(0.05, 0, 0.15, 0)
LogoButton.Image = CustomLogoImage
LogoButton.Visible = false; LogoButton.Draggable = true
Instance.new("UICorner", LogoButton).CornerRadius = UDim.new(1, 0)
LogoButton.MouseButton1Click:Connect(function() Main.Visible = true; LogoButton.Visible = false end)

-- HEADER
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -40, 0, 40); Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "ABHISHEK MOD v2"; Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.Font = "GothamBold"; Title.TextSize = 16; Title.BackgroundTransparency = 1; Title.TextXAlignment = "Left"

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"; Close.BackgroundColor3 = Color3.fromRGB(180, 0, 0); Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() Main.Visible = false; LogoButton.Visible = true end)

-- SIDEBAR TABS
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 95, 1, -45); Sidebar.Position = UDim2.new(0, 5, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -110, 1, -45); Pages.Position = UDim2.new(0, 105, 0, 40); Pages.BackgroundTransparency = 1

local PageMain = Instance.new("ScrollingFrame", Pages); PageMain.Size = UDim2.new(1,0,1,0); PageMain.BackgroundTransparency = 1; PageMain.ScrollBarThickness = 0
local PageVis = Instance.new("ScrollingFrame", Pages); PageVis.Size = UDim2.new(1,0,1,0); PageVis.Visible = false; PageVis.BackgroundTransparency = 1; PageVis.ScrollBarThickness = 0
local PageCol = Instance.new("ScrollingFrame", Pages); PageCol.Size = UDim2.new(1,0,1,0); PageCol.Visible = false; PageCol.BackgroundTransparency = 1; PageCol.ScrollBarThickness = 0

Instance.new("UIListLayout", PageMain).Padding = UDim.new(0, 6)
Instance.new("UIListLayout", PageVis).Padding = UDim.new(0, 6)
Instance.new("UIListLayout", PageCol).Padding = UDim.new(0, 6)

local function CreateTab(name, pos, page)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"; btn.TextSize = 10
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        PageMain.Visible = false; PageVis.Visible = false; PageCol.Visible = false
        page.Visible = true
    end)
end

CreateTab("MAIN", 10, PageMain); CreateTab("VISUALS", 50, PageVis); CreateTab("COLORS", 90, PageCol)

-- BUTTON HELPER
local function CreateToggle(parent, text, varName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. ": OFF"; btn.TextColor3 = Color3.new(1,1,1); btn.Font = "Gotham"
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = text .. (_G[varName] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
    end)
end

CreateToggle(PageMain, "Aimbot", "Aimbot")
CreateToggle(PageMain, "Auto Fire", "AutoFire")
CreateToggle(PageMain, "Team Check", "TeamCheck")
CreateToggle(PageVis, "Box ESP", "ESP_Box")
CreateToggle(PageVis, "Line ESP", "ESP_Lines")
CreateToggle(PageVis, "Name ESP", "ESP_Name")

-- --- 2. GAME LOGIC ---
local Tracers = {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.Aimbot
    FOVCircle.Radius = _G.AimbotFOV
    FOVCircle.Color = GetFOVColor()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if _G.Aimbot then
        local target = nil; local dist = _G.AimbotFOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
                if _G.TeamCheck and v.Team == LocalPlayer.Team then continue end
                local pos, screen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if screen then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag; target = v end
                end
            end
        end
        if target then 
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.25)
            if _G.AutoFire then mouse1press(); task.wait(0.05); mouse1release() end
        end
    end

    -- ESP & Tracers
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local shouldShow = (_G.TeamCheck and isEnemy) or (not _G.TeamCheck)
            local pos, screen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)

            if shouldShow and screen and p.Character.Humanoid.Health > 0 then
                local h = p.Character:FindFirstChild("AB_H") or Instance.new("Highlight", p.Character)
                h.Name = "AB_H"; h.Enabled = _G.ESP_Box; h.OutlineColor = GetESPColor(); h.FillTransparency = 1
                
                if _G.ESP_Lines then
                    if not Tracers[p] then Tracers[p] = Drawing.new("Line") end
                    Tracers[p].Visible = true; Tracers[p].Color = GetESPColor()
                    Tracers[p].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); Tracers[p].To = Vector2.new(pos.X, pos.Y)
                else if Tracers[p] then Tracers[p].Visible = false end end
            else
                if p.Character:FindFirstChild("AB_H") then p.Character.AB_H.Enabled = false end
                if Tracers[p] then Tracers[p].Visible = false end
            end
        end
    end
end)
