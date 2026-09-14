with source as (
    select * from {{ source('raw', 'stock_journalier') }}
),
renamed as (
    select
        produit_id::bigint as produit_id,
        date::date as date_stock,
        
        -- Quantités
        stock_debut_journee::integer as stock_debut_journee,
        quantite_en_stock::integer as quantite_en_stock,
        quantite_en_transit::integer as quantite_en_transit,
        quantite_reservee::integer as quantite_reservee,
        (quantite_en_stock - quantite_reservee)::integer as quantite_disponible,
        
        -- Métriques financières
        valeur_stock_fin_journee::numeric(12,2) as valeur_stock_fin_journee,
        cout_possession_journalier::numeric(10,2) as cout_possession_journalier,
        
        -- Statut
        est_en_rupture::boolean as est_en_rupture
    from source
)
select * from renamed