select
    fournisseur_id,
    nom_fournisseur,
    ville_fournisseur,
    pays_fournisseur,
    est_actif
from {{ source('raw', 'fournisseur') }}