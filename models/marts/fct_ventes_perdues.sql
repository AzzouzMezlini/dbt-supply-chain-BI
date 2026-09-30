select
    perte_id,
    produit_id,
    client_id,
    canal_id,
    date_commande,
    quantite_manquante,
    chiffre_affaires_perdu,
    motif_rupture
from {{ ref('stg_ventes_perdues') }}