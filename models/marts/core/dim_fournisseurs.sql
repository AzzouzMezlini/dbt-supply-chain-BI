with fournisseurs as (
    select * from {{ ref('stg_fournisseurs') }}
)
select
    fournisseur_id,
    nom_fournisseur,
    id_ville_fournisseur,
    pays_fournisseur,
    est_actif
from fournisseurs