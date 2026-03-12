local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- === GLOBAL SETTINGS ===
_G.GodMode = false
_G.MonsterESP = false
_G.AutoWood = false
_G.AutoPlant = false
_G.ItemTeleport = false
_G.OneTapAura = false
_G.FullBright = false
_G.WalkSpeed = 16

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Abhishek_Final_VIP"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 360, 0, 420)
Main.Position = UDim2.new(0.5, -180, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 127)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "ABHISHEK MOD - 99 NIGHTS VIP"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 1.8, 0)
Scroll.ScrollBarThickness = 3

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- === UI HELPER ===
local function CreateToggle(name, var)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.Text = name .. (_G[var] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(30, 30, 30)
    end)
end

-- === ADDING ALL FUNCTIONS ===
CreateToggle("God Mode (Infinite HP)", "GodMode")
CreateToggle("Monster ESP", "MonsterESP")
CreateToggle("Auto Wood (Hold Axe)", "AutoWood")
CreateToggle("Auto Plant Seeds", "AutoPlant")
CreateToggle("Item Teleport to Me", "ItemTeleport")
CreateToggle("1-Tap Kill Aura", "OneTapAura")
CreateToggle("Full Bright", "FullBright")

-- === SCRIPT LOGIC ===

-- 1. Monster ESP Logic
task.spawn(function()
    while task.wait(2) do
        if _G.MonsterESP then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= LocalPlayer.Name then
                    if not obj:FindFirstChild("ESP_Tag") then
                        local b = Instance.new("BillboardGui", obj)
                        b.Name = "ESP_Tag"; b.AlwaysOnTop = true; b.Size = UDim2.new(0,100,0,50); b.Adornee = obj:FindFirstChild("Head")
                        local t = Instance.new("TextLabel", b)
                        t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.new(1,0,0); t.Text = obj.Name; t.Font = "GothamBold"
                    end
                end
            end
        end
    end
end)

-- 2. Main Cheat Loop
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- God Mode
    if _G.GodMode then char.Humanoid.Health = 100 end

    -- Full Bright
    if _G.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 12 end

    -- Loop through Workspace for Items/Trees/Monsters
    for _, v in pairs(workspace:GetDescendants()) do
        -- Item Teleport & Auto-Pickup
        if (_G.ItemTeleport or _G.AutoPickup) and v:IsA("TouchTransmitter") then
            local obj = v.Parent
            if obj and (obj:IsA("BasePart") or obj:IsA("Model")) then
                if _G.ItemTeleport then
                    if obj:IsA("BasePart") then obj.CFrame = char.HumanoidRootPart.CFrame
                    elseif obj.PrimaryPart then obj:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame) end
                end
                firetouchinterest(char.HumanoidRootPart, obj, 0)
                firetouchinterest(char.HumanoidRootPart, obj, 1)
            end
        end

        -- Auto Wood & 1-Tap Kill (Aura)
        if (_G.AutoWood or _G.OneTapAura) and v:IsA("ProximityPrompt") then
            local dist = (char.HumanoidRootPart.Position - v.Parent.Position).Magnitude
            if dist < 25 then
                v.HoldDuration = 0
                fireproximityprompt(v)
            end
        end
    end
end)

-- 3. Player WalkSpeed
task.spawn(function()
    while task.wait() do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        end
    end
end)

print("Abhishek's All-In-One Script Loaded!")
