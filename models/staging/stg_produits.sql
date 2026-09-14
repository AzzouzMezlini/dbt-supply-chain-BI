with source as (
    select * from {{ source('raw', 'produits') }}
)

select
    produit_id,
    code_gtin_ean,
    code_produit,
    nom_produit,
    marque,
    categorie,
    unite_mesure,
    est_actif,
    devise_base,
    prix_base::numeric(10, 2) as prix_base,
    cout_base::numeric(10, 2) as cout_base, -- <-- Virgule ajoutée ici !
    taux_cout_possession::numeric(5, 2) as taux_cout_possession
from source