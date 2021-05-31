NWFFunctions = {}

NWFFunctions.GetPlayerFromSrc = function(source)
    return NWF.PData[source]
end

NWFFunctions.UpdateHealth = function(source, health)
    NWF.PData[source].health = health
end

NWFFunctions.UpdateDeadStatus = function(source, status)
    NWF.PData[source].is_dead = status
end
