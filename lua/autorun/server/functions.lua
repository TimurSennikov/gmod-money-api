function SetPMoney(ply, amount)
    if not sql.TableExists("balance_table") then
        sql.Query("CREATE TABLE balance_table (Player TEXT, Money INTEGER)")
    end

    local steamID = sql.SQLStr(ply:SteamID())

    local data = sql.Query("SELECT Money FROM balance_table WHERE Player = " .. steamID)

    if data then
        sql.Query("UPDATE balance_table SET MONEY = " .. amount .. " WHERE Player = " .. steamID)
    else
        sql.Query("INSERT INTO balance_table(Player, Money) VALUES(" .. steamID .. ", " .. amount .. ")")
    end
end

function GetPMoney(ply)
    if CLIENT then
        return BalanceObj.balance
    elseif SERVER then
        return tonumber(sql.Query("SELECT Money FROM balance_table WHERE Player = " .. sql.SQLStr(ply:SteamID()))[1]["Money"]) or 0
    end
end