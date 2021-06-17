STORAGE_SECTION_ITEMS = 'items'
STORAGE_SECTION_WEAPONS = 'weapons'
STORAGE_SECTION_ACCOUNTS = 'accounts'
STORAGE_ACCOUNTS_BLACK = 'blackMoney'
STORAGE_ACCOUNTS_CASH = 'cash'

STORAGE_ITEM_NAME = 'name'
STORAGE_ITEM_COUNT = 'count'
STORAGE_ITEM_LABEL = 'label'

STORAGE_WEAPON_AMMO = 'ammo'
STORAGE_WEAPON_NAME = 'name'
STORAGE_WEAPON_COMPONENTS = 'components'
STORAGE_WEAPON_LABEL = 'label'

onStorageOpen = function(xPlayer, invData, roomName, hotelName)
    if invData[STORAGE_SECTION_ACCOUNTS] == nil then
        invData[STORAGE_SECTION_ACCOUNTS] = {}
    end

    local exportFormat = {
        ['blackMoney'] = invData[STORAGE_SECTION_ACCOUNTS][STORAGE_ACCOUNTS_BLACK] or 0,
        ['money'] = invData[STORAGE_SECTION_ACCOUNTS][STORAGE_ACCOUNTS_CASH] or 0,
        ['items'] = invData[STORAGE_SECTION_ITEMS],
        ['weapons'] = invData[STORAGE_SECTION_WEAPONS],
        ['hotel'] = hotelName,
        ['room'] = roomName,
    }

    TriggerClientEvent('esx_inventoryhud:openRcoreHotelInventory', xPlayer.source, exportFormat)
end
