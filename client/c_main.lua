SentryIO_Usage = false
local wew

RegisterNetEvent("ClientPrint")
AddEventHandler("ClientPrint", function(text)
    Citizen.Trace(text)
end)

RegisterCommand('wew', function(s)
    Citizen.Trace("Error:omgomgomgomgomgomgomgomgomgomgomgogm")
    Citizen.Trace(tostring(SentryIO_Usage))
    Citizen.Trace(tostring(wew))
end)

RegisterNetEvent("sendInformationToClient")
AddEventHandler("sendInformationToClient", function(sentryIO, plyTeam, resName)
    SentryIO_Usage = sentryIO
    playerTeam = plyTeam
    resourceName = resName


    if SentryIO_Usage then
        local trace = _G.Citizen.Trace
        _G.Citizen.Trace = function(data)
            trace(data)
            if string.match(data, "Error") then
                TriggerServerEvent("SentryIO_Error", data:gsub(":(.*)", ""), data)
            end    
        end
    end
end)

AddEventHandler("playerSpawned", function(spawn)
    TriggerServerEvent("playerSpawned_s")
    TriggerEvent("chat:addMessage", {
        args = {"Player " .. GetPlayerName(PlayerId()) .. " has spawned."}
    })
end)
