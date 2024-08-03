util.AddNetworkString("ChangePrice")

util.AddNetworkString("PricesRequest")
util.AddNetworkString("Prices")

util.AddNetworkString("ResetPrice")

function BroadcastPrices(ply)
    local data = sql.Query("SELECT * FROM prices_table")

    if data and data[1] then
        net.Start("Prices")
        net.WriteTable(data)
        net.Send(ply)
        return true
    else
        return false
    end
end

function BroadcastPrices()
    local data = sql.Query("SELECT * FROM prices_table")

    if data and data[1] then
        net.Start("Prices")
        net.WriteTable(data)
        net.Broadcast()
    end
end

net.Receive("ResetPrice", function(len, ply)
    if ply:IsSuperAdmin() then
        sql.Query('DELETE FROM prices_table WHERE name = "'.. net.ReadString() .. '"')
        BroadcastPrices()
    end
end)

net.Receive("PricesRequest", function(len, ply)
    BroadcastPrices()
end)

net.Receive("ChangePrice", function(len, ply)
    if ply:IsSuperAdmin() then
        local name = net.ReadString()
        local price = net.ReadInt(32)

        if price > 0 then
            if not sql.TableExists("prices_table") then
                print("Похоже это первый запуск аддона Amper_money, что же, попытаемся все настроить")
                sql.Query("CREATE TABLE prices_table( name TEXT, price NUMBER )")
            end

            if sql.Query('SELECT * FROM prices_table WHERE name = "' .. name .. '"') then
                sql.Query('UPDATE prices_table SET price = ' .. price .. ' WHERE name = "' .. name .. '"')            
            else
                sql.Query('INSERT INTO prices_table( name, price ) VALUES("' .. name .. '" , ' .. price .. ')')
            end

            BroadcastPrices()
        end
    end
end)

hook.Add("PlayerInitialSpawn", "PlayerSetupHook", function(ply, steamid, uniqueid)
    BroadcastPrices(ply)
end)