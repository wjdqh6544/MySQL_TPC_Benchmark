WITH ssci AS (
    SELECT ss_customer_sk AS customer_sk,
           ss_item_sk AS item_sk
    FROM store_sales
    JOIN date_dim ON ss_sold_date_sk = d_date_sk
    WHERE d_month_seq BETWEEN 1200 AND 1211
    GROUP BY ss_customer_sk, ss_item_sk
),
csci AS (
    SELECT cs_bill_customer_sk AS customer_sk,
           cs_item_sk AS item_sk
    FROM catalog_sales
    JOIN date_dim ON cs_sold_date_sk = d_date_sk
    WHERE d_month_seq BETWEEN 1200 AND 1211
    GROUP BY cs_bill_customer_sk, cs_item_sk
),
full_joined AS (
    SELECT ssci.customer_sk AS ss_customer_sk,
           ssci.item_sk AS ss_item_sk,
           csci.customer_sk AS cs_customer_sk,
           csci.item_sk AS cs_item_sk
    FROM ssci
    LEFT JOIN csci
        ON ssci.customer_sk = csci.customer_sk
       AND ssci.item_sk = csci.item_sk

    UNION ALL

    SELECT ssci.customer_sk AS ss_customer_sk,
           ssci.item_sk AS ss_item_sk,
           csci.customer_sk AS cs_customer_sk,
           csci.item_sk AS cs_item_sk
    FROM ssci
    RIGHT JOIN csci
        ON ssci.customer_sk = csci.customer_sk
       AND ssci.item_sk = csci.item_sk
    WHERE ssci.customer_sk IS NULL
)
SELECT SUM(CASE WHEN ss_customer_sk IS NOT NULL AND cs_customer_sk IS NULL THEN 1 ELSE 0 END) AS store_only,
       SUM(CASE WHEN ss_customer_sk IS NULL AND cs_customer_sk IS NOT NULL THEN 1 ELSE 0 END) AS catalog_only,
       SUM(CASE WHEN ss_customer_sk IS NOT NULL AND cs_customer_sk IS NOT NULL THEN 1 ELSE 0 END) AS store_and_catalog
FROM full_joined
LIMIT 100;
