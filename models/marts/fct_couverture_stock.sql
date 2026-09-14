with stock as (
    select * from {{ ref('stg_stock_journalier') }}
),

produits as (
    select * from {{ ref('stg_produits') }}
),

ventes_30j as (
    -- Calcul de la moyenne des ventes journalières sur les 30 derniers jours par produit
    select
        produit_id,
        coalesce(sum(quantite) / 30.0, 0) as vente_moyenne_jour
    from {{ ref('stg_ventes') }}
    where date_commande >= (select max(date_stock) - interval '30 days' from stock)
    group by produit_id
),

final as (
    select
        s.date_stock,
        s.produit_id,
        p.nom_produit,
        p.marque,
        p.categorie,
        
        -- Quantités de stock
        s.quantite_en_stock,
        s.quantite_en_transit,
        s.quantite_reservee,
        s.quantite_disponible,
        
        -- Valeur financière du stock au coût
        round((s.quantite_en_stock * p.cout_base)::numeric, 2) as valeur_stock_cout,
        
        -- Vente moyenne par jour et Couverture en jours
        coalesce(v.vente_moyenne_jour, 0) as vente_moyenne_jour,
        case 
            when coalesce(v.vente_moyenne_jour, 0) > 0 
            then round((s.quantite_disponible / v.vente_moyenne_jour)::numeric, 1)
            else null
        end as couverture_jours,
        
        -- Catégorisation du statut du stock
        case 
            when s.quantite_disponible <= 0 then 'Rupture'
            when coalesce(v.vente_moyenne_jour, 0) > 0 and (s.quantite_disponible / v.vente_moyenne_jour) < 15 then 'Alerte Stock Bas'
            when coalesce(v.vente_moyenne_jour, 0) > 0 and (s.quantite_disponible / v.vente_moyenne_jour) > 90 then 'Surstock'
            else 'Optimal'
        end as statut_stock

    from stock s
    left join produits p on s.produit_id = p.produit_id
    left join ventes_30j v on s.produit_id = v.produit_id
)

select * from final