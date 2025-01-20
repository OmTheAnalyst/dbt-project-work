{{
    config(
        materialized = 'table',
    )
}}
WITH fct_reviews AS (
    SELECT * FROM {{ ref('fct_reviews')}}
)
SELECT 
    r.*,
    CASE 
        WHEN fm.full_moon_date IS NULL THEN 'not full moon'
        ELSE 'full moon'
    END AS is_full_moon
FROM
    fct_reviews AS r 
    LEFT JOIN seed_full_moon_dates AS fm
    ON(TO_DATE(r.review_date) = DATEADD(DAY,1, fm.full_moon_date))
