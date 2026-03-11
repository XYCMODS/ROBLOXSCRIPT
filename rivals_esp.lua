local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Variables (_G to persist settings across executions)
_G.Aimbot = _G.Aimbot or false
_G.ESP = _G.ESP or false
_G.FOV = 150
_G.Smoothness = 0.5 -- 0 to 1 (lower is stickier)

-- --- 1. SCRIPT PARENTING ---
-- Use CoreGui to avoid standard Roblox UI deletion on reset
local AbhishekGui = Instance.new("ScreenGui", CoreGui)
AbhishekGui.Name = "AbhishekModV2_Fixed"

-- --- 2. MAIN FRAME CREATION (The Big Menu) ---
local MainFrame = Instance.new("Frame", AbhishekGui)
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150) -- Default Center screen
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Dark Grey
MainFrame.Active = true
MainFrame.Draggable = true -- Big menu draggable
MainFrame.Visible = true -- Big menu visible by default

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(0, 255, 127) -- Premium Green
mainStroke.Thickness = 2

local layout = Instance.new("UIListLayout", MainFrame)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Title
local title = Instance.new("TextLabel", MainFrame)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "ABHISHEK MOD"
title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

-- --- 3. FLOATING LOGO (HIDE HONE KE BAAD AANE WALA ROUND BUTTON) ---
-- ***CRITICAL FIX HERE: Logo Button must be parented to ScreenGui, not MainFrame!***
local LogoButton = Instance.new("TextButton", AbhishekGui)
LogoButton.Size = UDim2.new(0, 50, 0, 50)
LogoButton.Position = UDim2.new(0.02, 0, 0.2, 0) -- Fixed initial logo pos on screen
LogoButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Dark Grey
LogoButton.Text = "AM"
LogoButton.TextColor3 = Color3.fromRGB(0, 255, 127) -- Premium Green
LogoButton.Font = Enum.Font.GothamBold
LogoButton.TextSize = 22
LogoButton.Visible = false -- Initially hidden while MainFrame is shown
LogoButton.Active = true
LogoButton.Draggable = true -- Logo draggable

Instance.new("UICorner", LogoButton).CornerRadius = UDim.new(1, 0) -- Perfect Circle
local logoStroke = Instance.new("UIStroke", LogoButton)
logoStroke.Color = Color3.fromRGB(0, 255, 127)
logoStroke.Thickness = 2

-- --- 4. TOGGLE LOGIC FUNCTION ---
local function ToggleMenu()
    if MainFrame.Visible then
        -- Action: HIDE Big Menu, SHOW Small Logo
        MainFrame.Visible = false
        LogoButton.Visible = true
        print("Menu Hidden - Logo Shown")
    else
        -- Action: SHOW Big Menu, HIDE Small Logo
        MainFrame.Visible = true
        LogoButton.Visible = false
        print("Menu Shown - Logo Hidden")
        
        -- ***CRITICAL FIX for "Idhar udhar ہو ja raha hai"***
        -- Force re-center MainFrame on reshow to fix positioning issues
        MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
    end
end

-- Connect Logo Click to Toggle
LogoButton.MouseButton1Click:Connect(ToggleMenu)

-- --- 5. FUNCTION TO CREATE TOGGLE BUTTONS ---
local function CreateToggleButton(text, varName, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    
    -- Function to update button state visuals
    local function updateVisuals()
        local isOn = _G[varName]
        btn.Text = text .. (isOn and ": ON" or ": OFF")
        btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
    end
    updateVisuals() -- Initial set

    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName] -- Toggle variable
        updateVisuals() -- Update visuals
        if callback then callback() end -- Optional callback
    end)
end

-- --- 6. HIDE MENU BUTTON CREATOR ---
local function CreateHideButton()
    local hBtn = Instance.new("TextButton", MainFrame)
    hBtn.Size = UDim2.new(0.9, 0, 0, 35)
    hBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    hBtn.Text = "HIDE MENU"
    hBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hBtn.Font = Enum.Font.GothamBold
    hBtn.TextSize = 13
    Instance.new("UICorner", hBtn)
    
    local hStroke = Instance.new("UIStroke", hBtn)
    hStroke.Color = Color3.fromRGB(255, 0, 0) -- Red outline for Hide
    hStroke.Thickness = 1.5

    hBtn.MouseButton1Click:Connect(ToggleMenu)
end

-- --- 7. CREATE MENU ELEMENTS ---
CreateToggleButton("AIMBOT", "Aimbot")
CreateToggleButton("ESP BOX (Wallhack)", "ESP")
CreateHideButton()

-- --- 8. FOV CIRCLE DRAWING ---
local fov = Drawing.new("Circle")
fov.Visible = false
fov.Thickness = 1
fov.Color = Color3.fromRGB(0, 255, 127)
fov.Transparency = 1
fov.Radius = _G.FOV
fov.Filled = false

-- --- 9. COMPLEX AIMBOT LOGIC (SMOOTH + DYNAMIC SWITCH + VISCHECK) ---
local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local rayparams = RaycastParams.new()
    rayparams.FilterType = Enum.RaycastFilterType.Exclude
    rayparams.FilterDescendantsInstances = {Players.LocalPlayer.Character, part.Parent}
    
    local res = workspace:Raycast(origin, part.Position - origin, rayparams)
    return res == nil
end

local function GetClosest()
    local closestTarget = nil
    local maxDist = _G.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character.Humanoid.Health > 0 then
            local head = player.Character.Head
            local pos, screenPos = Camera:WorldToViewportPoint(head.Position)
            
            if screenPos then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                
                -- Check dynamic SWITCHING distance AND visibility
                if dist < maxDist and IsVisible(head) then
                    maxDist = dist
                    closestTarget = player
                end
            end
        end
    end
    return closestTarget
end

-- --- 10. ESP LOGIC (WALLHACK BOX + NAME + HP) ---
local function ApplyESP(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local char = player.Character
        local hum = char.Humanoid
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- ESP Billboard Gui
        local bill = hrp:FindFirstChild("AbhishekESP") or Instance.new("BillboardGui", hrp)
        bill.Name = "AbhishekESP"
        bill.Size = UDim2.new(0, 200, 0, 50)
        bill.AlwaysOnTop = true
        bill.ExtentsOffset = Vector3.new(0, 3, 0)
        bill.Enabled = _G.ESP

        local label = bill:FindFirstChild("Label") or Instance.new("TextLabel", bill)
        label.Name = "Label"
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11

        local d = math.floor((head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude)
        l.Text = p.Name .. " | " .. hp .. "HP | " .. d .. "m"

        -- ESP Box/Highlight
        local highlight = char:FindFirstChild("ESP_Highlight") or Instance.new("Highlight", char)
        highlight.Name = "ESP_Highlight"
        highlight.FillTransparency = 1 -- Transparent fill for just outline box
        highlight.OutlineColor = Color3.fromRGB(0, 255, 127) -- Matching Green
        highlight.Adornee = char
        highlight.Enabled = _G.ESP
    end
end

-- --- 11. MAIN RENDER LOOP ---
RunService.RenderStepped:Connect(function()
    -- FOV circle update
    fov.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    fov.Visible = _G.Aimbot
    
    -- Aimbot update
    if _G.Aimbot then
        local target = GetClosest()
        if target and target.Character:FindFirstChild("Head") then
            -- Smooth dynamic lock logic fixsticky issues
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), _G.Smoothness)
        end
    end

    -- ESP update for standard Roblox structure in complex games
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            ApplyESP(player)
        end
    end
end)
