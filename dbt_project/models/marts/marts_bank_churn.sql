{{ config(
    materialized='view'
) }}

with customers as (
    select *
    from {{ ref('stg_bank_churn_customer') }}
),

accounts as (
    select *
    from {{ ref('stg_bank_churn_account') }}
)

select
    c.customerid,
    c.surname,
    c.creditscore,
    c.geography,
    c.gender,
    c.age,
    c.tenure,
    a.numofproducts,
    a.hascrcard,
    a.isactivemember,
    concat(a.currency_a, ' ', cast(a.balance as varchar)) as balance,
    concat(c.currency_c, ' ', cast(c.estimatedsalary as varchar)) as estimatedsalary,
    a.exited
from customers as c
join accounts as a
    using (customerid)
