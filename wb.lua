-- Fish It Realtime Webhook Notifier
-- Monitoring Comprehensive: Inventory, Catch, Stats, Chat, Game State
-- Untuk executor Roblox

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ====================== KONFIGURASI ======================
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1445802725345591336/Yip4UlonP4rr_h2Nev3jwIradeK7UWdQ1xh3x7BNkJNe4kPv2NyRMHxj5RsUTwM3r-YF" -- GANTI INI!
local UPDATE_INTERVAL = 5 -- Detik antara update
local ENABLE_INVENTORY_SCAN = true
local ENABLE_CHAT_MONITOR = true
local ENABLE_STATS_MONITOR = true
local ENABLE_GAME_EVENTS = true
local ENABLE_REMOTE_SPY = true
local ENABLE_FISHING_ACTIVITY = true
local DEBUG_MODE = false
-- ========================================================

-- Data storage
local lastInventory = {}
local lastStats = {}
local lastFishCount = 0
local totalFishCaught = 0
local fishingSessions = {}
local sessionStartTime = os.time()
local remoteLogs = {}
local fishHistory = {}

-- Cache untuk performance
local cache = {
    playerData = {},
    gameData = {},
    lastUpdate = 0
}

-- Function untuk mengirim webhook
local function sendWebhook(embedData, isPriority)
    if not DISCORD_WEBHOOK or DISCORD_WEBHOOK == "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE" then
        warn("⚠️ Webhook URL belum dikonfigurasi!")
        return false
    end
    
    local data = {
        username = "🎣 Fish It Monitor",
        avatar_url = "https://cdn.discordapp.com/emojis/1278617752644284416.webp",
        embeds = {embedData}
    }
    
    local success, response = pcall(function()
        local json = HttpService:JSONEncode(data)
        
        local req = request or http_request or syn.request
        if req then
            local result = req({
                Url = DISCORD_WEBHOOK,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = json
            })
            return result
        else
            -- Fallback menggunakan game.HttpService
            return game:GetService("HttpService"):PostAsync(DISCORD_WEBHOOK, json)
        end
    end)
    
    if success then
        if DEBUG_MODE then
            print("✅ Webhook terkirim:", embedData.title)
        end
        return true
    else
        warn("❌ Webhook gagal:", response)
        return false
    end
end

-- Function untuk scan inventory player
local function scanInventory()
    if not ENABLE_INVENTORY_SCAN then return {} end
    
    local inventory = {
        fish = {},
        items = {},
        tools = {},
        totalValue = 0,
        uniqueFish = 0
    }
    
    pcall(function()
        -- Cari Backpack
        local backpack = player:FindFirstChild("Backpack")
        if not backpack then return end
        
        -- Scan semua tool di backpack
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local toolData = {
                    Name = tool.Name,
                    Class = "Tool",
                    Value = 0
                }
                
                -- Cari value atau attributes
                if tool:FindFirstChild("Value") then
                    toolData.Value = tool.Value.Value
                    inventory.totalValue += toolData.Value
                end
                
                -- Cek jika ini fishing rod
                if tool.Name:lower():find("fish") or tool.Name:lower():find("rod") then
                    table.insert(inventory.tools, toolData)
                end
            end
        end
        
        -- Cari folder inventory di ReplicatedStorage atau PlayerGui
        local function searchInventoryFolders()
            local locations = {
                player:FindFirstChild("PlayerGui"),
                ReplicatedStorage,
                workspace
            }
            
            for _, location in ipairs(locations) do
                if location then
                    local invFolder = location:FindFirstChild(player.Name .. "_Inventory")
                    or location:FindFirstChild("Inventory")
                    or location:FindFirstChild("FishInventory")
                    
                    if invFolder then
                        for _, item in ipairs(invFolder:GetChildren()) do
                            if item:IsA("Folder") or item:IsA("Model") then
                                local itemData = {
                                    Name = item.Name,
                                    Class = item.ClassName,
                                    Quantity = 1
                                }
                                
                                -- Cari quantity
                                local qty = item:FindFirstChild("Quantity") 
                                or item:FindFirstChild("Amount") 
                                or item:FindFirstChild("Count")
                                
                                if qty then
                                    itemData.Quantity = qty.Value
                                end
                                
                                -- Cari value
                                local value = item:FindFirstChild("Value") 
                                or item:FindFirstChild("Price") 
                                or item:FindFirstChild("Worth")
                                
                                if value then
                                    itemData.Value = value.Value
                                    inventory.totalValue += (itemData.Value * itemData.Quantity)
                                end
                                
                                -- Kategorikan sebagai fish
                                if item.Name:lower():find("fish") or item:FindFirstChild("Rarity") then
                                    local fishData = itemData
                                    fishData.Rarity = "COMMON"
                                    
                                    local rarity = item:FindFirstChild("Rarity") 
                                    or item:FindFirstChild("RarityLevel")
                                    
                                    if rarity then
                                        fishData.Rarity = rarity.Value
                                    end
                                    
                                    table.insert(inventory.fish, fishData)
                                    inventory.uniqueFish += 1
                                else
                                    table.insert(inventory.items, itemData)
                                end
                            end
                        end
                    end
                end
            end
        end
        
        searchInventoryFolders()
        
        -- Cari DataStoreService (advanced)
        pcall(function()
            local DataStoreService = game:GetService("DataStoreService")
            -- Hanya bisa diakses oleh game server, tapi kita coba
        end)
    end)
    
    return inventory
end

-- Function untuk scan leaderstats
local function scanStats()
    local stats = {
        money = 0,
        level = 1,
        experience = 0,
        fishCaught = 0,
        biggestFish = 0,
        playTime = 0
    }
    
    pcall(function()
        local leaderstats = player:FindFirstChild("leaderstats")
        if not leaderstats then
            -- Coba cari di folder lain
            leaderstats = player:FindFirstChild("Stats") 
            or player:FindFirstChild("PlayerStats")
            or workspace:FindFirstChild(player.Name .. "_Stats")
        end
        
        if leaderstats then
            for _, stat in ipairs(leaderstats:GetChildren()) do
                if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                    local statName = stat.Name:lower()
                    local value = stat.Value
                    
                    if statName:find("money") or statName:find("cash") or statName:find("coins") then
                        stats.money = value
                    elseif statName:find("level") then
                        stats.level = value
                    elseif statName:find("exp") or statName:find("experience") then
                        stats.experience = value
                    elseif statName:find("fish") and (statName:find("caught") or statName:find("count")) then
                        stats.fishCaught = value
                    elseif statName:find("big") and statName:find("fish") then
                        stats.biggestFish = value
                    elseif statName:find("time") or statName:find("play") then
                        stats.playTime = value
                    end
                end
            end
        end
    end)
    
    return stats
end

-- Function untuk monitor chat messages
local function setupChatMonitor()
    if not ENABLE_CHAT_MONITOR then return end
    
    local function processChatMessage(message, speaker)
        if not speaker or speaker ~= player.Name then return end
        
        -- Deteksi pola tangkapan ikan
        local patterns = {
            -- Pattern: "Caught [Fish Name]! Weight: X kg"
            {pattern = "Caught%s+(.+)!%s+Weight:%s+(%d+%.%d+)%s*kg", type = "catch"},
            
            -- Pattern: "[Fish Name] - X kg - Rarity: Y"
            {pattern = "(.+)%s+%-%s+(%d+%.%d+)kg%s+%-%s+Rarity:%s+(%w+)", type = "catch"},
            
            -- Pattern: "New record! X kg [Fish Name]"
            {pattern = "New%s+record!%s+(%d+%.%d+)kg%s+(.+)", type = "record"},
            
            -- Pattern: "Sold [Fish Name] for $X"
            {pattern = "Sold%s+(.+)%s+for%s+%$(%d+,?%d*)", type = "sold"},
            
            -- Pattern: "You caught a [Rarity] [Fish Name]!"
            {pattern = "You%s+caught%s+a%s+(%w+)%s+(.+)!", type = "catch"},
            
            -- Pattern Chinese/Indonesian: "Menangkap [Ikan] - X kg"
            {pattern = "Menangkap%s+(.+)%s+%-%s+(%d+%.%d+)kg", type = "catch"}
        }
        
        for _, pattern in ipairs(patterns) do
            local fishName, weight, rarity = message:match(pattern.pattern)
            
            if fishName then
                totalFishCaught += 1
                
                local fishData = {
                    name = fishName,
                    weight = weight or "0",
                    rarity = rarity or "COMMON",
                    time = os.time(),
                    type = pattern.type
                }
                
                table.insert(fishHistory, fishData)
                
                -- Kirim notifikasi Discord
                local embed = {
                    title = "🎣 FISH CAUGHT!",
                    description = "**" .. player.Name .. "** caught a fish!",
                    color = 0x00FF00,
                    fields = {
                        {name = "🐟 Fish", value = "```" .. fishName .. "```", inline = true},
                        {name = "⚖️ Weight", value = "```" .. (weight or "?") .. " kg```", inline = true},
                        {name = "🌟 Rarity", value = "```" .. (rarity or "COMMON") .. "```", inline = true}
                    },
                    footer = {text = "Total caught: " .. totalFishCaught .. " • " .. os.date("%H:%M:%S")},
                    timestamp = DateTime.now():ToIsoDate()
                }
                
                sendWebhook(embed, true)
                
                if DEBUG_MODE then
                    print("🎣 Fish caught detected:", fishName, weight, rarity)
                end
                break
            end
        end
    end
    
    -- Setup chat listener
    spawn(function()
        repeat wait(2) 
            if not game:GetService("CoreGui") then break end
        until game:GetService("CoreGui"):FindFirstChild("RobloxGui")
        
        local function findChatFrame()
            local robloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
            if not robloxGui then return nil end
            
            -- Cari di berbagai lokasi
            local locations = {
                robloxGui:FindFirstChild("Chat"),
                robloxGui:FindFirstChild("ChatWidget"),
                robloxGui:FindFirstChild("DefaultChatSystemChatEvents")
            }
            
            for _, loc in ipairs(locations) do
                if loc then
                    return loc
                end
            end
            return nil
        end
        
        local chatFrame = findChatFrame()
        if chatFrame then
            -- Method 1: Monitor ChildAdded
            if chatFrame:FindFirstChild("MessageLogDisplay", true) then
                local messageLog = chatFrame:FindFirstChild("MessageLogDisplay", true)
                messageLog.ChildAdded:Connect(function(child)
                    wait(0.3)
                    if child:IsA("Frame") and child:FindFirstChild("TextLabel") then
                        local text = child.TextLabel.Text
                        local speaker = text:match("^([^:]+):")
                        if speaker then
                            local message = text:sub(#speaker + 3)
                            speaker = speaker:gsub("%[.*%]", ""):gsub("%s+$", "")
                            processChatMessage(message, speaker)
                        end
                    end
                end)
            end
            
            -- Method 2: Hook ChatService
            pcall(function()
                local ChatService = game:GetService("Chat")
                local clientChat = ChatService:FindFirstChild("ClientChatModules")
                if clientChat then
                    -- Coba hook fungsi chat
                end
            end)
            
            print("✅ Chat monitor aktif!")
        else
            warn("❌ Chat frame tidak ditemukan")
        end
    end)
end

-- Function untuk monitor RemoteEvents/RemoteFunctions
local function setupRemoteSpy()
    if not ENABLE_REMOTE_SPY then return end
    
    -- Hook semua RemoteEvents/RemoteFunctions yang ada
    local function hookRemote(remote)
        local oldFireServer = remote.FireServer
        local oldInvokeServer = remote.InvokeServer
        
        if oldFireServer then
            remote.FireServer = function(self, ...)
                local args = {...}
                local eventName = remote.Name
                
                -- Log remote call
                table.insert(remoteLogs, {
                    time = os.time(),
                    name = eventName,
                    type = "FireServer",
                    args = args
                })
                
                -- Cek jika ini event fishing
                if eventName:lower():find("fish") or eventName:lower():find("catch") then
                    if DEBUG_MODE then
                        print("🎣 Fishing event detected:", eventName, #args, "args")
                    end
                    
                    -- Coba parse fish data dari args
                    if #args > 0 then
                        local fishData = args[1]
                        if type(fishData) == "table" then
                            local embed = {
                                title = "🎣 FISHING EVENT TRIGGERED",
                                description = "RemoteEvent: **" .. eventName .. "**",
                                color = 0xFFA500,
                                fields = {},
                                footer = {text = "Remote Spy • " .. os.date("%H:%M:%S")}
                            }
                            
                            for k, v in pairs(fishData) do
                                if type(v) == "string" or type(v) == "number" then
                                    table.insert(embed.fields, {
                                        name = tostring(k),
                                        value = "```" .. tostring(v) .. "```",
                                        inline = true
                                    })
                                end
                            end
                            
                            sendWebhook(embed, false)
                        end
                    end
                end
                
                return oldFireServer(self, ...)
            end
        end
        
        if oldInvokeServer then
            remote.InvokeServer = function(self, ...)
                local args = {...}
                local eventName = remote.Name
                
                table.insert(remoteLogs, {
                    time = os.time(),
                    name = eventName,
                    type = "InvokeServer",
                    args = args
                })
                
                if eventName:lower():find("fish") then
                    if DEBUG_MODE then
                        print("🎣 Fishing invoke detected:", eventName)
                    end
                end
                
                return oldInvokeServer(self, ...)
            end
        end
    end
    
    -- Scan dan hook semua remotes
    local function scanRemotes()
        local locations = {
            ReplicatedStorage,
            workspace,
            game:GetService("Lighting")
        }
        
        for _, location in ipairs(locations) do
            pcall(function()
                for _, remote in ipairs(location:GetDescendants()) do
                    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                        if not remoteLogs[remote] then
                            hookRemote(remote)
                            remoteLogs[remote] = true
                        end
                    end
                end
            end)
        end
    end
    
    -- Scan periodically
    spawn(function()
        while wait(30) do
            scanRemotes()
        end
    end)
    
    -- Initial scan
    scanRemotes()
end

-- Function untuk monitor fishing activity
local function setupFishingMonitor()
    if not ENABLE_FISHING_ACTIVITY then return end
    
    local lastFishingState = false
    local fishingStartTime = 0
    
    spawn(function()
        while wait(2) do
            pcall(function()
                local character = player.Character
                if not character then
                    lastFishingState = false
                    return
                end
                
                -- Cek jika sedang fishing
                local isFishing = false
                local fishingTool = nil
                
                -- Cek tool di tangan
                local rightHand = character:FindFirstChild("RightHand")
                if rightHand then
                    for _, weld in ipairs(rightHand:GetChildren()) do
                        if weld:IsA("Weld") and weld.Part1 then
                            local tool = weld.Part1.Parent
                            if tool and tool:IsA("Tool") then
                                if tool.Name:lower():find("fish") or tool.Name:lower():find("rod") then
                                    isFishing = true
                                    fishingTool = tool
                                    break
                                end
                            end
                        end
                    end
                end
                
                -- Cek animasi fishing
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChild("Animator")
                    if animator then
           
