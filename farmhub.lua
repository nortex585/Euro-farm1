-- LocalScript StarterGui içine
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EuroFarmGui"
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,300,0,150)
mainFrame.Position = UDim2.new(0.5,-150,0.5,-75)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- UICorner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,8)
corner.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,30)
topBar.Position = UDim2.new(0,0,0,0)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,30,0,30)
closeButton.Position = UDim2.new(1,-30,0,0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.Font = Enum.Font.FredokaOne
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
closeButton.TextScaled = true
closeButton.Parent = topBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "EuroFarm"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Parent = mainFrame

-- Toggle Button (şartel gibi)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0,150,0,50)
toggleButton.Position = UDim2.new(0.5,-75,0,80)
toggleButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
toggleButton.Font = Enum.Font.FredokaOne
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.TextScaled = true
toggleButton.Text = "Start EuroFarm"
toggleButton.Parent = mainFrame

local euroFarmActive = false

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

local function euroFarmLoop()
    spawn(function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local euroFolder
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Folder") and obj:FindFirstChild("ParkourMoney") then
                euroFolder = obj
                break
            end
        end
        local currentIndex = 1
        while euroFarmActive do
            local targets = getTargetParts(euroFolder)
            if #targets > 0 then
                local targetPart = targets[currentIndex]
                if targetPart then
                    local tween = TweenService:Create(
                        hrp,
                        TweenInfo.new(3, Enum.EasingStyle.Linear),
                        {CFrame = targetPart.CFrame + Vector3.new(0,3,0)}
                    )
                    tween:Play()
                    tween.Completed:Wait()
                end
                currentIndex += 1
                if currentIndex > #targets then currentIndex = 1 end
            end
            task.wait(0.1)
        end
    end)
end

toggleButton.MouseButton1Click:Connect(function()
    euroFarmActive = not euroFarmActive
    if euroFarmActive then
        toggleButton.Text = "Stop EuroFarm"
        euroFarmLoop()
    else
        toggleButton.Text = "Start EuroFarm"
    end
end)
