with ventes as (
    select * from {{ source('raw', 'vente') }}
),

produits as (
    select * from {{ source('raw', 'produits') }}
),

clients as (
    select * from {{ source('raw', 'entreprise_client') }}
),

final as (
    select
        v.vente_id,
        cast(v.date_commande as date) as date_commande,
        
        -- Clés et attributs Produits
        v.produit_id,
        p.nom_produit,
        p.marque,
        p.categorie,
        
        -- Clés et attributs Clients
        v.client_id,
        c.nom_client,
        c.segment_client,
        c.ville_client,
        
        -- Métriques financières et volumes
        cast(v.quantite_livree as integer) as quantite,
        cast(v.prix_unitaire as numeric(10,2)) as prix_unitaire,
        cast(v.taux_remise as numeric(5,2)) as taux_remise,
        
        -- Calcul du CA Net HT (€)
        round(
            (v.quantite_livree * v.prix_unitaire * (1 - v.taux_remise))::numeric, 
            2
        ) as montant_net_ht,

        -- Calcul de la Marge Brute (€) = CA Net HT - (Quantité * Coût de base du produit)
        round(
            ((v.quantite_livree * v.prix_unitaire * (1 - v.taux_remise)) - (v.quantite_livree * p.cout_base))::numeric,
            2
        ) as marge_brute_eur

    from ventes v
    left join produits p on v.produit_id = p.produit_id
    left join clients c on v.client_id = c.client_id
)

select * from final