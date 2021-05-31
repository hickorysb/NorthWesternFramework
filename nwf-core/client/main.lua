NWF = {}
NWF.PData = {}
NWF.Shared = {}
NWF.Utilities = NWFUtilities

RegisterNetEvent("NWF:GrabObject")
AddEventHandler(
    "NWF:GrabObject",
    function(cb)
        cb(NWF)
    end
)

AddEventHandler(
    "playerSpawned",
    function()
        --TriggerServerEvent("NWF:RetrieveCharacterData")
    end
)

RegisterNetEvent("NWF:CharacterData")
AddEventHandler(
    "NWF:CharacterData",
    function(data)
        if data ~= nil then
            NWF.PData = data
            if NWF.PData.is_dead then
                SetEntityHealth(GetPlayerPed(-1), 0)
            else
                SetEntityHealth(GetPlayerPed(-1), NWF.PData.health)
            end
        else
            -- TO-DO: Character selection and creation
        end
    end
)
