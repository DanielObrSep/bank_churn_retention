with source as (
    select *
    from {{ ref('Bank_Churn_Account_Info') }}
),

duplicate as (
    select *,
        row_number() over (
            partition by CustomerId
            order by 
                case when Balance is not null then 0 else 1 end,
                case when NumOfProducts is not null then 0 else 1 end,
                case when HasCrCard is not null then 0 else 1 end,
                case when Tenure is not null then 0 else 1 end,
                case when IsActiveMember is not null then 0 else 1 end,
                case when Exited is not null then 0 else 1 end
        ) as rn
    from source
),

filtered as (
    select *
    from duplicate
    where rn = 1
      and CustomerId is not null
      and Balance is not null
      and NumOfProducts is not null
      and HasCrCard is not null
      and Tenure is not null
      and IsActiveMember is not null
      and Exited is not null
),

renamed as (
    select
        CustomerId,
        regexp_replace(cast(Balance as varchar), '[0-9\.]', '', 'g') as currency_a,
        case 
            when regexp_replace(cast(Balance as varchar), '[^\d\.]', '', 'g') = '' then NULL
            else cast(regexp_replace(cast(Balance as varchar), '[^0-9\.]', '', 'g') as float) 
        end as balance,
        NumOfProducts,
        lower(trim(HasCrCard)) as HasCrCard,
        Tenure,
        lower(trim(IsActiveMember)) as IsActiveMember,
        Exited
    from filtered
)

select *
from renamed
