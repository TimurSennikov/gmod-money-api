util.AddNetworkString("MONEYREQUEST_Amper")
util.AddNetworkString("MONEYANSWER_Amper")

function SendBalance(ply)
    net.Start("MONEYANSWER_Amper")
    net.WriteInt(ply:OP_GetMoney(), 32)
    net.Send(ply)
end

if not sql.TableExists("balance_table") then
	sql.Query("CREATE TABLE balance_table (Player TEXT, Money INTEGER)")
end

hook.Add("PlayerSay", "testHook", function(ply, text)
    local splittedString = string.Split(text, '"')

    if text == "!iwantmore" and ply:IsSuperAdmin() then
        ply:ChangeBalance(100000)
        return ""
    elseif text == "!money" then
        ply:PrintMessage(HUD_PRINTTALK, ply:OP_GetMoney())
        return ""
    elseif splittedString[1] == "!sendMoney " then
        for k, v in pairs(player.GetAll()) do
            if v:Name() == splittedString[2] then
                local amount = tonumber(splittedString[3]) or 0

                if ply:OP_GetMoney() >= amount and amount > 0 then
                    ply:ChangeBalance(-amount)
                    v:ChangeBalance(amount)

                    ply:PrintMessage(HUD_PRINTTALK, "Вы отправили " .. amount .. "$ игроку " .. v:Name() .. ".")
                    v:PrintMessage(HUD_PRINTTALK, "Вы получили " .. amount .. "$ от игрока " .. ply:Name() .. ".")
                end
            end
        end

        return ""
    elseif splittedString[1] == "!addMoney " and ply:IsSuperAdmin() then
        for k, v in pairs(player.GetAll()) do
            if v:Name() == splittedString[2] then
                local amount = tonumber(splittedString[3]) or 0

                v:ChangeBalance(amount)
            end
        end

        return ""
    elseif splittedString[1] == "!setMoney " and ply:IsSuperAdmin() then
        for k, v in pairs(player.GetAll()) do
            if v:Name() == splittedString[2] then
                local amount = tonumber(splittedString[3]) or 0

                v:SetMoney(amount)
            end
        end

        return ""
    elseif splittedString[1] == "!changeMoney " and ply:IsSuperAdmin() then
        for k, v in pairs(player.GetAll()) do
            if v:Name() == splittedString[2] then
                local amount = tonumber(splittedString[3]) or 0
                local balance = v:GetMoney()

                if balance + amount >= 0 then
                    v:SetMoney(balance + amount)
                    ply:PrintMessage(HUD_PRINTTALK, "Новый баланс игрока " .. v:Name() .. ": " .. balance + amount .. "$.")
                else
                    v:SetMoney(0)
                    ply:PrintMessage(HUD_PRINTTALK, "Новый баланс игрока " .. v:Name() .. ": 0$.")
                end
            end
        end

        return ""
    end
end)

net.Receive("MONEYREQUEST_Amper", function(len, ply)
    net.Start("MONEYANSWER_Amper")
    net.WriteInt(ply:GetMoney(), 32)
    net.WriteBool(ply.buildmode)
    net.Send(ply)
end)
