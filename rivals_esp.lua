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

local ColorPresets = {
    {Name = "Premium Green", Color = Color3.fromRGB(0, 255, 127)},
    {Name = "Red", Color = Color3.fromRGB(255, 0, 0)},
    {Name = "Blue", Color = Color3.fromRGB(0, 100, 255)},
    {Name = "Yellow", Color = Color3.fromRGB(255, 255, 0)}
}

local function GetESPColor() return ColorPresets[_G.ESP_ColorIndex].Color end

-- --- 1. FULL PREMIUM UI CREATION ---
local GUI = Instance.new("ScreenGui", CoreGui)
GUI.Name = "ABHISHEK MODS"

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Draggable = true; Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 127); Stroke.Thickness = 2

-- SIDEBAR (TABS)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 100, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

-- PAGES CONTAINER
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -110, 1, -50); Pages.Position = UDim2.new(0, 105, 0, 45); Pages.BackgroundTransparency = 1

local PageMain = Instance.new("ScrollingFrame", Pages); PageMain.Size = UDim2.new(1,0,1,0); PageMain.Visible = true; PageMain.BackgroundTransparency = 1; PageMain.ScrollBarThickness = 0
local PageVis = Instance.new("ScrollingFrame", Pages); PageVis.Size = UDim2.new(1,0,1,0); PageVis.Visible = false; PageVis.BackgroundTransparency = 1; PageVis.ScrollBarThickness = 0

Instance.new("UIListLayout", PageMain).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", PageVis).Padding = UDim.new(0, 5)

-- TAB BUTTONS LOGIC
local function CreateTab(name, pos, page)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        PageMain.Visible = false; PageVis.Visible = false
        page.Visible = true
    end)
end

CreateTab("MAIN", 10, PageMain)
CreateTab("VISUALS", 50, PageVis)

-- TOGGLE HELPER
local function CreateToggle(parent, text, varName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = text .. ": OFF"; btn.TextColor3 = Color3.new(1,1,1); btn.Font = "Gotham"
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = text .. (_G[varName] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(35, 35, 35)
    end)
end

-- ADDING BUTTONS
CreateToggle(PageMain, "Aimbot", "Aimbot")
CreateToggle(PageMain, "Auto Fire", "AutoFire")
CreateToggle(PageMain, "Team Check", "TeamCheck")
CreateToggle(PageVis, "Box ESP", "ESP_Box")
CreateToggle(PageVis, "Line ESP", "ESP_Lines")
CreateToggle(PageVis, "Name ESP", "ESP_Name")

-- --- 2. GAME LOGIC ---
local Tracers = {}

RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local target = nil; local dist = _G.AimbotFOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                if _G.TeamCheck and v.Team == LocalPlayer.Team then continue end
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag; target = v end
                end
            end
        end
        if target then 
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.2)
            if _G.AutoFire then mouse1press(); task.wait(); mouse1release() end
        end
    end

    -- ESP LOGIC
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local shouldShow = (_G.TeamCheck and isEnemy) or (not _G.TeamCheck)
            local pos, screen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)

            if shouldShow and screen and p.Character.Humanoid.Health > 0 then
                -- Highlighter Box
                local h = p.Character:FindFirstChild("AB_H") or Instance.new("Highlight", p.Character)
                h.Name = "AB_H"; h.Enabled = _G.ESP_Box; h.OutlineColor = GetESPColor(); h.FillTransparency = 1
                
                -- Tracers
                if _G.ESP_Lines then
                    if not Tracers[p] then Tracers[p] = Drawing.new("Line"); Tracers[p].Thickness = 1.2 end
                    Tracers[p].Visible = true; Tracers[p].Color = GetESPColor()
                    Tracers[p].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); Tracers[p].To = Vector2.new(pos.X, pos.Y)
                else
                    if Tracers[p] then Tracers[p].Visible = false end
                end
            else
                if p.Character:FindFirstChild("AB_H") then p.Character.AB_H.Enabled = false end
                if Tracers[p] then Tracers[p].Visible = false end
            end
        end
    end
end)
