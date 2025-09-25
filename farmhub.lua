-- EuroFarm Hub Script (TP + Yukarı-Aşağı)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local farmActive = false
local farmFolder = nil

-- Helper Functions
local function getTargetParts(folder)
    local parts = {}
    if folder then
        for _, obj in pairs(folder:GetChildren()) do
            if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.CanCollide then
                table.insert(parts, obj)
            end
        end
    end
    return parts
end

local function teleportToPart(part)
    if part then
        local hrp = humanoidRootPart
        -- Direkt TP
        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0,3,0))
        
        -- Yukarı-Aşağı hareket 2 saniye
        local duration = 2
        local steps = 40
        for i = 1, steps do
            local alpha = i / steps
            local yOffset = math.sin(alpha * math.pi * 2) * 2 -- 2 stud yukarı-aşağı
            hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3 + yOffset, 0))
            task.wait(duration / steps)
        end
    end
end

local function startFarmLoop()
    spawn(function()
        while farmActive do
            local targets = getTargetParts(farmFolder)
            if #targets > 0 then
                for _, targetPart in pairs(targets) do
                    if not farmActive then break end
                    teleportToPart(targetPart)
                end
            end
            task.wait(0.1)
        end
    end)
end

local function stopFarmLoop()
    farmActive = false
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EuroFarmHub"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "EuroFarm"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.FredokaOne
closeButton.TextSize = 18
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    farmActive = false
end)

local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0, 150, 0, 50)
startButton.Position = UDim2.new(0.5, -75, 0, 80)
startButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
startButton.Text = "Start Farming"
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.Font = Enum.Font.FredokaOne
startButton.TextSize = 18
startButton.Parent = mainFrame

startButton.MouseButton1Click:Connect(function()
    if farmActive then
        stopFarmLoop()
        startButton.Text = "Start Farming"
    else
        farmActive = true
        startButton.Text = "Stop Farming"
        startFarmLoop()
    end
end)

-- Initialize Farm Folder
for _, obj in pairs(workspace:GetChildren()) do
    if obj:IsA("Folder") and obj:FindFirstChild("ParkourMoney") then
        farmFolder = obj
        break
    end
end
