priceTools = {
    prices = {}
}

-- синхронизирует таблицу с бд сервера
function priceTools:RefreshPrices()
    self.prices = sql.Query("SELECT * FROM prices_table")
end

-- ищет цену на предмет по его spawnname, возвращает: цену на предмет (если найдена), иначе 0.
function priceTools:seekForPrice(spawnname)
    if self.prices then
        for k, v in pairs(self.prices) do
            if v["name"] == spawnname then
                return tonumber(v["price"])
            end
        end
    end

    return 0
end