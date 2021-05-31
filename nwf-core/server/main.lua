local players = {}
NWF = {}
NWF.PData = {}
NWF.Shared = {}
NWF.Utilities = NWFUtilities
NWF.Functions = NWFFunctions

RegisterServerEvent("NWF:GrabObject")
AddEventHandler(
    "NWF:GrabObject",
    function(cb)
        cb(NWF)
    end
)

RegisterServerEvent("NWF:RetrieveCharacterData")
AddEventHandler(
    "NWF:RetrieveCharacterData",
    function()
        local source = source
        if players[source] == nil then
            local identifiers = GetPlayerIdentifiers(source)
            local discordID = nil
            for _, v in pairs(identifiers) do
                if string.find(v, "discord") then
                    discordID = v
                    break
                end
            end
            players[source] = discordID
        end
        exports["nwf-connector"]:execute(
            'SELECT * FROM players WHERE identifier="' .. players[source] .. '"',
            function(result)
                if result ~= nil then
                    local data = {}
                    for k, v in pairs(result[1]) do
                        if k == "last_postition" then
                            data[k] = dson.decode(v)
                        else
                            data[k] = v
                        end
                    end
                    NWF.PData[source] = data
                    TriggerClientEvent("NWF:CharacterData", source, data)
                else
                    TriggerClientEvent("NWF:CharacterData", source, nil)
                end
            end
        )
    end
)

AddEventHandler(
    "playerConnecting",
    function(playername, kick, defer)
        local source = source
        defer.defer()
        Citizen.Wait(0)
        defer.update("Checking for Discord ID...")
        local identifiers = GetPlayerIdentifiers(source)
        local discordID = nil
        for _, v in pairs(identifiers) do
            if string.find(v, "discord") then
                discordID = v
                break
            end
        end
        Citizen.Wait(0)
        if discordID == nil then
            defer.done("Discord not found!")
        else
            defer.done()
        end
    end
)

AddEventHandler(
    "playerDropped",
    function()
        if players[source] ~= nil then
            table.remove(players, source)
        end
        if NWF.PData[source] ~= nil then
            table.remove(NWF.PData, source)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(30000)
            if #NWF.PData > 0 then
                print("Saving all players!")
                for k, v in pairs(NWF.PData) do
                    local coord = GetEntityCoords(GetPlayerPed(k))
                    local hed = GetEntityHeading(GetPlayerPed(k))
                    NWF.PData[k].last_position = {
                        x = coord.x,
                        y = coord.y,
                        z = coord.z,
                        heading = hed
                    }
                    exports["nwf-connector"]:execute(
                        'UPDATE players SET `first_name` = "' ..
                            NWF.PData[k].first_name ..
                                '",`middle_name` = "' ..
                                    NWF.PData[k].middle_name ..
                                        '",`last_name` = "' ..
                                            NWF.PData[k].last_name ..
                                                '",`identifier` = "' ..
                                                    NWF.PData[k].identifier ..
                                                        '",`health` = ' ..
                                                            NWF.PData[k].health ..
                                                                ",`bank_balance` = " ..
                                                                    NWF.PData[k].bank_balance ..
                                                                        ",`is_dead` = " ..
                                                                            (NWF.PData[k].is_dead and 1 or 0) ..
                                                                                ",`last_position` = '" ..
                                                                                    json.encode(
                                                                                        NWF.PData[k].last_position
                                                                                    ) ..
                                                                                        "' WHERE `charid` = " ..
                                                                                            NWF.PData[k].charid
                    )
                end
            else
                print("Skipping save cycle. No Players.")
            end
        end
    end
)
