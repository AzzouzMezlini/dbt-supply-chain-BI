with source as (
    select * from {{ source('raw', 'canal_vente') }}
),
renamed as (
    select
        canal_id::bigint as canal_id,
        nom_canal::text as nom_canal,
        type_execution::text as type_execution,
        mode_expedition::text as mode_expedition,
        sla_jours::integer as sla_jours
    from source
)
select * from renamed