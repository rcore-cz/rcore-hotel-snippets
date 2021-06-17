STORAGE_SECTION_ITEMS = 'items'
STORAGE_SECTION_WEAPONS = 'weapons'
STORAGE_SECTION_ACCOUNTS = 'accounts'
STORAGE_ACCOUNTS_BLACK = 'blackMoney'
STORAGE_ACCOUNTS_CASH = 'cash'

local lastData = {}

RegisterNetEvent("esx_inventoryhud:openRcoreHotelInventory")
AddEventHandler("esx_inventoryhud:openRcoreHotelInventory", function(data)
    setRcoreHotelInventoryData(data)
    openRcoreHotelInventory()
end)

function refreshHotelInventory()
    if lastData ~= nil then
        callCallback("rcore_hotel:getStorage",
                function(inventory)
                    local exportFormat = {
                        ['blackMoney'] = inventory['accounts']['blackMoney'] or 0,
                        ['money'] = inventory['accounts']['cash'] or 0,
                        ['items'] = inventory['items'],
                        ['weapons'] = inventory['weapons'],
                        ['hotel'] = lastData.hotel,
                        ['room'] = lastData.room,
                    }

                    setRcoreHotelInventoryData(exportFormat)
                end, lastData.hotel, lastData.room)
    end
end

function setRcoreHotelInventoryData(data)
    lastData = data

    items = {}

    local blackMoney = data.blackMoney
    local money = data.money
    local propertyItems = data.items
    local propertyWeapons = data.weapons

    if blackMoney > 0 then
        accountData = {
            label = _U("black_money"),
            count = blackMoney,
            type = "item_account",
            name = "black_money",
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    if money > 0 then
        accountData = {
            label = _U("cash"),
            count = money,
            type = "item_money",
            name = "cash",
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        if item.count > 0 then
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #propertyWeapons, 1 do
        local weapon = propertyWeapons[i]

        if propertyWeapons[i].name ~= "WEAPON_UNARMED" then
            table.insert(items,
                    {
                        label = ESX.GetWeaponLabel(weapon.name),
                        count = weapon.ammo,
                        limit = -1,
                        type = "item_weapon",
                        name = weapon.name,
                        usable = false,
                        rare = false,
                        canRemove = false
                    })
        end
    end

    SendNUIMessage({
        action = "setSecondInventoryItems",
        itemList = items
    })
end

function openRcoreHotelInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage({
        action = "display",
        type = "rcore_hotel",
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoRcoreHotelRoom",
        function(data, cb)
            if IsPedSittingInAnyVehicle(playerPed) then
                return
            end

            if type(data.number) == "number" and math.floor(data.number) == data.number then
                local count = tonumber(data.number)

                if data.item.type == "item_weapon" then
                    count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
                end

                local hotelType = 'items'
                if data.item.type == 'item_weapon' then
                    hotelType = STORAGE_SECTION_WEAPONS
                elseif data.item.type == 'item_standard' then
                    hotelType = STORAGE_SECTION_ITEMS
                elseif data.item.type == 'item_money' then
                    hotelType = STORAGE_ACCOUNTS_CASH
                elseif data.item.type == 'item_account' then
                    if data.item.name == 'black_money' then
                        hotelType = STORAGE_ACCOUNTS_BLACK
                    end
                end

                callCallback('rcore_hotel:storageGive', function()
                end, lastData.hotel, lastData.room, hotelType, count, data.item.name)
            end

            Wait(150)
            refreshHotelInventory()
            Wait(150)
            loadPlayerInventory()

            cb("ok")
        end)

RegisterNUICallback("TakeFromRcoreHotelRoom",
        function(data, cb)
            if IsPedSittingInAnyVehicle(playerPed) then
                return
            end

            if type(data.number) == "number" and math.floor(data.number) == data.number then

                local hotelType = 'items'
                if data.item.type == 'item_weapon' then
                    hotelType = STORAGE_SECTION_WEAPONS
                elseif data.item.type == 'item_standard' then
                    hotelType = STORAGE_SECTION_ITEMS
                elseif data.item.type == 'item_money' then
                    hotelType = STORAGE_ACCOUNTS_CASH
                elseif data.item.type == 'item_account' then
                    if data.item.name == 'black_money' then
                        hotelType = STORAGE_ACCOUNTS_BLACK
                    end
                end

                callCallback('rcore_hotel:storageTake', function()
                end, lastData.hotel, lastData.room, hotelType, data.number, data.item.name)
            end

            Wait(150)
            refreshHotelInventory()
            Wait(150)
            loadPlayerInventory()

            cb("ok")
        end)
