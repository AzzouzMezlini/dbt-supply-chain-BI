with produits as (
    select * from {{ ref('stg_produits') }}
)
select
    produit_id,
    code_gtin_ean,
    code_produit,
    nom_produit,
    marque,
    categorie,
    unite_mesure,
    prix_base,
    cout_base,
    devise_base,
    est_actif
from produits