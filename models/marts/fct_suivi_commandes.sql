with commandes as (
    select * from {{ ref('stg_commandes_clients') }}
),
clients as (
    select * from {{ ref('stg_clients') }}
),
produits as (
    select * from {{ ref('stg_produits') }}
)

select
    c.commande_id,
    c.client_id,
    cl.nom_client,
    cl.segment_client,
    cl.ville_client,
    c.produit_id,
    p.nom_produit,
    p.categorie,
    c.date_commande,
    c.date_expedition_prevue,
    c.date_livraison_prevue,
    c.date_livraison_effective,
    c.quantite_commandee,
    c.quantite_livree,
    case 
        when c.date_expedition_prevue is not null and c.date_commande is not null 
        then (c.date_expedition_prevue - c.date_commande)
        else null 
    end as temps_preparation_jours,
    case 
        when c.date_livraison_effective is not null and c.date_expedition_prevue is not null 
        then (c.date_livraison_effective - c.date_expedition_prevue)
        else null 
    end as temps_transport_jours,
    case 
        when c.date_livraison_effective is not null and c.date_commande is not null 
        then (c.date_livraison_effective - c.date_commande)
        else null 
    end as lead_time_total_jours,
    case 
        when c.date_livraison_effective is not null and c.date_livraison_prevue is not null 
        then (c.date_livraison_effective - c.date_livraison_prevue)
        else null 
    end as ecart_prevision_jours,
    case 
        when c.date_livraison_effective is null then 'En Cours'
        when c.date_livraison_effective <= c.date_livraison_prevue and c.quantite_livree >= c.quantite_commandee then 'Parfait (Dans les temps & Complet)'
        when c.date_livraison_effective <= c.date_livraison_prevue then 'À l''heure (Incomplet)'
        else 'En Retard'
    end as statut_suivi_commande
from commandes c
left join clients cl on c.client_id = cl.client_id
left join produits p on c.produit_id = p.produit_id