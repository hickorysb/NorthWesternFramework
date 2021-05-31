NWFUtilities = {}

NWFUtilities.DisplayHelpNotification = function(displaystring)
    SetTextComponentFormat("STRING")
    AddTextComponentString(displaystring)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
