

-- UI Creation using a Delta Executor-friendly method
local function createUI()
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI-Library/main/source.lua"))()

    local window = library.new("Fish It Exploit Hub", "Dark")

    local tab = window:addTab("Main")
    local section = tab:addSection("Fishing Exploits")

    section:addButton("Enable Auto Fish", function() enableAutoFishing() end)
    section:addButton("Charge Rod", function() chargeFishingRod() end)
    section:addButton("Request Minigame", function() requestFishingMinigame() end)
    section:addButton("Complete Fishing", function() completeFishing() end)
    section:addButton("Speed Up", function() speedUpFishing() end)

	local tab2 = window:addTab("Dupe")
    local section2 = tab2:addSection("Dupe System")
	section2:addButton("Dupe Fish", function() dupeFish("Secret Bloodmoon Whale", 5) end)

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

        --game:GetService("RunService").RenderStepped:Wait(speedMultiplier)-- Speed up the fishing duration (This might not be possible)

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
    -- Replace "YourRemoteEventPathHere" with the ACTUAL path to the remote event used for dropping items
    -- **IMPORTANT:**  You *must* find the correct remote event for dropping items.  This is the most likely point of failure.
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

-- Example usage:  Duplicate "Secret Bloodmoon Whale" 5 times.
-- You MUST have at least one "Secret Bloodmoon Whale" in your inventory for this to work,
-- and the fish name MUST match EXACTLY as it is in the game.

-- Start the UI
local exploitUI = createUI()    speedUpButton.TextColor3 = Color3.new(1, 1, 1)
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
