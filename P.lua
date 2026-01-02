local function createUI()
    local window = Instance.new("ScreenGui")
    window.Name = "ExploitHub"
    window.Parent = game.CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 200, 0, 250)
    mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = window

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Text = "Fish It Exploit Hub"
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextScaled = true
    titleLabel.Parent = mainFrame

    local autoFishButton = Instance.new("TextButton")
    autoFishButton.Size = UDim2.new(1, -10, 0, 30)
    autoFishButton.Position = UDim2.new(0, 5, 0, 40)
    autoFishButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    autoFishButton.TextColor3 = Color3.new(1, 1, 1)
    autoFishButton.Text = "Enable Auto Fish"
    autoFishButton.Font = Enum.Font.SourceSansBold
    autoFishButton.Parent = mainFrame
    autoFishButton.MouseButton1Click:Connect(function() enableAutoFishing() end)

    local chargeRodButton = Instance.new("TextButton")
    chargeRodButton.Size = UDim2.new(1, -10, 0, 30)
    chargeRodButton.Position = UDim2.new(0, 5, 0, 80)
    chargeRodButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    chargeRodButton.TextColor3 = Color3.new(1, 1, 1)
    chargeRodButton.Text = "Charge Rod"
    chargeRodButton.Font = Enum.Font.SourceSansBold
    chargeRodButton.Parent = mainFrame
    chargeRodButton.MouseButton1Click:Connect(function() chargeFishingRod() end)

    local requestMinigameButton = Instance.new("TextButton")
    requestMinigameButton.Size = UDim2.new(1, -10, 0, 30)
    requestMinigameButton.Position = UDim2.new(0, 5, 0, 120)
    requestMinigameButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    requestMinigameButton.TextColor3 = Color3.new(1, 1, 1)
    requestMinigameButton.Text = "Request Minigame"
    requestMinigameButton.Font = Enum.Font.SourceSansBold
    requestMinigameButton.Parent = mainFrame
    requestMinigameButton.MouseButton1Click:Connect(function() requestFishingMinigame() end)

    local completeFishingButton = Instance.new("TextButton")
    completeFishingButton.Size = UDim2.new(1, -10, 0, 30)
    completeFishingButton.Position = UDim2.new(0, 5, 0, 160)
    completeFishingButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    completeFishingButton.TextColor3 = Color3.new(1, 1, 1)
    completeFishingButton.Text = "Complete Fishing"
    completeFishingButton.Font = Enum.Font.SourceSansBold
    completeFishingButton.Parent = mainFrame
    completeFishingButton.MouseButton1Click:Connect(function() completeFishing() end)

    local speedUpButton = Instance.new("TextButton")
    speedUpButton.Size = UDim2.new(1, -10, 0, 30)
    speedUpButton.Position = UDim2.new(0, 5, 0, 200)
    speedUpButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    speedUpButton.TextColor3 = Color3.new(1, 1, 1)
    speedUpButton.Text = "Speed Up"
    speedUpButton.Font = Enum.Font.SourceSansBold
    speedUpButton.Parent = mainFrame
    speedUpButton.MouseButton1Click:Connect(function() speedUpFishing() end)

    return window
end

-- Blatant Exploit Section (Extremely Risky)
-- These functions directly call remote events, potentially triggering anti-cheat systems.
-- Use with extreme caution.

local Packages = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net
local speedMultiplier = 0.01 -- Adjust this value to control speed (e.g., 0.01 is 100x faster, but risky).

local function enableAutoFishing()
    local Event = Packages["RF/UpdateAutoFishingState"]
    if Event then
        pcall(function() Event:InvokeServer(true) end)
        print("Attempted to enable auto-fishing.")
    else
        warn("RF/UpdateAutoFishingState event not found.")
    end
end

local function chargeFishingRod()
    local Event = Packages["RF/ChargeFishingRod"]
    if Event then
        pcall(function()
            Event:InvokeServer(nil, nil, nil, 1767344122.389)
        end)
        print("Attempted to charge fishing rod.")
    else
        warn("RF/ChargeFishingRod event not found.")
    end
end

local function requestFishingMinigame()
    local Event = Packages["RF/RequestFishingMinigameStarted"]
    if Event then
        pcall(function()
            Event:InvokeServer(-139.6379699707, 0.5, 1767344122.5671)
        end)
        print("Attempted to request fishing minigame.")
    else
        warn("RF/RequestFishingMinigameStarted event not found.")
    end
end

--This will not work unless you find a timer server sided.
local function completeFishing()
    local Event = Packages["RE/FishingCompleted"]
    if Event then
        pcall(function() Event:FireServer() end)
        print("Attempted to complete fishing.")
    else
        warn("RE/FishingCompleted event not found.")
    end
end

-- Function to speed up the fishing process (VERY difficult and likely to be detected)
-- THIS PART REQUIRES IN-DEPTH KNOWLEDGE OF THE GAME'S FISHING MECHANICS.
-- You would need to identify the loops or timers controlling the fishing duration.
-- Client-side changes will likely be ignored by the server.
local function speedUpFishing()
    --Attempt to speed up the game
    game:GetService("RunService").Heartbeat:Connect(function()
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 16 * 2--Double Walk Speed

        game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 50 * 2 -- Double Jump Power
        game:GetService("Players").LocalPlayer.Character.Animate.Disabled = true--Remove Animation
        --Increase Frame Rate
        game:GetService("RenderStepped"):SetPriority(Enum.RenderPriority.First.Value)

        game:GetService("RunService").RenderStepped:Wait(speedMultiplier)-- Speed up the fishing duration (This might not be possible)

    end)

end

--Dupe System (If the game has a dupe)
--get Local Player
local player = game.Players.LocalPlayer

-- Function to find a fishing rod (assumes the player has one)
local function getFishingRod()
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name, "Rod", 1, true) then
            return tool
        end
    end
    return nil
end

-- Function to drop an item (fish) given its name and quantity
local function dropItem(itemName, quantity)
    local dropEvent = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("DropItem") --Example Path, change to the proper one

    if dropEvent then
        for i = 1, quantity do
            pcall(function()
                dropEvent:FireServer(itemName)
                -- Wrap with pcall to prevent errors from stopping the loop if one fire fails
            end)
        end
        print("Attempted to drop " .. quantity .. " " .. itemName .. "(s)")
    else
        warn("Drop item event not found.  Duplication will likely fail.")
    end
end

-- Duplication function
local function dupeFish(fishName, amountToDupe)

    local rod = getFishingRod()
    if not rod then
        warn("No fishing rod found.  Equip a fishing rod first.")
        return
    end
   --check if item can be dropped.
    dropItem(fishName, amountToDupe)
end
