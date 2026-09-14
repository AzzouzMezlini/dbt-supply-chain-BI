with source as (
    select * from {{ source('raw', 'route_achat') }}
),
renamed as (
    select
        route_id::bigint as route_id,
        fournisseur_id::bigint as fournisseur_id,
        ville_origine::text as ville_origine,
        ville_destination::text as ville_destination,
        mode_transport::text as mode_transport,
        
        -- Délais et Coûts
        delai_moyen_jours::integer as delai_moyen_jours,
        delai_ecart_type_jours::numeric(10,2) as delai_ecart_type_jours,
        cout_expedition_forfaitaire::numeric(10,2) as cout_expedition_forfaitaire
    from source
)
select * from renamed