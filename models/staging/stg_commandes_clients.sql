with source as (
    select * from {{ source('raw', 'vente') }} -- ou raw.commandes_clients selon la source
),
renamed as (
    select
        -- Clés (bigint)
        vente_id::bigint as commande_id,
        client_id::bigint as client_id,
        produit_id::bigint as produit_id,
        canal_id::bigint as canal_id,

        -- Dates (date)
        date_commande::date as date_commande,
        date_expedition_prevue::date as date_expedition_prevue,
        date_livraison_estimee::date as date_livraison_prevue,
        date_livraison_reelle::date as date_livraison_effective,

        -- Quantités (integer)
        quantite_demandee::integer as quantite_commandee,
        quantite_livree::integer as quantite_livree,

        -- Métriques financières (numeric)
        prix_unitaire::numeric(10,2) as prix_unitaire,
        taux_remise::numeric(5,2) as taux_remise,
        
        -- Attributs texte
        devise_vente::text as devise_vente,
        statut_commande::text as statut_commande
    from source
)
select * from renamed