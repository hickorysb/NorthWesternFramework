local firstSpawn = true

AddEventHandler(
  "onClientMapStart",
  function()
    local hash = GetHashKey("mp_m_freemode_01")
    RequestModel(hash)
    local i = 0
    while not HasModelLoaded(hash) do
      print("loop: " .. i)
      i = i + 1
      Citizen.Wait(500)
    end
    exports.spawnmanager:setAutoSpawn(false)
    DoScreenFadeOut(0)
    exports.spawnmanager:spawnPlayer(
      {
        x = 177.19,
        y = -921.85,
        z = 30.69,
        heading = 50.75,
        model = "mp_m_freemode_01",
        skipFade = false
      }
    )
  end
)

AddEventHandler(
  "playerSpawned",
  function(spawninfo)
    if firstSpawn then
      firstSpawn = false
      SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
      TriggerEvent("NWF::multichar:openmenu")
    end
  end
)
