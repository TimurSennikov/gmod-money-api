include("dmenu_all.lua")

local OldCreateContentIcon_Amper = spawnmenu.CreateContentIcon

local prices

net.Receive("Prices", function()
    prices = net.ReadTable()

    RunConsoleCommand("spawnmenu_reload")
end)

function ChangePrice(name, price)
    net.Start("ChangePrice")
    net.WriteString(name)
    net.WriteInt(price, 32)
    net.SendToServer()
end

function ResetPrice(name)
    net.Start("ResetPrice")
    net.WriteString(name)
    net.SendToServer()
end

function spawnmenu.CreateContentIcon(type, pnl, data)
    local ic = OldCreateContentIcon_Amper(type, pnl, data)

    local pricedTool = false

    if prices then
        for k, v in pairs(prices) do
            if data["spawnname"] == v["name"] then
                local icon = vgui.Create("DImage", ic)
                icon:SetPos(10, 5)
                icon:SetSize(16, 16)
                icon:SetImage(OnePrint.Cfg.MoneyIcon)

                local text = vgui.Create("DLabel", ic)
                text:SetPos(25, 5)
                text:SetColor(Color(0, 255, 0))

                text:SetText(v["price"])

                pricedTool = true
            end
        end
    end

    ic.OldOpenMenuExtra_Amper = ic.OldOpenMenuExtra_Amper or ic.OpenMenuExtra

    function ic:OpenMenuExtra(menu)
        self:OldOpenMenuExtra_Amper(menu)

        if LocalPlayer():IsSuperAdmin() then
            menu:AddSpacer()

            menu:AddOption("Изменить цену", function()
                RequestMoneyAmount(data["spawnname"])
            end)

            if pricedTool then
                menu:AddOption("Удалить цену", function()
                    ResetPrice(data["spawnname"])
                end)
            end
        end

    end
    return ic
end