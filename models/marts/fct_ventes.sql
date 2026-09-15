with ventes as (
    select *,
        -- Calcul du montant brut HT :
    (quantite * prix_unitaire)::numeric(12,2) as montant_brut_ht,
    
    -- Calcul du montant net HT (remplacement de v.montant_net_ht) :
    (quantite * prix_unitaire * (1 - coalesce(taux_remise, 0)))::numeric(12,2) as montant_net_ht
     from {{ ref('stg_ventes') }}
),
 produits as (
    select 
        produit_id,
        cout_base
    from {{ ref('stg_produits') }}
),
segment_abc as (
    select 
        produit_id,
        debut_periode::date as debut_periode,
        fin_periode::date as fin_periode,
        classe_abc
    from {{ ref('stg_segment_abc') }}
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
    round((v.montant_net_ht - (v.quantite * p.cout_base))::numeric, 2) as marge_brute_eur,
    -- Classe ABC historique au moment de la vente :
    coalesce(s.classe_abc, 'C') as classe_abc
from ventes v
-- left join produits p on v.produit_id = p.produit_id
left join segment_abc s
    on v.produit_id = s.produit_id
    and v.date_commande >= s.debut_periode
    and v.date_commande <= s.fin_periode
