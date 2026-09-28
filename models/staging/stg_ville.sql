with source as (
    select * from {{ source('raw', 'ville') }}
),
renamed as (
    select
        ville_id::bigint as ville_id,
        nom_ville::text as nom_ville,
        region::text as region,
        pays::text as pays
    from source
)
select * from renamed
