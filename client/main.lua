--[[
     ██████╗     ███████╗    ███████╗    ██╗    ███████╗           ██████╗     ██╗
    ██╔═══██╗    ██╔════╝    ██╔════╝    ██║    ██╔════╝           ██╔══██╗    ██║
    ██║   ██║    █████╗      ███████╗    ██║    ███████╗           ██████╔╝    ██║
    ██║   ██║    ██╔══╝      ╚════██║    ██║    ╚════██║           ██╔═══╝     ██║
    ╚██████╔╝    ███████╗    ███████║    ██║    ███████║    ██╗    ██║         ███████╗
     ╚═════╝     ╚══════╝    ╚══════╝    ╚═╝    ╚══════╝    ╚═╝    ╚═╝         ╚══════╝
     Developed by: mWojtasik.pl
--]]

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["F"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local currentActionTime = nil
local currentItem = nil
local isActionStarted = false
local isActionFailed = false
local isInLocation = false
local currentStep = 0
local currentAction = nil
local x, y, z = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = GetPlayerPed(-1)
        Citizen.Wait(0)
        if isActionStarted then
            if IsControlJustPressed(1, Keys["X"]) then
                stopEvent()
            end
            for k, button in pairs(Config.cancel_buttons) do
                if IsControlJustPressed(1, button) then
                    stopEvent()
                end
            end
            if IsEntityDead(playerPed) then
                stopEvent()
            end
            if GetDistanceBetweenCoords (x, y, z, GetEntityCoords(playerPed)) > 5 and x ~= nil then
                stopEvent()
            end
        end
    end
end)

Citizen.CreateThread(function()
    local lastStoredStep = nil
    local hasAlreadyChangeStep = false
    while true do
        Citizen.Wait(0)
        if currentStep ~= nil then

            if currentStep == 0 then
                ESX.UI.Menu.CloseAll()
                isActionStarted = false
                currentStep = 1
            end

            if isActionStarted and currentStep ~= 0 then
                if currentStep ~= lastStoredStep then
                    lastStoredStep = currentStep
                    hasAlreadyChangeStep = true
                else
                    hasAlreadyChangeStep = false
                end

                if hasAlreadyChangeStep and currentItem ~= nil and currentStep ~= 1 then
                    ESX.UI.Menu.CloseAll()
                    local currentAction = currentItem.questions[currentStep]
                    TriggerEvent('esx_receptury:StartAction', currentStep, currentAction)
                end
            end
        end
    end
end)

RegisterNetEvent("esx_receptury:RequestStart")
AddEventHandler("esx_receptury:RequestStart", function(item_name, time)
    currentItem = options[item_name]
    currentActionTime = time
    isInLocation = false
    local playerPed = GetPlayerPed(-1)

    for k, Cords in pairs(currentItem.cords) do
        if IsPedInAnyVehicle(playerPed) then
            exports.pNotify:SendNotification({text = _U('vehicle_deny'), type = "error", layout = "centerLeft", timeout = 2000})
            do return end
        end
        if isActionStarted then
            exports.pNotify:SendNotification({text = _U('wait_end'), type = "error", layout = "centerLeft", timeout = 2000})
            do return end
        end
        if GetDistanceBetweenCoords (Cords.x, Cords.y, Cords.z, GetEntityCoords(playerPed)) <= Cords.distance then
            isInLocation = true
            isActionStarted = true
            ESX.UI.Menu.CloseAll()
            TriggerServerEvent('esx_receptury:RemoveItem', item_name)
            exports.pNotify:SendNotification({text = currentItem.start_msg, type = "success", layout = "centerLeft", timeout = 2000})

            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            x, y, z   = table.unpack(coords + forward * 1.0)

            for k, StartAnims in pairs(currentItem.animations_end) do
                if currentActionTime == 0 then
                    FreezeEntityPosition(playerPed, false)
                    do return end
                end
                startAnim(StartAnims.lib, StartAnims.anim)
                Citizen.Wait(StartAnims.timeout)
            end

            --Show first object.
            if currentActionTime == 0 then
                FreezeEntityPosition(playerPed, false)
                do return end
            end
            RequestModel(currentItem.object)
            while not HasModelLoaded(currentItem.object) do
                Citizen.Wait(1)
            end
            ESX.Game.SpawnObject(currentItem.object, {
                x = x,
                y = y,
                z = z - currentItem.first_step
            }, function(obj)
                SetEntityHeading(obj, GetEntityHeading(playerPed))
            end)

            currentStep = 1
            TriggerEvent('esx_receptury:CreateObject', name)
            break
        end
    end
    if not isInLocation then
        exports.pNotify:SendNotification({text = _U('wrong_place'), type = "error", layout = "centerLeft", timeout = 2000})
    else
        FreezeEntityPosition(playerPed, true)
        currentAction = currentItem.questions[currentStep]
        TriggerEvent('esx_receptury:StartAction', currentStep, currentAction)
    end
end)

RegisterNetEvent("esx_receptury:StartAction")
AddEventHandler("esx_receptury:StartAction", function(currentStep, currentAction)
    Citizen.CreateThread(function()
        local playerPed = GetPlayerPed(-1)
        local threadTime = currentActionTime
        if currentActionTime == 0 then
            FreezeEntityPosition(playerPed, false)
            do return end
        end
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'action',
            {
                title    = currentAction.title,
                align    = "center",
                elements = currentAction.steps
            },

            --Function when player select option
            function(data, menu)
                menu.close()
                exports.pNotify:SendNotification({text = _U('doing_action'), type = "info", layout = "centerLeft", timeout = 5000})
                exports.pNotify:SendNotification({text = _U('how_cancel'), type = "info", layout = "centerLeft", timeout = 8000})
                --Let's show step animations
                for k, Anim in pairs(currentItem.animations_step) do
                    startAnim(Anim.lib, Anim.anim)
                    Citizen.Wait(Anim.timeout)
                end


                if isActionStarted and threadTime == currentActionTime then
                    --Check that player select current option
                    if data.current.value == currentAction.correct then
                        --Check that player select last option, or he still doing action
                        if currentStep < currentItem.steps then
                            spawnNextObject(currentItem.object, currentItem.grow[currentStep], x, y, z)
                            currentStep = currentStep + 1
                            TriggerEvent('esx_receptury:storeStep', currentStep)
                        else
                            --Give item to player, when he just make last action
                            spawnEndObject(currentItem.object, currentItem.end_object, x, y, z)
                            TriggerServerEvent('esx_receptury:statusSuccess', currentItem.success_msg, data.current.min, data.current.max, currentItem.success_item)
                            FreezeEntityPosition(playerPed, false)
                            currentStep = 0
                            TriggerEvent('esx_receptury:storeStep', currentStep)
                        end
                    else
                        --Show failed object, when player select wrong option
                        currentStep = 0
                        local playerPed = GetPlayerPed(-1)
                        FreezeEntityPosition(playerPed, false)
                        exports.pNotify:SendNotification({text = currentItem.fail_msg, type = "error", layout = "centerLeft", timeout = 2500})
                        spawnEndObject(currentItem.object, currentItem.end_object, x, y, z)
                        TriggerEvent('esx_receptury:storeStep', currentStep)
                    end
                end
            end,

            --Function when player close UI, like ESC or BACKSPACE
            function(data, menu)
                currentStep = 0
                FreezeEntityPosition(playerPed, false)
                TriggerEvent('esx_receptury:storeStep', currentStep)
                stopEvent()
                menu.close()
            end,
            --Function when player change option ussing arrows, you know, change ex. from first option to secound in UI
            function(data, menu)
            --Do nothing
            end,
            --Function when player 'close' ui, but i realy dont even know how it work, bcs he work also when player select option...
            function(data, menu)
            --Do nothing
            end) --Close the ESX.UI.Menu.Open syntax

    end)
end)

RegisterNetEvent('esx_receptury:storeStep')
AddEventHandler('esx_receptury:storeStep', function(step)
    currentStep = step
end)



-- Addon Functions

function startAnim(lib, anim)
    if isActionStarted then
        Citizen.CreateThread(function()
            RequestAnimDict(lib)
            while not HasAnimDictLoaded( lib) do
                Citizen.Wait(1)
            end
            TaskPlayAnim(GetPlayerPed(-1), lib ,anim ,8.0, -8.0, -1, 0, 0, false, false, false )
        end)
    end
end

function spawnEndObject(object_start, object_end, x, y, z)
    if isActionStarted then
        ESX.Game.SpawnObject(object_end, {
            x = x,
            y = y,
            z = z
        }, function(obj)
            deleteLastObject(object_start, x, y, z)
            SetEntityHeading(obj, GetEntityHeading(GetPlayerPed(-1)))
            PlaceObjectOnGroundProperly(obj)
        end)
    end
end

function deleteLastObject(object_end, x, y, z)
    ESX.Game.DeleteObject(ESX.Game.GetClosestObject(object_end, {
        x = x,
        y = y,
        z = z
    }))
end

function spawnNextObject(object_start, grow, x, y, z)
    if isActionStarted then
        ESX.Game.DeleteObject(ESX.Game.GetClosestObject(object_start, {
            x = x,
            y = y,
            z = z - grow
        }))
        ESX.Game.SpawnObject(object_start, {
            x = x,
            y = y,
            z = z - grow
        }, function(obj)
            SetEntityHeading(obj, GetEntityHeading(GetPlayerPed(-1)))
        end)
    end
end

function cancelAnim()
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ClearPedTasks(GetPlayerPed(-1))
    ClearPedSecondaryTask(GetPlayerPed(-1))
end

function stopEvent()
    currentStep = 0
    isActionFailed = true
    currentActionTime = 0
    cancelAnim()
    FreezeEntityPosition(GetPlayerPed(-1), false)
    spawnEndObject(currentItem.object, currentItem.end_object, x, y, z)
    x = nil
    isActionStarted = false
    exports.pNotify:SendNotification({text = _U('cancel'), type = "info", layout = "centerLeft", timeout = 2000})
    exports.pNotify:SendNotification({text = currentItem.fail_msg, type = "error", layout = "centerLeft", timeout = 2500})
end
