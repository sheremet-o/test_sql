-- Постройте запрос, который покажет, в каком городе чаще покупают товары, которые соответствуют условию:
-- Одежда дороже 5000р или мебель дороже 20000р.
-- Частота это число товаров / общее число клиентов в городе

With FashionItems as (
-- Выбираем одежду стоимостью дороже 5000
    Select Client_info.City, Order_info.Item
    From Order_info
    Join Client_info on Order_info.ClientID = Client_info.ClientID
    Join Items_Fashion on Order_info.Item = Items_Fashion.Item
    Where Items_Fashion.Cost > 5000),
FurnitureItems as (
-- Выбираем мебель стоимостью дороже 20000
    Select Client_info.City, Order_info.Item
    From Order_info 
    Join Client_info on Order_info.ClientID = Client_info.ClientID
    Join Items_Furniture on Order_info.Item = Items_Furniture.Item
    Where Items_Furniture.Cost > 20000),
TotalItems as (
-- Объединяем товары
    Select City,
    Count (Item) as ItemCount
    From 
        (Select City, Item from FashionItems
         Union all
         Select City, Item from FurnitureItems) as AllItems
    Group by City),
TotalClients as (
-- Считаем общее число клиентов в каждом городе
    Select City,
        Count(distinct ClientID) as ClientCount
    From Client_info
    Group by City)

Select 
-- Вычисляем частоту
    TotalItems.City,
    TotalItems.ItemCount,
    TotalClients.ClientCount,
    Cast(TotalItems.ItemCount as float) / nullif(TotalClients.ClientCount, 0) as PurchaseFrequency
From TotalItems
Join TotalClients on TotalItems.City = TotalClients.City
Order by PurchaseFrequency desc;