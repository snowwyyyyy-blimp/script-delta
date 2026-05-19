-- Actual Private Server Hub | Delta Edition V3
-- Attempts to create Reserved Instances and provides Hyper-Isolation.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Actual Private Hub | V3",
   LoadingTitle = "Bypassing Server Limits...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = true, FolderName = "PrivateServerDelta", FileName = "Config" },
   KeySystem = false
})

-- Variables
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local PlaceId = game.PlaceId

local IsolationMode = false

-- Tabs
local MainTab = Window:CreateTab("Reserved Server", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483345998)

-- --- RESERVED SERVER LOGIC ---

MainTab:CreateButton({
   Name = "Create & Join Reserved Server",
   Info = "Attempts to create a truly private instance (Works in some games)",
   Callback = function()
       Rayfield:Notify({Title = "Reserved Server", Content = "Attempting to generate access code...", Duration = 3})
       
       -- Attempting client-side reservation (Requires high-level executor permissions)
       local success, code = pcall(function()
           return TeleportService:ReserveServer(PlaceId)
       end)
       
       if success and code then
           Rayfield:Notify({Title = "Success!", Content = "Code Generated: " .. code .. ". Teleporting...", Duration = 5})
           print("Private Server Access Code: " .. code)
           TeleportService:TeleportToPrivateServer(PlaceId, code, {Players.LocalPlayer})
       else
           Rayfield:Notify({Title = "Permission Denied", Content = "This game blocks client-side reservation. Using Isolation Fallback...", Duration = 5})
           -- Fallback to the loneliest public server
           local url = "https://games.roproxy.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
           local response = game:HttpGet(url)
           local data = HttpService:JSONDecode(response)
           if data and data.data then
               for _, server in pairs(data.data) do
                   if server.playing == 0 and server.id ~= game.JobId then
                       TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Players.LocalPlayer)
                       return
                   end
               end
           end
       end
   end,
})

MainTab:CreateToggle({
   Name = "Hyper-Isolation Mode",
   CurrentValue = false,
   Flag = "Isolation",
   Callback = function(Value)
      IsolationMode = Value
      if Value then
          Rayfield:Notify({Title = "Isolation Active", Content = "You will be kicked/hopped INSTANTLY if anyone joins.", Duration = 3})
      end
   end,
})

-- --- UTILITY TAB ---

UtilityTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
       TeleportService:Teleport(PlaceId, Players.LocalPlayer)
   end,
})

UtilityTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
       local url = "https://games.roproxy.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=10"
       local response = game:HttpGet(url)
       local data = HttpService:JSONDecode(response)
       if data and data.data then
           TeleportService:TeleportToPlaceInstance(PlaceId, data.data[math.random(1, #data.data)].id, Players.LocalPlayer)
       end
   end,
})

-- --- LOGIC ---

Players.PlayerAdded:Connect(function(player)
    if IsolationMode then
        -- No delay, instant hop for maximum privacy
        Rayfield:Notify({Title = "ISOLATION TRIGGERED", Content = player.Name .. " joined. Leaving now...", Duration = 2})
        
        local url = "https://games.roproxy.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)
        if data and data.data then
            for _, server in pairs(data.data) do
                if server.playing == 0 and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Players.LocalPlayer)
                    return
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "V3 Private Hub Loaded",
   Content = "Use the Reserved Server tab for the best results.",
   Duration = 5,
})
