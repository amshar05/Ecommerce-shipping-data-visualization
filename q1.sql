select 

h.order_month
, h.order_year
, a.state
, a.zip
, a.country
, c.name as city 
, h.normalized_ship_method
, sum(QtyOrdered) as quantity
, count(distinct o.orderid) as number_orders


from PulseCommerceOrders.dbo.orderdetail o left join PulseCommerceOrders.dbo.orderaddress a on 

o.orderid = a.orderid 

left join  

(select 
id
,datename(month, orderdatetime) as order_month
, datepart(year, orderdatetime) as order_year
, case
when shippingname like '%next%' then 'Next_Day'
when shippingname like '%1 day%' then 'Next_Day'
when shippingname like '%priority%' then 'Next_Day'
when shippingname like '%express%' then 'Next_Day'
when shippingname like '%overnight%' then 'Next_Day'
when shippingname like '%media%' then 'Home_Delivery'
when shippingname like '%airmail%' then 'Next_Day'
when shippingname like '%2nd DAY%' then '2_Day'
when shippingname like '%second%' then '2_Day'
when shippingname like '%two-day%' then '2_Day'
when shippingname like '%2 DAY%' then '2_Day'
when shippingname like '%2-DAY%' then '2_Day'
when shippingname like '%2nd%' then '2_Day'
when shippingname like '%2-4%' then '2_Day'
when shippingname like '%2-5%' then '2_Day'
when shippingname like '%3-day%' then '3-Day'
when shippingname like '%ground%' then 'Ground'
when shippingname like '%priority%' then 'Home_Delivery'
when shippingname like '%registered%' then 'Home_Delivery'
when shippingname like '%shipped%' then 'Ground'
when shippingname like '%Expedited %' then 'Ground'
when shippingname like '%order%' then 'Ground'
when shippingname like '%standard %' then 'Ground'
when shippingname like '%class%' then 'Ground'
when shippingname like '%home%' then 'Home_Delivery'
when shippingname like '%airmail%' then 'Home_Delivery'
when shippingname like '%dropped%' then 'Home_Delivery'
when shippingname like '%first class%' then 'Home_Delivery'
when shippingname like '%invoice%' then 'Home_Delivery'
when shippingname like '%drop%' then 'Home_Delivery'
when shippingname like '%saver%' then 'ground_saver'
when shippingname like '%cheap%' then 'ground_saver'
when shippingname like '%rma shipping%' then 'ground_saver'
when shippingname like '%economy%' then 'ground_saver'
when shippingname like '%flat rate%' then 'ground_saver'
when shippingname like '%pick%' then 'ground_saver'
when shippingname like '%add%' then 'ground_saver'
when shippingname like '%post%' then 'ground_saver'
when shippingname like '%vomitor%' then 'ground_saver'
else 'Ground'
end as normalized_ship_method
from 

PulseCommerceOrders.dbo.OrderHeader) h

on h.id = o.orderid

left join PulseCommerceOrders.dbo.city c on 

a.cityid = c.id

group by 
h.order_month
, h.order_year
, a.state
, a.zip
, a.country
, c.name
, h.normalized_ship_method