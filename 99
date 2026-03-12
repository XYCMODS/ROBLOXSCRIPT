local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- --- SETTINGS & VARIABLES ---
_G.AutoChest = false
_G.AutoCutTree = false
_G.AutoPlantTree = false
_G.GodMode = false
_G.PlayerSpeed = 16

-- --- 1. GUI CREATION ---
local GUI = Instance.new("ScreenGui")
GUI.Name = "AbhishekPremium_Farming"
local success = pcall(function() GUI.Parent = CoreGui end)
if not success then GUI.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- --- 2. MAIN MENU FRAME ---
local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 400, 0, 280)
Main.Position = UDim2.new(0.5, -200, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 127)
Instance.new("UIStroke", Main).Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "ABHISHEK MOD - PREMIUM"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

-- --- 3. TABS SETUP ---
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 100, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -110, 1, -40)
Pages.Position = UDim2.new(0, 105, 0, 40)
Pages.BackgroundTransparency = 1

local PagePlayer = Instance.new("ScrollingFrame", Pages); PagePlayer.Size = UDim2.new(1,0,1,0); PagePlayer.BackgroundTransparency = 1; PagePlayer.ScrollBarThickness = 0
local PageFarm = Instance.new("ScrollingFrame", Pages); PageFarm.Size = UDim2.new(1,0,1,0); PageFarm.BackgroundTransparency = 1; PageFarm.ScrollBarThickness = 0; PageFarm.Visible = false

local LayoutPlayer = Instance.new("UIListLayout", PagePlayer); LayoutPlayer.Padding = UDim.new(0, 8); LayoutPlayer.HorizontalAlignment = Enum.HorizontalAlignment.Center
local LayoutFarm = Instance.new("UIListLayout", PageFarm); LayoutFarm.Padding = UDim.new(0, 8); LayoutFarm.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateTabBtn(name, pos, activePage)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        PagePlayer.Visible = false; PageFarm.Visible = false
        activePage.Visible = true
        for _, v in pairs(Sidebar:GetChildren()) do
            if v:IsA("TextButton") then
                v.TextColor3 = Color3.fromRGB(180, 180, 180)
                v.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            end
        end
        btn.TextColor3 = Color3.fromRGB(0, 255, 127)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
    return btn
end

local TabPlayer = CreateTabBtn("PLAYER", 10, PagePlayer)
TabPlayer.TextColor3 = Color3.fromRGB(0, 255, 127); TabPlayer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
local TabFarm = CreateTabBtn("FARMING", 55, PageFarm)

-- --- 4. TOGGLES & SLIDERS ---
local function CreateToggle(parent, text, varName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = text .. (_G[varName] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = _G[varName] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 255, 255)
    end)
end

-- POPULATING PLAYER TAB
CreateToggle(PagePlayer, "God Mode (Infinite HP)", "GodMode")

-- Speed Slider
local sliderFrame = Instance.new("Frame", PagePlayer); sliderFrame.Size = UDim2.new(0.95, 0, 0, 50); sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
local sliderLabel = Instance.new("TextLabel", sliderFrame); sliderLabel.Size = UDim2.new(1, 0, 0.5, 0); sliderLabel.Text = "Walk Speed: " .. _G.PlayerSpeed; sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255); sliderLabel.Font = Enum.Font.GothamBold; sliderLabel.TextSize = 12; sliderLabel.BackgroundTransparency = 1
local sliderBtn = Instance.new("TextButton", sliderFrame); sliderBtn.Size = UDim2.new(0.9, 0, 0.2, 0); sliderBtn.Position = UDim2.new(0.05, 0, 0.6, 0); sliderBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); sliderBtn.Text = ""; Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)
local sliderFill = Instance.new("Frame", sliderBtn); sliderFill.Size = UDim2.new(0.1, 0, 1, 0); sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127); Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local dragging = false
sliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local percent = math.clamp((UserInputService:GetMouseLocation().X - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        _G.PlayerSpeed = math.floor(16 + (percent * 100)) -- Speed 16 to 116
        sliderLabel.Text = "Walk Speed: " .. _G.PlayerSpeed
    end
end)

-- POPULATING FARMING TAB
CreateToggle(PageFarm, "Auto Open All Chests", "AutoChest")
CreateToggle(PageFarm, "Auto Cut Trees", "AutoCutTree")
CreateToggle(PageFarm, "Auto Plant Trees", "AutoPlantTree")

-- --- 5. HACK LOGIC (GOD MODE, SPEED, FARMING) ---

-- Universal ProximityPrompt Fire Function (Chests ani Trees sathi)
local function FirePrompt(nameKeyword)
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local parentName = string.lower(prompt.Parent.Name)
            if string.find(parentName, nameKeyword) then
                -- Player chya javal ahe ka check kara (Teleport or direct fire)
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    prompt.HoldDuration = 0 -- Instant open
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end

-- Main Loop (Farming ani God Mode sathi)
task.spawn(function()
    while task.wait(0.5) do
        -- 1. God Mode Logic (Health full thevte)
        if _G.GodMode then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = char.Humanoid.MaxHealth
            end
        end

        -- 2. Auto Chest Logic
        if _G.AutoChest then
            FirePrompt("chest")
            FirePrompt("box")
            FirePrompt("crate")
        end

        -- 3. Auto Cut Tree Logic
        if _G.AutoCutTree then
            FirePrompt("tree")
            FirePrompt("wood")
        end

        -- 4. Auto Plant Tree Logic
        if _G.AutoPlantTree then
            FirePrompt("seed")
            FirePrompt("plant")
            FirePrompt("dirt")
        end
    end
end)

-- Speed Logic (Fast movement sathi)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if char.Humanoid.WalkSpeed ~= _G.PlayerSpeed and _G.PlayerSpeed > 16 then
            char.Humanoid.WalkSpeed = _G.PlayerSpeed
        end
    end
end)
