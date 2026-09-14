with achats as (
    select * from {{ ref('stg_achats') }}
)
select
    ligne_po_id,
    produit_id,         -- Clé vers dim_produits
    fournisseur_id,     -- Clé vers dim_fournisseurs
    route_id,           -- Clé vers stg_routes_achat / dim_routes
    date_commande,
    date_reception,
    delai_livraison_jours,
    quantite_commandee,
    quantite_recue,
    (quantite_commandee - quantite_recue) as quantite_non_livree,
    cout_unitaire,
    montant_total_achat,
    devise_achat
from achats