 -- QUESTION 1
  use orders;
  select product_class_code, product_id, product_desc,product_price, -- asked as in the question
  case -- usimg this since we were give 3 specified conditions
		WHEN product_class_code = 2050 then product_price + 2000 
        WHEN product_class_code = 2051 then product_price + 500
        when product_class_code = 2052 then product_price + 600
        else product_price -- if none of the above conditions are satisfied will return this statement
  END as new_prod_price
  from product order by product_class_code desc; -- observing 60 rows output in descending order
  
  -- QUESTION 2
  select pc.product_class_desc, p.product_id,p.product_desc, p.product_quantity_avail,p.product_class_code,pc.product_class_code,
  CASE -- USING SINCE WE HAVE MANY CONDITION THAT IS TO BE CHECKED 
  WHEN p.product_quantity_avail = 0 then 'OUT OF STOCK' 
    when pc.product_class_desc in ('computers', 'electronics') then 
    case when p.product_quantity_avail <= 10 then 'low stock'
		 when p.product_quantity_avail between 11 and 30 then 'in stock'
		 when p.product_quantity_avail >= 31 then 'ENOUGH STOCK'
    end
     when pc.product_class_desc in ('stationary','clothes') then 
     case when p.product_quantity_avail <= 20 then 'low stock'
     when p.product_quantity_avail between 21 and 80 then 'in stock'
     when p.product_quantity_avail > 81 then 'enough stuck'
     end
     when pc.product_class_desc not in ('computers', 'electronics', 'stationary','clothes') then
     case when p.product_quantity_avail <= 15 then 'low stock'
     when p.product_quantity_avail between 16 and 50 then 'in stock'
     when p.product_quantity_avail >= 51 then 'enough stock'
     end
     END as status from product p join product_class pc using(product_class_code);-- ending condition will give us status of each category.
 
  -- QUESTION 3    

select city, country from address
 where country not in('Malaysia', 'USA') -- to exclude values in USA and Malaysia
 group by country 
 having count(city)>1; -- counting countries with more than one city
 
 -- QUESTION 4 
 use orders;
 select oc.customer_id, concat( oc.customer_fname, ' ', oc.customer_lname) as customer_fullname,oc.customer_email,
     a.city, a.pincode, oh.order_id, oh.order_date, pc.product_class_desc, p.product_desc, p.product_quantity_avail, p.product_price
   , (p.product_price*order_items.product_quantity) as subtotal from online_customer oc join address a using(address_id) join order_header oh using(customer_id) join order_items using(order_id)
     join product p using(product_id) join product_class pc using(product_class_code)
     having pincode not like('%0%')
     order by customer_fullname, order_date, subtotal; --  gives us pincode values with no zero
     
	-- QUESTION 5:
    select oi.product_id, p.product_desc, sum(oi.product_quantity) as total_product from --  summing  product as given in question
    (select order_id from order_items where product_id = 201) as temp -- **subquery required for including this information since we want the result involving this id
    join order_items oi on temp.order_id = oi.order_id
    join product p
    on p.product_id = oi.product_id
    group by oi.product_id 
    order by total_product desc limit 1; -- one row is returned due to single row subquery
    
     
     -- QUESTION 6
     select oc.customer_id, concat( oc.customer_fname, ' ', oc.customer_lname) as customer_fullname,oc.customer_email, 
     oh.order_id,p.product_desc,oi.product_quantity, product_class_code, (p.product_price*oi.product_quantity) as subtotal 
     from online_customer oc  left join order_header oh using(customer_id) left join order_items oi using(order_id) left join product p using(product_id);
     -- WE GET 225 ROWS
    
    -- QUESTION 7
     select carton_id, (width*height*len) as carton_vol from carton 
     where width*height*len >=(select p.width*p.height*p.len*oi.product_quantity from product p
     join order_items oi using(product_id) 
     group by oi.order_id
     having oi.order_id = 10006) -- specify order_id for optimum carton_id volume for given order_id 10006(subquery used)
     order by carton_vol ASC limit 1; -- specify to limit carton value to 1(aggregate function)
     
     -- QUESTION 8
     use orders;
     select oc.customer_id, concat( oc.customer_fname, ' ', oc.customer_lname) as customer_fullname,oc.customer_email, 
     oh.order_id,oh.order_status, sum(oi.product_quantity) from online_customer oc join order_header oh using(customer_id)
     join order_items oi using(order_id) -- basic join function 
     group by  order_id
     having sum(oi.product_quantity) > 10 -- to find product quantity greater than 10
     AND order_status = 'shipped';
     
      -- QUESTION 9    
     select oc.customer_id, concat( oc.customer_fname, ' ', oc.customer_lname) as customer_fullname, oh.order_id, oi.product_quantity as total_quantity, oh.order_status
     from online_customer oc 
     join order_header oh using(customer_id) 
     join order_items oi using(order_id) 
     group by order_id
     having order_id > 10060 -- used to specify which order id we need 
     AND order_status = 'shipped'; -- return this statement as shipped if above condition is proved true
     
     -- QUESTION 10     
     select pc.product_class_desc, sum(oi.product_quantity) as total_quantity, (oi.product_quantity*p.product_price) 
     as total_value, a.country -- selecting data as per the the given question
     from address a join online_customer oc using(address_id) -- use join to add different data
     join order_header oh using(customer_id) 
     join order_items oi using(order_id)
     join product p using(product_id)
     join product_class pc using(product_class_code)
     where a.country not in('India', 'USA') order by total_quantity desc; -- to specify the maximum product shipped to  a country using have, not in, order by
     
     
     
     
     