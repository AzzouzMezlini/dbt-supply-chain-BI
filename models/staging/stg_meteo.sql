with source as (
    select * from {{ source('raw', 'meteo_propre') }}
),
renamed as (
    select
        date::date as date_meteo,
        id_ville::text as id_ville,
        temperature_c::numeric(4,1) as temperature_c,
        precipitations_mm::numeric(5,1) as precipitations_mm,
        est_extreme::boolean as est_extreme
    from source
)
select * from renamed