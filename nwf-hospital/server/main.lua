local NWF = nil

TriggerEvent(
    "NWF:GrabObject",
    function(obj)
        NWF = obj
    end
)

RegisterCommand(
    "arevive",
    function(source, args, rawCommand)
        if args[1] ~= nil and args[1] ~= "" then
            if NetworkIsPlayerActive[args[1]] then
                TriggerClientEvent("NWF::hospital:AdminRevive", args[1])
                TriggerClientEvent(
                    "chat:addMessage",
                    source,
                    {
                        color = {255, 255, 255},
                        multiline = true,
                        args = {"NWF Revive", "You successfully revived the player with ID " .. args[1] .. "!"}
                    }
                )
            else
                TriggerClientEvent(
                    "chat:addMessage",
                    source,
                    {
                        color = {255, 0, 0},
                        multiline = true,
                        args = {"NWF Revive", "Player is not online!"}
                    }
                )
            end
        else
            TriggerClientEvent("NWF::hospital:AdminRevive", source)
        end
    end,
    true
)

RegisterServerEvent("NWF::hospital:UpdateHealth")
AddEventHandler(
    "NWF::hospital:UpdateHealth",
    function(health)
        local pData = NWF.Functions.GetPlayerFromSrc(source)
        exports["nwf-connector"]:execute("UPDATE players SET health=" .. health .. " WHERE charid=" .. pData.charid)
        NWF.Functions.UpdateHealth(source, health)
    end
)

RegisterServerEvent("NWF::hospital:UpdateDeadStatus")
AddEventHandler(
    "NWF::hospital:UpdateDeadStatus",
    function(dead)
        local pData = NWF.Functions.GetPlayerFromSrc(source)
        if dead then
            exports["nwf-connector"]:execute("UPDATE players SET is_dead=" .. 1 .. " WHERE charid=" .. pData.charid)
        else
            exports["nwf-connector"]:execute("UPDATE players SET is_dead=" .. 0 .. " WHERE charid=" .. pData.charid)
        end
        NWF.Functions.UpdateDeadStatus(source, dead)
    end
)
