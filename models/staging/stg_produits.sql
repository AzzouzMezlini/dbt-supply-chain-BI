with source as (
    select * from {{ source('raw', 'produits') }}
),
renamed as (
    select
        produit_id::bigint as produit_id,
        code_gtin_ean::text as code_gtin_ean,
        code_produit::text as code_produit,
        nom_produit::text as nom_produit,
        marque::text as marque,
        categorie::text as categorie,
        unite_mesure::text as unite_mesure,
        devise_base::text as devise_base,
        
        -- Prix et Coûts
        prix_base::numeric(10,2) as prix_base,
        cout_base::numeric(10,2) as cout_base,
        taux_cout_possession::numeric(5,2) as taux_cout_possession,
        
        est_actif::boolean as est_actif
    from source
)
select * from renamed