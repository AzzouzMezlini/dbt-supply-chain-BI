with achats_geo as (
    select
        f.fournisseur_id,
        f.nom_fournisseur,
        f.ville_fournisseur as ville_etape,
        f.pays_fournisseur as pays_etape,
        r.ville_origine,
        r.ville_destination,
        r.mode_transport,
        count(a.ligne_po_id) as nb_commandes_achat,
        sum(a.montant_total_achat) as montant_total_achats,
        avg(a.ecart_retard_livraison_jours) as retard_moyen_achats_jours
    from {{ ref('fct_achat') }} a
    left join {{ ref('stg_fournisseurs') }} f on a.fournisseur_id = f.fournisseur_id
    left join {{ ref('stg_routes_achat') }} r on a.route_id = r.route_id
    group by 1, 2, 3, 4, 5, 6, 7
),
ventes_geo as (
    select
        ville_client as ville_etape,
        segment_client,
        count(distinct commande_id) as nb_commandes_ventes,
        sum(quantite_livree) as total_quantite_livree,
        avg(ecart_jours_retard) as retard_moyen_ventes_jours
    from {{ ref('fct_livraisons_ventes') }}
    group by 1, 2
)
select 
    gen_random_uuid() as id_geo_ligne,
    'AMONT_FOURNISSEUR' as type_flux,
    ville_origine,
    ville_etape,
    pays_etape,
    mode_transport,
    nb_commandes_achat as volume_commandes,
    montant_total_achats as valeur_financiere,
    retard_moyen_achats_jours as retard_moyen_jours
from achats_geo

union all

select 
    gen_random_uuid() as id_geo_ligne,
    'AVAL_CLIENT' as type_flux,
    null as ville_origine,
    ville_etape,
    null as pays_etape,
    segment_client as mode_transport,
    nb_commandes_ventes as volume_commandes,
    total_quantite_livree as valeur_financiere,
    retard_moyen_ventes_jours as retard_moyen_jours
from ventes_geo