include("moneyTools_obj.lua")
include("balance_sql.lua")

local priceTools_local = priceTools

function ProcessItemGive(ply, weapon)
    priceTools_local:RefreshPrices()

    local balance = ply:OP_GetMoney()
    local price = priceTools_local:seekForPrice(weapon)

    if price > 0 then
        if balance >= price then
            ply:SetMoney(balance - price)
            return true
        else
            ply:PrintMessage(HUD_PRINTTALK, "Вам не хватает " .. price - balance .. "$ на покупку ".. weapon .. ".")
            return false
        end
    end

    return true
end

function ProcessVehicleSpawn(ply, model, name)
    priceTools_local:RefreshPrices()

    local balance = ply:OP_GetMoney()
    local price = priceTools_local:seekForPrice(name)

    if price > 0 then
        if balance >= price then
            ply:SetMoney(balance - price)
            return true
        else
            ply:PrintMessage(HUD_PRINTTALK, "Вам не хватает " .. price - balance .. "$ на покупку ".. name .. ".")
            return false
        end
    end

    return true
end

function ProcessKill(victim, inflictor, attacker)
    if IsValid(victim) and IsValid(attacker) and victim:IsPlayer() and attacker:IsPlayer() and victim != attacker then
        attacker:ChangeBalance(100)
    end
end

function ProcessTool(ply, tr, toolname, cool, button)
    for k, v in pairs({[0] = "colour", [1] = "material"}) do
        if toolname == v then
            if tr.Entity:GetClass() == "oneprint" then
                return false
            end
        end
    end
    return true
end

hook.Add("CanTool", "NoPaint-Hook", ProcessTool)

hook.Add("PlayerGiveSWEP", "WeaponBuyHook", ProcessItemGive)
hook.Add("PlayerSpawnSWEP", "WeaponBuy-SpawnHook", ProcessItemGive)
hook.Add("PlayerSpawnSENT", "SENTBuy-SpawnHook", ProcessItemGive)

hook.Add("PlayerSpawnVehicle", "VehicleSpawn-BuyHook", ProcessVehicleSpawn)

hook.Add("PlayerDeath", "PlayerDeath-Hook", ProcessKill)