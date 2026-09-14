with ventes as (
    select * from {{ ref('stg_ventes') }}
),
produits as (
    select * from {{ ref('stg_produits') }}
)
select
    v.vente_id,
    v.date_commande,
    v.produit_id,       -- Clé vers dim_produits
    v.client_id,        -- Clé vers dim_clients
    v.canal_id,
    v.quantite as quantite_livree,
    v.prix_unitaire,
    v.taux_remise,
    v.montant_net_ht,
    round((v.montant_net_ht - (v.quantite * p.cout_base))::numeric, 2) as marge_brute_eur
from ventes v
left join produits p on v.produit_id = p.produit_id