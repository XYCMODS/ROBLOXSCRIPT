-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- SETTINGS
_G.Aimbot=false
_G.ESP_Box=false
_G.ESP_Name=false
_G.ESP_Health=false
_G.FOV=150

-- GUI
local ScreenGui = Instance.new("ScreenGui",CoreGui)

-- MAIN MENU
local Main = Instance.new("Frame",ScreenGui)
Main.Size=UDim2.new(0,300,0,380)
Main.Position=UDim2.new(0.03,0,0.2,0)
Main.BackgroundColor3=Color3.fromRGB(15,15,15)
Main.Active=true
Main.Draggable=true
Instance.new("UICorner",Main)

local Stroke=Instance.new("UIStroke",Main)
Stroke.Color=Color3.fromRGB(0,255,120)

-- LOGO BUTTON
local Logo = Instance.new("TextButton",ScreenGui)
Logo.Size=UDim2.new(0,55,0,55)
Logo.Position=UDim2.new(0.02,0,0.2,0)
Logo.Text="AB"
Logo.Visible=false
Logo.BackgroundColor3=Color3.fromRGB(15,15,15)
Logo.TextColor3=Color3.fromRGB(0,255,120)
Logo.Font=Enum.Font.GothamBold
Logo.TextSize=20
Logo.Draggable=true
Instance.new("UICorner",Logo)
Instance.new("UIStroke",Logo).Color=Color3.fromRGB(0,255,120)

-- CLOSE BUTTON
local Close = Instance.new("TextButton",Main)
Close.Size=UDim2.new(0,35,0,35)
Close.Position=UDim2.new(1,-40,0,5)
Close.Text="X"
Close.BackgroundTransparency=1
Close.TextColor3=Color3.new(1,1,1)
Close.Font=Enum.Font.GothamBold
Close.TextSize=18

Close.MouseButton1Click:Connect(function()
    Main.Visible=false
    Logo.Visible=true
end)

Logo.MouseButton1Click:Connect(function()
    Main.Visible=true
    Logo.Visible=false
end)

-- TABS
local TabHolder=Instance.new("Frame",Main)
TabHolder.Size=UDim2.new(1,0,0,40)
TabHolder.Position=UDim2.new(0,0,0,40)
TabHolder.BackgroundTransparency=1

local TabLayout=Instance.new("UIListLayout",TabHolder)
TabLayout.FillDirection=Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
TabLayout.Padding=UDim.new(0,6)

local AimPage=Instance.new("Frame",Main)
AimPage.Size=UDim2.new(1,0,1,-90)
AimPage.Position=UDim2.new(0,0,0,90)
AimPage.BackgroundTransparency=1

local EspPage=AimPage:Clone()
EspPage.Parent=Main
EspPage.Visible=false

local Layout1=Instance.new("UIListLayout",AimPage)
Layout1.Padding=UDim.new(0,8)
Layout1.HorizontalAlignment=Enum.HorizontalAlignment.Center

local Layout2=Layout1:Clone()
Layout2.Parent=EspPage

local function Tab(name,page)
    local b=Instance.new("TextButton",TabHolder)
    b.Size=UDim2.new(0,90,0,30)
    b.Text=name
    b.BackgroundColor3=Color3.fromRGB(25,25,25)
    b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.GothamBold
    b.TextSize=13
    Instance.new("UICorner",b)

    b.MouseButton1Click:Connect(function()
        AimPage.Visible=false
        EspPage.Visible=false
        page.Visible=true
    end)
end

Tab("AIM",AimPage)
Tab("ESP",EspPage)

-- TOGGLE
local function Toggle(text,parent,callback)
    local btn=Instance.new("TextButton",parent)
    btn.Size=UDim2.new(0.9,0,0,40)
    btn.BackgroundColor3=Color3.fromRGB(30,30,30)
    btn.Text=text.." : OFF"
    btn.TextColor3=Color3.new(1,1,1)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=14
    Instance.new("UICorner",btn)

    local state=false
    btn.MouseButton1Click:Connect(function()
        state=not state
        callback(state)
        btn.Text=text.." : "..(state and "ON" or "OFF")
        btn.BackgroundColor3=state and Color3.fromRGB(0,170,100) or Color3.fromRGB(30,30,30)
    end)
end

Toggle("Aimbot",AimPage,function(v) _G.Aimbot=v end)
Toggle("ESP Box",EspPage,function(v) _G.ESP_Box=v end)
Toggle("ESP Name",EspPage,function(v) _G.ESP_Name=v end)
Toggle("ESP Health",EspPage,function(v) _G.ESP_Health=v end)

-- ESP SYSTEM
RunService.RenderStepped:Connect(function()

    for _,p in pairs(Players:GetPlayers()) do
        if p~=Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then

            local h=p.Character:FindFirstChild("ABHIGHLIGHT")
            if not h then
                h=Instance.new("Highlight",p.Character)
                h.Name="ABHIGHLIGHT"
            end

            h.Enabled=_G.ESP_Box
            h.FillColor=Color3.fromRGB(0,255,120)

            local head=p.Character:FindFirstChild("Head")
            if head then

                local gui=head:FindFirstChild("ABGUI")
                if not gui then
                    gui=Instance.new("BillboardGui",head)
                    gui.Name="ABGUI"
                    gui.Size=UDim2.new(0,100,0,40)
                    gui.AlwaysOnTop=true
                    gui.ExtentsOffset=Vector3.new(0,2,0)

                    local txt=Instance.new("TextLabel",gui)
                    txt.Name="TXT"
                    txt.Size=UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency=1
                    txt.TextColor3=Color3.new(1,1,1)
                    txt.Font=Enum.Font.GothamBold
                    txt.TextSize=10
                end

                local label=gui.TXT
                local text=""

                if _G.ESP_Name then
                    text=text..p.Name.."\n"
                end

                if _G.ESP_Health then
                    local hum=p.Character:FindFirstChild("Humanoid")
                    if hum then
                        text=text..math.floor(hum.Health).." HP"
                    end
                end

                label.Text=text
                label.Visible=_G.ESP_Name or _G.ESP_Health

            end
        end
    end

end)
