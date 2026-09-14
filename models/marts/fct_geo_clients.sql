select
    c.client_id,
    c.nom_client,
    c.ville_client,
    c.segment_client,
    count(v.commande_id) as nb_commandes,
    sum(v.quantite_livree) as total_quantite_livree,
    avg(v.ecart_jours_retard) as retard_moyen_livraison_jours
from {{ ref('stg_clients') }} c
left join {{ ref('fct_livraisons_ventes') }} v on c.client_id = v.client_id
group by 1, 2, 3, 4