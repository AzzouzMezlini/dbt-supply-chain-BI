with source as (
    select * from {{ source('raw', 'achat') }}
),
renamed as (
    select
        -- Clés (bigint)
        ligne_po_id::bigint as ligne_po_id,
        produit_id::bigint as produit_id,
        fournisseur_id::bigint as fournisseur_id,
        route_id::bigint as route_id,

        -- Dates (date)
        date_commande::date as date_commande,
        date_livraison_prevue::date as date_livraison_prevue,
        date_reception::date as date_reception,

        -- Quantités et Délais (integer/bigint)
        delai_theorique_jours::integer as delai_theorique_jours,
        quantite_commandee::bigint as quantite_commandee,
        quantite_recue::bigint as quantite_recue,

        -- Métriques financières (numeric)
        cout_unitaire::numeric(10,2) as cout_unitaire,
        cout_transport_alloue::numeric(10,2) as cout_transport_alloue,
        cout_revient_total::numeric(12,2) as cout_revient_total,
        devise_achat::text as devise_achat,
        statut_commande::text as statut_commande
    from source
)
select * from renamed