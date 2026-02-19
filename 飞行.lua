local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local Char = Player.Character or Player.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")

Player.CharacterAdded:Connect(function(c)
    Char = c
    Root = Char:WaitForChild("HumanoidRootPart")
    Hum = Char:WaitForChild("Humanoid")
end)

local Flying = false
local Speed = 60

-- GUI
local Screen = Instance.new("ScreenGui")
Screen.Name = "MobileFly"
Screen.Parent = Player.PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,190,0,110)
Main.Position = UDim2.new(0.03,0,0.25,0)
Main.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
Main.BackgroundTransparency = 0.1
Main.Active = true
Main.Draggable = true
Main.Parent = Screen

-- 标题
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,25)
Title.BackgroundTransparency = 1
Title.Text = "手机飞行"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 15
Title.Parent = Main

-- 速度显示
local SpeedText = Instance.new("TextLabel")
SpeedText.Size = UDim2.new(1,0,0,20)
SpeedText.Position = UDim2.new(0,0,0,25)
SpeedText.BackgroundTransparency = 1
SpeedText.Text = "速度: "..Speed
SpeedText.TextColor3 = Color3.new(1,1,1)
SpeedText.TextSize = 13
SpeedText.Parent = Main

-- 加减速
local Add = Instance.new("TextButton")
Add.Size = UDim2.new(0,85,0,28)
Add.Position = UDim2.new(0.03,0,0,50)
Add.BackgroundColor3 = Color3.new(0.2,0.7,0.2)
Add.Text = "+ 加速"
Add.TextColor3 = Color3.new(1,1,1)
Add.Parent = Main

local Minus = Instance.new("TextButton")
Minus.Size = UDim2.new(0,85,0,28)
Minus.Position = UDim2.new(0.52,0,0,50)
Minus.BackgroundColor3 = Color3.new(0.7,0.2,0.2)
Minus.Text = "- 减速"
Minus.TextColor3 = Color3.new(1,1,1)
Minus.Parent = Main

-- 开关
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0,175,0,28)
Toggle.Position = UDim2.new(0.04,0,0,82)
Toggle.BackgroundColor3 = Color3.new(0.2,0.3,0.7)
Toggle.Text = "飞行开关"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Parent = Main

-- 关闭
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,175,0,25)
Close.Position = UDim2.new(0.04,0,0,115)
Close.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
Close.Text = "关闭界面"
Close.TextColor3 = Color3.new(1,1,1)
Close.Parent = Main

-- 逻辑
Toggle.MouseButton1Click:Connect(function()
    Flying = not Flying
    Hum.PlatformStand = Flying
end)

Add.MouseButton1Click:Connect(function()
    Speed += 10
    SpeedText.Text = "速度: "..Speed
end)

Minus.MouseButton1Click:Connect(function()
    Speed = math.max(30, Speed - 10)
    SpeedText.Text = "速度: "..Speed
end)

Close.MouseButton1Click:Connect(function()
    Flying = false
    Hum.PlatformStand = false
    Screen:Destroy()
end)

-- 飞行
RS.RenderStepped:Connect(function()
    if not Flying or not Root then return end
    local Dir = Vector3.new()
    if UIS:IsKeyDown(Enum.KeyCode.W) then Dir += Mouse.UnitRay.Direction end
    if UIS:IsKeyDown(Enum.KeyCode.S) then Dir -= Mouse.UnitRay.Direction end
    if UIS:IsKeyDown(Enum.KeyCode.A) then Dir -= Root.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then Dir += Root.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then Dir += Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then Dir -= Vector3.new(0,1,0) end
    if Dir.Magnitude > 0 then Dir = Dir.Unit end
    Root.Velocity = Dir * Speed
    Root.CFrame = CFrame.new(Root.Position, Root.Position + Mouse.UnitRay.Direction)
end)
