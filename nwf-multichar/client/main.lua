local inMenu = false

RegisterNetEvent("NWF::multichar:openmenu")
AddEventHandler(
    "NWF::multichar:openmenu",
    function()
        inMenu = true
        Citizen.CreateThread(
            function()
                while inMenu do
                    HideHudAndRadarThisFrame()
                    DisableAllControlActions(2)
                    FreezePedCameraRotation(GetPlayerPed(-1))
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    Citizen.Wait(1)
                end
            end
        )
        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        local coordsCam = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1, 0.65)
        SetCamCoord(cam, -1611.26, -2441.54, 643.52)
        PointCamAtCoord(cam, -92.38, -840.41, 242.95)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        Citizen.Wait(1000)
        SendNUIMessage(
            {
                type = "open"
            }
        )
        SetNuiFocus(true, true)
        DoScreenFadeIn(4000)
        print("Starting character selection.")
    end
)
