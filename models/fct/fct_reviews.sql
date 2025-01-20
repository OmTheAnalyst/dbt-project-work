{{
    config(
        materialized = 'incremental',
        on_schema_change = 'fail'
    )
}}
WITH src_reviews AS (
    SELECT * FROM {{ ref('src_reviews') }}
)
SELECT 
    {{ dbt_utils.generate_surrogate_key(['listing_id', 'review_date', 'reviewer_name', 'review_text']) }} AS review_id,
* 
FROM src_reviews
WHERE review_text is NOT NULL
{% if is_incremental() %}
    AND review_date > (select max(review_date) from {{ this }})
{% endif %}

/* incremental file, we configure the query to fetch only 
new data based on the most recent review_date. 
It avoids fetching or reprocessing data that 
has already been added to the table. */