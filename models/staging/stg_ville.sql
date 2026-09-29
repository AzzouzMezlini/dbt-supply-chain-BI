with source as (
    select * from {{ source('raw', 'villes') }}
),
renamed as (
    select
        id_ville::bigint as id_ville,
        nom_ville_source::text as nom_ville_source,
        nom_ville_officiel::text as nom_ville_officiel,
        code_insee::text as code_insee,
        population::bigint as population,
        latitude::double precision as latitude,
        longitude::double precision as longitude
    from source
)
select * from renamed
