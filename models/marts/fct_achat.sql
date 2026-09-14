with achats as (
    select * from {{ ref('stg_achats') }}
),
raw_achats as (
    select 
        ligne_po_id,
        date_livraison_prevue::date as date_livraison_prevue,
        quantite_non_livree,
        cout_transport_alloue,
        cout_revient_total,
        statut_commande
    from {{ source('raw', 'achat') }}
),
produits as (
    select * from {{ ref('stg_produits') }}
),
fournisseurs as (
    select * from {{ source('raw', 'fournisseur') }}
),
routes as (
    select 
        route_id, 
        mode_transport 
    from {{ source('raw', 'route_achat') }}
)

select
    a.ligne_po_id,
    a.produit_id,
    p.code_produit,
    p.nom_produit,
    p.categorie,
    p.marque,
    a.fournisseur_id,
    f.nom_fournisseur,
    f.pays_fournisseur,
    a.route_id,
    r.mode_transport,
    a.date_commande,
    ra.date_livraison_prevue,
    a.date_reception,
    a.delai_livraison_jours,
    case 
        when a.date_reception is not null and ra.date_livraison_prevue is not null 
        then (a.date_reception::date - ra.date_livraison_prevue::date)
        else null 
    end as ecart_retard_livraison_jours,
    a.quantite_commandee,
    a.quantite_recue,
    ra.quantite_non_livree,
    a.cout_unitaire,
    ra.cout_transport_alloue,
    ra.cout_revient_total,
    a.montant_total_achat,
    ra.statut_commande,
    a.devise_achat
from achats a
left join raw_achats ra on a.ligne_po_id = ra.ligne_po_id
left join produits p on a.produit_id = p.produit_id
left join fournisseurs f on a.fournisseur_id = f.fournisseur_id
left join routes r on a.route_id = r.route_id