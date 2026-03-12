local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- --- SETTINGS ---
_G.Aimbot = false
_G.AutoFire = false
_G.ESP_Enabled = false
_G.TeamCheck = true -- Iska button menu mein add kar diya hai
_G.AimbotFOV = 150

-- --- GUI ---
local GUI = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 380, 0, 350)
Main.Position = UDim2.new(0.5, -190, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Draggable = true; Main.Active = true
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 127)

local PageMain = Instance.new("ScrollingFrame", Main)
PageMain.Size = UDim2.new(1, -20, 1, -60); PageMain.Position = UDim2.new(0, 10, 0, 50)
PageMain.BackgroundTransparency = 1; PageMain.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", PageMain); Layout.Padding = UDim.new(0, 8); Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateToggle(text, varName)
    local btn = Instance.new("TextButton", PageMain)
    btn.Size = UDim2.new(0.95, 0, 0, 38); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. ": OFF"; btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = text .. (_G[varName] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(30, 30, 30)
    end)
end

-- Buttons
CreateToggle("Enable Aimbot", "Aimbot")
CreateToggle("Enable Auto Fire", "AutoFire")
CreateToggle("Enable Visuals (ESP)", "ESP_Enabled")
CreateToggle("Team Check (Ignore Team)", "TeamCheck") -- TEAM CHECK BUTTON

-- --- LOGIC ---
local Tracers = {}

RunService.RenderStepped:Connect(function()
    -- Aimbot Logic
    if _G.Aimbot then
        local target = nil; local dist = _G.AimbotFOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
                if _G.TeamCheck and v.Team == LocalPlayer.Team then continue end
                local pos, screen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if screen then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if mag < dist then dist = mag; target = v end
                end
            end
        end
        if target then 
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.3) 
            if _G.AutoFire then mouse1press(); task.wait(); mouse1release() end
        end
    end

    -- ESP Logic
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isTeammate = (p.Team == LocalPlayer.Team)
            local hrp = p.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            -- Team Check Toggle Logic
            local shouldShow = _G.ESP_Enabled
            if _G.TeamCheck and isTeammate then shouldShow = false end

            if shouldShow and onScreen and p.Character.Humanoid.Health > 0 then
                -- Highlighter Box
                local h = p.Character:FindFirstChild("AB_H") or Instance.new("Highlight", p.Character)
                h.Name = "AB_H"; h.Enabled = true; h.FillTransparency = 1
                h.OutlineColor = isTeammate and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                
                -- Line ESP
                if not Tracers[p] then Tracers[p] = Drawing.new("Line"); Tracers[p].Thickness = 1.5 end
                Tracers[p].Visible = true
                Tracers[p].Color = h.OutlineColor
                Tracers[p].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                Tracers[p].To = Vector2.new(pos.X, pos.Y)
            else
                if p.Character:FindFirstChild("AB_H") then p.Character.AB_H.Enabled = false end
                if Tracers[p] then Tracers[p].Visible = false end
            end
        end
    end
end)
