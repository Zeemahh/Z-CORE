playerTeams = {}
debugging = {}
teams = {
    ["civilian"] = {
        ["id"] = 0,
        ["name"] = "Civilian",
        ["cmdName"] = "civ"
    },

    ["police"] = {
        ["id"] = 1,
        ["name"] = "Police",
        ["cmdName"] = "police",
        ["restricted"] = true,
        ["restrictRank"] = "CR"
    }
}

alwaysDebug = GetConvarInt("JH1-RP.alwaysDebug", 0) ~= 0 and true or false

sendChatMessage = function(player, message, color)
    TriggerClientEvent("chat:addMessage", player, {
        args = { message },
        color = color or {255, 255, 255}
    })
end

DebugPrint = function(player, text)
    if debugging[player] or alwaysDebug then
        TriggerClientEvent("ClientPrint", player, "[" .. GetCurrentResourceName() .. "] " .. text)
    end
end

RegisterCommand('_debug', function(source)
    debugging[source] = not debugging[source]
    sendChatMessage(source, "You have " .. (debugging[source] and "enabled" or "disabled") .. " debugging.")
end)

RegisterNetEvent("playerSpawned_s")
AddEventHandler("playerSpawned_s", function()
    RconPrint(GetPlayerName(source) .. " spawned into the server.\n")
    playerTeams[source] = "tm_civilian"
    debugging[source] = false
end)

AddEventHandler("playerDropped", function(reason)
    RconPrint(GetPlayerName(source) .. " left. (" .. reason .. ").\n")
    playerTeams[source] = nil
    debugging[source] = nil
end)

RegisterCommand('job', function(source, args, raw)
    for k, v in pairs(teams) do
        DebugPrint(source, type(v) .. " -> " .. json.encode(v))          -- table
        DebugPrint(source, type(v["id"]) .. " -> " .. v["id"])           -- number
        DebugPrint(source, type(v["cmdName"]) .. " -> " .. v["cmdName"]) -- string
        if v["cmdName"]:lower() == args[1]:lower() then
            playerTeams[source] = {
                id = v.id,
                name = v.name
            }
            break
        end
    end
    DebugPrint(source, playerTeams[source].id .. " | " .. playerTeams[source].name)
end)

AddEventHandler("onServerResourceStart", function(name)
    if name ~= GetCurrentResourceName() then return end
    print(name)
end)

RegisterCommand('r', function(source, args, raw)
    sendChatMessage(source, "Your team is: [ " .. playerTeams[source] .. " ].")
end)

-- Chat suggestions
AddEventHandler("playerSpawned_s", function()
    TriggerClientEvent("chat:addSuggestion", source, "/job", "Set your player job!", {
        {
            name = "job",
            help = "the job you wish to play as"
        }
    })
    print("ok, shit should be set")
end)
