with source as (
    select * from {{ source('raw', 'evenements_speciaux') }}
),
renamed as (
    select
        evenement_id::bigint as evenement_id,
        date::date as date_evenement,
        nom_evenement::text as nom_evenement,
        type_evenement::text as type_evenement,
        ville::text as ville,
        niveau_impact::text as niveau_impact
    from source
)
select * from renamed