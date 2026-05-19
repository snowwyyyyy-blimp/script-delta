-- Private Server Hub | Delta Edition V5
-- Features: MatchmakingService API (Lock/Hide), Anti-Join, and Server Browser.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Private Server Hub | V5",
   LoadingTitle = "Securing Server...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = true, FolderName = "PrivateServerDelta", FileName = "Config" },
   KeySystem = false
})

-- Variables
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MatchmakingService = nil
pcall(function() MatchmakingService = game:GetService("MatchmakingService") end)
local PlaceId = game.PlaceId
local JobId = game.JobId

local IsolationMode = false

-- Tabs
local PrivateTab = Window:CreateTab("Private Server Hub", 4483362458)
local BrowserTab = Window:CreateTab("Server Browser", 4483362458)

-- --- PRIVATE SERVER HUB ---

PrivateTab:CreateLabel("Roblox Matchmaking API (Private Mode)")

PrivateTab:CreateButton({
    Name = "Lock This Server",
    Info = "Uses MatchmakingService to set 'Locked' to true. This stops Roblox from sending new players here.",
    Callback = function()
        if not MatchmakingService then 
            Rayfield:Notify({Title = "Error", Content = "MatchmakingService not available on client.", Duration = 5}) 
            return 
        end
        local success, err = pcall(function()
            return MatchmakingService:SetServerAttribute("Locked", true)
        end)
        if success then
            Rayfield:Notify({Title = "Success", Content = "Server Locked! Roblox should stop matchmaking players here.", Duration = 5})
        else
            Rayfield:Notify({Title = "API Error", Content = "Failed to Lock: " .. tostring(err), Duration = 5})
        end
    end
})

PrivateTab:CreateButton({
    Name = "Hide This Server",
    Info = "Uses MatchmakingService to set 'Hidden' to true.",
    Callback = function()
        if not MatchmakingService then 
            Rayfield:Notify({Title = "Error", Content = "MatchmakingService not available on client.", Duration = 5}) 
            return 
        end
        local success, err = pcall(function()
            return MatchmakingService:SetServerAttribute("Hidden", true)
        end)
        if success then
            Rayfield:Notify({Title = "Success", Content = "Server Hidden! It should no longer appear in matchmaking.", Duration = 5})
        else
            Rayfield:Notify({Title = "API Error", Content = "Failed to Hide: " .. tostring(err), Duration = 5})
        end
    end
})

PrivateTab:CreateLabel("Small Server Finder (Fallback)")

PrivateTab:CreateButton({
   Name = "Find Smallest Server",
   Callback = function()
       Rayfield:Notify({Title = "Scanning...", Content = "Finding a lonely server...", Duration = 3})
       local url = "https://games.roproxy.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
       local data = HttpService:JSONDecode(game:HttpGet(url))
       if data and data.data then
           for _, s in pairs(data.data) do
               if s.playing < 2 and s.id ~= JobId then
                   TeleportService:TeleportToPlaceInstance(PlaceId, s.id, Players.LocalPlayer)
                   return
               end
           end
       end
       Rayfield:Notify({Title = "Error", Content = "No small servers found.", Duration = 3})
   end,
})

PrivateTab:CreateToggle({
   Name = "Anti-Join (Auto-Hop)",
   Info = "Automatically hops to a new small server if someone joins yours.",
   CurrentValue = false,
   Flag = "Isolation",
   Callback = function(Value) IsolationMode = Value end,
})

PrivateTab:CreateButton({
    Name = "Check Server Privacy Status",
    Callback = function()
        if not MatchmakingService then Rayfield:Notify({Title = "Error", Content = "MatchmakingService not available.", Duration = 5}) return end
        local attrs = {"Locked", "Hidden", "Private", "Status"}
        local result = ""
        for _, attr in pairs(attrs) do
            local success, val = pcall(function() return MatchmakingService:GetServerAttribute(attr) end)
            if success and val ~= nil then
                result = result .. attr .. ": " .. tostring(val) .. "\n"
            end
        end
        if result == "" then result = "No privacy attributes set yet." end
        Rayfield:Notify({Title = "Privacy Check", Content = result, Duration = 10})
    end
})

-- --- SERVER BROWSER ---

BrowserTab:CreateButton({
   Name = "Refresh Server List",
   Callback = function()
       Rayfield:Notify({Title = "Scanning...", Content = "Fetching small servers...", Duration = 3})
       local url = "https://games.roproxy.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=10"
       local data = HttpService:JSONDecode(game:HttpGet(url))
       if data and data.data then
           for _, s in pairs(data.data) do
               BrowserTab:CreateButton({
                   Name = "Server (" .. s.playing .. " players)",
                   Callback = function()
                       TeleportService:TeleportToPlaceInstance(PlaceId, s.id, Players.LocalPlayer)
                   end
               })
           end
       end
   end,
})

-- --- LOGIC ---

Players.PlayerAdded:Connect(function(p)
    if IsolationMode then
        TeleportService:Teleport(PlaceId, Players.LocalPlayer)
    end
end)

Rayfield:Notify({
   Title = "V5 Private Hub Ready",
   Content = "Use Matchmaking API to secure your server!",
   Duration = 5,
})
