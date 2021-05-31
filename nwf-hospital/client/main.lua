local NWF = nil
local isDead = false
local previousHealth = 200

Citizen.CreateThread(
    function()
        TriggerEvent(
            "NWF:GrabObject",
            function(obj)
                NWF = obj
            end
        )
        while NWF == nil do
            Citizen.Wait(1000)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            if IsEntityDead(GetPlayerPed(-1)) and not isDead then
                isDead = true
                NWF.PData.is_dead = true
                TriggerServerEvent("NWF::hospital:UpdateDeadStatus", true)
                Died()
            end
            if GetEntityHealth(GetPlayerPed(-1)) ~= previousHealth then
                previousHealth = GetEntityHealth(GetPlayerPed(-1))
                TriggerServerEvent("NWF::hospital:UpdateHealth", previousHealth)
            end
            Citizen.Wait(500)
        end
    end
)

function Died()
    Citizen.CreateThread(
        function()
            local timeTilRespawn = 60000
            local pos = GetEntityCoords(GetPlayerPed(-1))
            local hed = GetEntityHeading(GetPlayerPed(-1))
            NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, hed, true, false)
            local playerPed = GetPlayerPed(-1)
            if DoesEntityExist(playerPed) then
                Citizen.CreateThread(
                    function()
                        RequestAnimDict("dead")
                        while not HasAnimDictLoaded("dead") do
                            Citizen.Wait(100)
                        end

                        if IsEntityPlayingAnim(playerPed, "dead", "dead_e", 3) then
                            ClearPedSecondaryTask(playerPed)
                        else
                            TaskPlayAnim(playerPed, "dead", "dead_e", 1.0, 0.0, -1, 9, 9, 1, 1, 1)
                            GivePlayerRagdollControl(PlayerId(), false)
                        end
                    end
                )
            end
            while isDead do
                if timeTilRespawn <= 0 then
                    if NWF == nil then
                        print("Something went wrong and player died too soon.")
                    else
                        NWF.Utilities.DisplayHelpNotification("Press ~INPUT_PICKUP~ to respawn.")
                    end
                    if IsControlJustPressed(0, 38) and IsUsingKeyboard(2) then
                        TriggerServerEvent("NWF::hospital:UpdateDeadStatus", false)
                        NWF.PData.is_dead = false
                        exports.spawnmanager:spawnPlayer(
                            {
                                x = 360.01,
                                y = -585.07,
                                z = 28.82,
                                heading = 243.08,
                                skipFade = false
                            }
                        )
                        isDead = false
                        ClearPedBloodDamage(playerPed)
                    end
                    Citizen.Wait(0)
                else
                    NWF.Utilities.DisplayHelpNotification(
                        "Press~r~~h~ " .. timeTilRespawn // 1000 .. "~s~~h~ seconds until you can respawn."
                    )
                    timeTilRespawn = timeTilRespawn - 1000
                    Citizen.Wait(1000)
                end
            end
        end
    )
end

RegisterNetEvent(
    "NWF::hospital:AdminRevive",
    function()
        isDead = false
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local hed = GetEntityHeading(GetPlayerPed(-1))
        NWF.PData.is_dead = false
        TriggerServerEvent("NWF::hospital:UpdateDeadStatus", false)
        exports.spawnmanager:spawnPlayer(
            {
                x = pos.x,
                y = pos.y,
                z = pos.z,
                heading = 243.08,
                skipFade = true
            }
        )
        ClearPedBloodDamage(GetPlayerPed(-1))
        TriggerEvent(
            "chat:addMessage",
            {
                color = {255, 255, 255},
                multiline = true,
                args = {"NWF Revive", "You were successfully revived by an admin!"}
            }
        )
    end
)

TriggerEvent(
    "chat:addSuggestion",
    "/arevive",
    "Revive someone using your admin magic.",
    {
        {name = "Player ID", help = "The ID of the player to be revived."}
    }
)
