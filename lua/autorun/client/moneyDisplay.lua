BalanceObj = {
    balance = 0
}

BuildObj = {
    build = false
}

function BalanceObj:GetBalance()
    net.Start("MONEYREQUEST_Amper")
    net.SendToServer()
end

net.Receive("MONEYANSWER_Amper", function()
    BalanceObj.balance = net.ReadInt(32)
    BuildObj.build = net.ReadBool()
end)

timer.Create("MoneyUpdateTimer", 1, 0, BalanceObj.GetBalance)

hook.Add("HUDPaint", "PaintMoneyAmount", function()
    draw.DrawText("У вас " .. BalanceObj.balance .. "$", "TargetID", 50 + #tostring(BalanceObj.balance) * 2, 15, color, TEXT_ALIGN_CENTER)
end)