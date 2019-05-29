debug = {}
teams = {
    -- players = {},
    ["tm_civilian"] = {
        ["id"] = 1,
        ["name"] = "Civilian",
        ["cmdName"] = "civ"
    }
}

sendChatMessage = function(player, message, color)
    TriggerClientEvent("chat:addMessage", player, {
        args = { nil, message },
        color = color or {255, 255, 255}
    })
end

DebugPrint = function(player, text)
    if debug[player] then
        TriggerClientEvent("ClientPrint", player, "[" .. GetCurrentResourceName() .. "] " .. text)
    end
end

RegisterCommand('_debug', function(source)
    debug[source] = not debug[source]
    sendChatMessage(source, "You have " .. (debug[source] and "enabled" or "disabled") .. " debugging.")
end)

AddEventHandler("playerSpawned", function()
    local source
    teams[source] = "tm_civilian"
    debug[source] = false
end)

AddEventHandler("playerDropped", function(reason)
    RconPrint(GetPlayerName(source) .. " left. (" .. reason .. ").")
end)

RegisterCommand('job', function(source, args, raw)
    for k, v in pairs(teams) do
        print(type(v))
        print(type(v["id"]))
        print(type(v["cmdName"]))
        if v["cmdName"]:lower() == args[1]:lower() then
            teams[source] = v
            print(teams[source].id)
        end
    end
end)

RegisterCommand('r', function(source, args, raw)
    if teams[source] == tm_civilian then
        sendChatMessage(source, "Your team is: [ " .. teams[source] .. " ].")
    end
end)
