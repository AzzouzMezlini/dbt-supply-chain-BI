with suivi as (
    select * from {{ ref('fct_suivi_commandes') }}
)

select
    commande_id,
    client_id,
    nom_client,
    segment_client,
    ville_client,
    produit_id,
    nom_produit,
    categorie,
    date_commande,
    date_livraison_prevue,
    date_livraison_effective,
    quantite_commandee,
    quantite_livree,
    coalesce(ecart_prevision_jours, 0) as ecart_jours_retard,
    statut_suivi_commande as statut_logistique
from suivi