with commandes as (
    select * from {{ ref('stg_commandes_clients') }}
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
    commande_id,
    client_id,                  -- Clé vers dim_clients
    c.produit_id,                 -- Clé vers dim_produits
    canal_id,                   -- Clé vers dim_canaux
    
    -- Dates (jalons du cycle de vie)
    date_commande,
    date_expedition_prevue,
    date_livraison_prevue,
    date_livraison_effective,
    
    -- Quantités
    quantite_commandee,
    quantite_livree,
    (quantite_commandee - quantite_livree) as quantite_reliquat,
    
    -- Calculs de délais (Lead Times) en jours
    (date_expedition_prevue - date_commande) as temps_preparation_prevu_jours,
    (date_livraison_effective - date_commande) as lead_time_total_jours,
    (date_livraison_effective - date_livraison_prevue) as ecart_retard_livraison_jours,
    
    -- Statuts
    statut_commande,
    
    -- Indicateur booléen (utile pour les mesures Cube)
    case 
        when date_livraison_effective > date_livraison_prevue then true 
        else false 
    end as est_en_retard,
    -- Classe ABC historique au moment de la vente :
    coalesce(s.classe_abc, 'C') as classe_abc

from commandes c
left join segment_abc s
    on c.produit_id = s.produit_id
    and c.date_commande >= s.debut_periode
    and c.date_commande <= s.fin_periode