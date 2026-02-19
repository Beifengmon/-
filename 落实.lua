local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local H = character:WaitForChild("Humanoid")
local R = character:WaitForChild("HumanoidRootPart")

-- 你的变量
local s = 16
local j = 7.2
local w = false
local a = false

local currentAirPart = Instance.new("Part")
currentAirPart.Name = "AirBlock"
currentAirPart.Size = Vector3.new(6, 0.3, 6)
currentAirPart.Transparency = 1
currentAirPart.Anchored = true
currentAirPart.CanCollide = true
currentAirPart.Parent = workspace

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlUI"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 330)
mainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 80, 255))
})
gradient.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local function createButton(text, pos, size)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    btn.Parent = mainFrame
    return btn
end

-- 状态显示
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(0, 200, 0, 30)
StatsLabel.Position = UDim2.new(0, 10, 0, 10)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Color3.new(1,1,1)
StatsLabel.Text = "速度:"..s.."  跳跃:"..j
StatsLabel.TextSize = 16
StatsLabel.Parent = mainFrame

-- 按钮
local S1 = createButton("+速度", UDim2.new(0, 10, 0, 50), UDim2.new(0, 80, 0, 35))
local S2 = createButton("-速度", UDim2.new(0, 120, 0, 50), UDim2.new(0, 80, 0, 35))
local J1 = createButton("+跳跃", UDim2.new(0, 10, 0, 100), UDim2.new(0, 80, 0, 35))
local J2 = createButton("-跳跃", UDim2.new(0, 120, 0, 100), UDim2.new(0, 80, 0, 35))
local W = createButton("穿墙:关", UDim2.new(0, 10, 0, 150), UDim2.new(0, 200, 0, 35))
local A = createButton("踏空:关", UDim2.new(0, 10, 0, 195), UDim2.new(0, 200, 0, 35))
local DestroyBtn = createButton("摧毁脚本", UDim2.new(0, 10, 0, 240), UDim2.new(0, 95, 0, 25))
local ResetBtn = createButton("恢复原数据", UDim2.new(0, 115, 0, 240), UDim2.new(0, 95, 0, 25))

-- 拖动
local isDragging = false
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- ======================
-- 你要的 速度/跳跃/穿墙/踏空 原版逻辑
-- ======================

-- 速度控制
S1.MouseButton1Click:Connect(function()
    s = s + 5
    H.WalkSpeed = s
    StatsLabel.Text = "速度:"..s.."  跳跃:"..j
end)
S2.MouseButton1Click:Connect(function()
    s = math.max(16, s - 5)
    H.WalkSpeed = s
    StatsLabel.Text = "速度:"..s.."  跳跃:"..j
end)

-- 跳跃控制
J1.MouseButton1Click:Connect(function()
    j = j + 1
    H.JumpHeight = j
    StatsLabel.Text = "速度:"..s.."  跳跃:"..j
end)
J2.MouseButton1Click:Connect(function()
    j = math.max(5, j - 1)
    H.JumpHeight = j
    StatsLabel.Text = "速度:"..s.."  跳跃:"..j
end)

-- 穿墙功能
W.MouseButton1Click:Connect(function()
    w = not w
    W.Text = "穿墙:"..(w and "开" or "关")
end)

-- 踏空功能
A.MouseButton1Click:Connect(function()
    a = not a
    A.Text = "踏空:"..(a and "开" or "关")
    currentAirPart.Position = a and (R.Position - Vector3.new(0, R.Size.Y/2 + 2.95, 0)) or Vector3.new(0, -1000, 0)
end)

-- 穿墙实时
RunService.Heartbeat:Connect(function()
    for _, p in pairs(character:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = not w
        end
    end
end)

-- 踏空实时
RunService.Heartbeat:Connect(function()
    if a then
        currentAirPart.Position = R.Position - Vector3.new(0, R.Size.Y/2 + 2.95, 0)
        H:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    else
        currentAirPart.Position = Vector3.new(0, -1000, 0)
        H:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    end
end)

-- 跳跃状态优化
H.StateChanged:Connect(function(oldState, newState)
    if a and newState == Enum.HumanoidStateType.Jumping then
        currentAirPart.Position = R.Position + Vector3.new(0, H.JumpHeight/2, 0) - Vector3.new(0, R.Size.Y/2 + 3, 0)
    elseif a and newState == Enum.HumanoidStateType.Landed then
        currentAirPart.Position = R.Position - Vector3.new(0, R.Size.Y/2 + 2.95, 0)
    end
end)

-- 恢复
ResetBtn.MouseButton1Click:Connect(function()
    s = 16
    j = 7.2
    H.WalkSpeed = s
    H.JumpHeight = j
    StatsLabel.Text = "速度:"..s.."  跳跃:"..j
end)

-- 销毁
DestroyBtn.MouseButton1Click:Connect(function()
    currentAirPart:Destroy()
    screenGui:Destroy()
    script:Destroy()
end)
