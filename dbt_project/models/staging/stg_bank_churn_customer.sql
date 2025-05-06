with source as (
    select * 
    from {{ ref('Bank_Churn_Customer_Info')}}
),

deduplicated as (
    select *,
        row_number() over (
            partition by CustomerId
            order by 
                case when Surname is not null then 0 else 1 end,
                case when CreditScore is not null then 0 else 1 end,
                case when "Geography" is not null then 0 else 1 end,
                case when Gender is not null then 0 else 1 end,
                case when Age is not null then 0 else 1 end,
                case when Tenure is not null then 0 else 1 end,
                case when EstimatedSalary is not null then 0 else 1 end
        ) as rn
    from source
),


filtered as (
    select *
    from deduplicated
    where rn = 1
      and CustomerId is not null
      and Surname is not null
      and CreditScore is not null
      and "Geography" is not null
      and Gender is not null
      and Age is not null
      and Tenure is not null
      and EstimatedSalary is not null
      and EstimatedSalary > 0
),

renamed as (
    select
        CustomerId,
        lower(trim(Surname)) as Surname,
        CreditScore,
        case 
            when lower(trim("Geography")) = 'fra' then 'french'
            else lower(trim("Geography"))
        end as "Geography",
        lower(trim(Gender)) as Gender,
        Age,
        Tenure,
        regexp_replace(cast(EstimatedSalary as varchar), '[0-9\.]', '', 'g') as currency_c,
        case 
            when regexp_replace(cast(EstimatedSalary as varchar), '[^\d\.]', '', 'g') = '' then NULL
            else cast(regexp_replace(cast(EstimatedSalary as varchar), '[^0-9\.]', '', 'g') as float) 
        end as EstimatedSalary
    from filtered
)

Select * from renamed