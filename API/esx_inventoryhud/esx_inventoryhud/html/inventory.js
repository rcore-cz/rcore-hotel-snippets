// Be aware, this part need to use brain and is not just "ctrl + c & ctrl + v"


//In "event.data.action === "display"
/*
//You will need to insert this

} else if (type === "rcore_hotel") {
    $(".info-div").show();
}

*/

// in "$('#playerInventory').droppable({" insert this
/*
    } else if (type === "rcore_hotel" && itemInventory === "second") {
        disableInventory(250);
        $.post("http://esx_inventoryhud/TakeFromRcoreHotelRoom", JSON.stringify({
            item: itemData,
            number: parseInt($("#count").val())
        }));
    }
*/