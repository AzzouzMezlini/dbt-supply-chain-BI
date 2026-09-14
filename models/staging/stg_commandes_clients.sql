select
    vente_id as commande_id,
    client_id,
    produit_id,
    canal_id,
    date_commande::date as date_commande,
    date_expedition_prevue::date as date_expedition_prevue,
    date_livraison_estimee::date as date_livraison_prevue,
    date_livraison_reelle::date as date_livraison_effective,
    quantite_demandee as quantite_commandee,
    quantite_livree,
    prix_unitaire,
    taux_remise,
    statut_commande,
    devise_vente
from {{ source('raw', 'vente') }}