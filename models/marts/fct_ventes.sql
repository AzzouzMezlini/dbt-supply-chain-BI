with ventes as (
    select *,
        -- Calcul du montant brut HT :
    (quantite * prix_unitaire)::numeric(12,2) as montant_brut_ht,
    
    -- Calcul du montant net HT (remplacement de v.montant_net_ht) :
    (quantite * prix_unitaire * (1 - coalesce(taux_remise, 0)))::numeric(12,2) as montant_net_ht
     from {{ ref('stg_ventes') }}
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