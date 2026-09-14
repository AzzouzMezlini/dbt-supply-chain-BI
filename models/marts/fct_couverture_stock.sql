with stock as (
    select * from {{ ref('stg_stock_journalier') }}
),
produits as (
    select * from {{ ref('stg_produits') }}
)
select
    s.date_stock,
    s.produit_id,       -- Clé vers dim_produits
    s.quantite_en_stock,
    s.quantite_en_transit,
    s.quantite_reservee,
    s.quantite_disponible,
    round((s.quantite_en_stock * p.cout_base)::numeric, 2) as valeur_stock_cout
from stock s
left join produits p on s.produit_id = p.produit_id