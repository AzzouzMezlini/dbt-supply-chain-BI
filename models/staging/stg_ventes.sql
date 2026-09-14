with source as (
    select * from {{ source('raw', 'vente') }}
)

select
    vente_id,
    produit_id,
    client_id,
    canal_id,
    
    -- Casts des dates
    date_commande::date as date_commande,
    date_expedition_prevue::date as date_expedition_prevue,
    date_livraison_estimee::date as date_livraison_estimee,
    date_livraison_reelle::date as date_livraison_reelle,
    
    -- Quantités
    quantite_demandee::int as quantite_demandee,
    quantite_livree::int as quantite,
    
    -- Montants financiers
    prix_unitaire::numeric(10, 2) as prix_unitaire,
    taux_remise::numeric(5, 2) as taux_remise,
    devise_vente,
    statut_commande,
    
    -- Calcul du CA Net HT basé sur la quantité livrée
    round((quantite_livree * prix_unitaire * (1 - taux_remise))::numeric, 2) as montant_net_ht

from source