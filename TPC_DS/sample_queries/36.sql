SELECT sum(ss_net_profit)/sum(ss_ext_sales_price) AS gross_margin ,
        i_category ,
        i_class ,
        grouping(i_category)+grouping(i_class) AS lochierarchy ,
        rank()
    OVER ( partition by grouping(i_category)+grouping(i_class),
    CASE
    WHEN grouping(i_class) = 0 THEN
    i_category
    END
ORDER BY  sum(ss_net_profit)/sum(ss_ext_sales_price) asc) AS rank_within_parent
FROM store_sales ,date_dim d1 ,item ,store
WHERE d1.d_year = 2001
        AND d1.d_date_sk = ss_sold_date_sk
        AND i_item_sk = ss_item_sk
        AND s_store_sk = ss_store_sk
        AND s_state IN ('TN','TN','TN','TN', 'TN','TN','TN','TN')
GROUP BY  i_category,i_class WITH ROLLUP
ORDER BY  lochierarchy DESC ,case
    WHEN lochierarchy = 0 THEN
    i_category
    END ,
        rank_within_parent limit 100; 
