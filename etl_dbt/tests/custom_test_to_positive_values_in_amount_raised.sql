custom test

select
    date_id,
    sum(amount_raised) as total_amount
from {{ ref('fact_pe') }}
group by 1
having not(total_amount >= 0)
