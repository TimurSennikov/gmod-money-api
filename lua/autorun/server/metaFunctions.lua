local mPlayer = FindMetaTable("Player")

function mPlayer:SetMoney(amount)
    if not sql.TableExists("balance_table") then
        sql.Query("CREATE TABLE balance_table (Player TEXT, Money INTEGER)")
    end

    local steamID = sql.SQLStr(self:SteamID())

    local data = sql.Query("SELECT Money FROM balance_table WHERE Player = " .. steamID)

    if data then
        sql.Query("UPDATE balance_table SET MONEY = " .. amount .. " WHERE Player = " .. steamID)
    else
        sql.Query("INSERT INTO balance_table(Player, Money) VALUES(" .. steamID .. ", " .. amount .. ")")
    end
end

function mPlayer:GetMoney()
    if CLIENT then
        return BalanceObj.balance
    elseif SERVER then
        local res = sql.Query("SELECT Money FROM balance_table WHERE Player = " .. sql.SQLStr(self:SteamID()))

        if res then
            return tonumber(res[1]["Money"])
        else
            return 0
        end
    end
end