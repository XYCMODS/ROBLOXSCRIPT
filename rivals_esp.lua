-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- GUI
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "GodUIFramework"

-- MAIN
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,420,0,420)
Main.Position = UDim2.new(0.3,0,0.2,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0,255,170)

-- HEADER
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1,0,0,50)
Header.Text = "GOD UI PANEL"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 22
Header.TextColor3 = Color3.fromRGB(0,255,170)
Header.BackgroundTransparency = 1

-- HOTKEY
UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- TAB HOLDER
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(1,0,0,40)
Tabs.Position = UDim2.new(0,0,0,50)
Tabs.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", Tabs)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Padding = UDim.new(0,8)

-- PAGE HOLDER
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1,0,1,-90)
Pages.Position = UDim2.new(0,0,0,90)
Pages.BackgroundTransparency = 1

-- TAB SYSTEM
local PageList = {}

local function CreateTab(name)
    local Page = Instance.new("Frame", Pages)
    Page.Size = UDim2.new(1,0,1,0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0,8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Btn = Instance.new("TextButton", Tabs)
    Btn.Size = UDim2.new(0,110,0,30)
    Btn.Text = name
    Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _,p in pairs(PageList) do
            p.Visible = false
        end
        Page.Visible = true
    end)

    table.insert(PageList, Page)
    return Page
end

-- CONTROLS
local function Toggle(parent,text,callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(0.9,0,0,40)
    Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Btn.Text = text.." : OFF"
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn)

    local state=false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text.." : "..(state and "ON" or "OFF")
        Btn.BackgroundColor3 = state and Color3.fromRGB(0,170,120) or Color3.fromRGB(35,35,35)
        callback(state)
    end)
end

local function Slider(parent,text,min,max,callback)
    local Holder = Instance.new("Frame", parent)
    Holder.Size = UDim2.new(0.9,0,0,50)
    Holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", Holder)

    local Label = Instance.new("TextLabel", Holder)
    Label.Size = UDim2.new(1,0,0.5,0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.GothamBold
    Label.Text = text.." : "..min

    local Bar = Instance.new("Frame", Holder)
    Bar.Size = UDim2.new(0.9,0,0,6)
    Bar.Position = UDim2.new(0.05,0,0.65,0)
    Bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Instance.new("UICorner", Bar)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new(0,0,1,0)
    Fill.BackgroundColor3 = Color3.fromRGB(0,255,170)
    Instance.new("UICorner", Fill)

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local move
            move = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
                    Fill.Size = UDim2.new(pos,0,1,0)
                    local val = math.floor(min + (max-min)*pos)
                    Label.Text = text.." : "..val
                    callback(val)
                end
            end)
            UIS.InputEnded:Wait()
            move:Disconnect()
        end
    end)
end

local function Dropdown(parent,text,options,callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(0.9,0,0,40)
    Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        local choice = options[math.random(1,#options)]
        Btn.Text = text.." : "..choice
        callback(choice)
    end)
end

-- NOTIFICATION
local function Notify(msg)
    local N = Instance.new("TextLabel", Gui)
    N.Size = UDim2.new(0,260,0,50)
    N.Position = UDim2.new(0.5,-130,0.1,0)
    N.BackgroundColor3 = Color3.fromRGB(20,20,20)
    N.TextColor3 = Color3.fromRGB(0,255,170)
    N.Font = Enum.Font.GothamBold
    N.TextSize = 16
    N.Text = msg
    Instance.new("UICorner", N)

    TweenService:Create(N,TweenInfo.new(0.4),{Position=UDim2.new(0.5,-130,0.15,0)}):Play()
    task.wait(2)
    N:Destroy()
end

-- PAGES CREATE
local Settings = CreateTab("SETTINGS")
local Player = CreateTab("PLAYER")
local Visual = CreateTab("VISUAL")

Settings.Visible = true

-- EXAMPLE CONTROLS
Toggle(Settings,"Music",function(v) Notify("Music "..tostring(v)) end)
Slider(Settings,"Volume",0,100,function(v) end)
Dropdown(Settings,"Graphics",{"Low","Medium","High"},function(v) end)

Toggle(Player,"Sprint",function(v) end)
Slider(Player,"WalkSpeed",16,100,function(v)
    local char = Players.LocalPlayer.Character
    if char then
        char.Humanoid.WalkSpeed = v
    end
end)

Toggle(Visual,"Show Names",function(v) end)

-- RESIZE CORNER
local Resize = Instance.new("Frame", Main)
Resize.Size = UDim2.new(0,20,0,20)
Resize.Position = UDim2.new(1,-20,1,-20)
Resize.BackgroundColor3 = Color3.fromRGB(0,255,170)

Resize.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local move
        move = UIS.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement then
                Main.Size = UDim2.new(0,inp.Position.X-Main.AbsolutePosition.X,
                                      0,inp.Position.Y-Main.AbsolutePosition.Y)
            end
        end)
        UIS.InputEnded:Wait()
        move:Disconnect()
    end
end)
