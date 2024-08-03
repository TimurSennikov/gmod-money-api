function RequestMoneyAmount(name)
    local frame = vgui.Create("DFrame")
    local infoText = vgui.Create("DLabel", frame)
    local numEntry = vgui.Create("DTextEntry", frame)

    frame:Center()

    frame:SetSize(300,100)
    frame:SetTitle("40 ампер не лох")
    frame:MakePopup()

    infoText:SetSize(300, 50)
    infoText:Dock(TOP)
    infoText:SetText("Введите цену для " .. name)

    numEntry:Dock(BOTTOM)
    numEntry:SetPlaceholderText("100")
    function numEntry:OnEnter(v)
        net.Start("ChangePrice")

        net.WriteString(name)
        net.WriteInt(tonumber(v), 32)

        net.SendToServer()
    end
end