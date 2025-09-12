SELECT s_store_name,
         s_store_id,
         sum(case
    WHEN (d_day_name='Sunday') THEN
    ss_sales_price
    ELSE NULL end) sun_sales, sum(case
    WHEN (d_day_name='Monday') THEN
    ss_sales_price
    ELSE NULL end) mon_sales, sum(case
    WHEN (d_day_name='Tuesday') THEN
    ss_sales_price
    ELSE NULL end) tue_sales, sum(case
    WHEN (d_day_name='Wednesday') THEN
    ss_sales_price
    ELSE NULL end) wed_sales, sum(case
    WHEN (d_day_name='Thursday') THEN
    ss_sales_price
    ELSE NULL end) thu_sales, sum(case
    WHEN (d_day_name='Friday') THEN
    ss_sales_price
    ELSE NULL end) fri_sales, sum(case
    WHEN (d_day_name='Saturday') THEN
    ss_sales_price
    ELSE NULL end) sat_sales
FROM date_dim, store_sales, store
WHERE d_date_sk = ss_sold_date_sk
        AND s_store_sk = ss_store_sk
        AND s_gmt_offset = -5
        AND d_year = 2000
GROUP BY  s_store_name, s_store_id
ORDER BY  s_store_name,
         s_store_id,
        sun_sales,
        mon_sales,
        tue_sales,
        wed_sales,
        thu_sales,
        fri_sales,
        sat_sales limit 100; 
