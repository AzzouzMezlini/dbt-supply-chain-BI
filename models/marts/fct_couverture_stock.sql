with stock as (
    select * from {{ ref('stg_stock_journalier') }}
),
produits as (
    select * from {{ ref('stg_produits') }}
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
    s.date_stock,
    s.produit_id,       -- Clé vers dim_produits
    s.quantite_en_stock,
    s.quantite_en_transit,
    s.quantite_reservee,
    s.quantite_disponible,
    round((s.quantite_en_stock * p.cout_base)::numeric, 2) as valeur_stock_cout,
    -- Classe ABC exacte à la date de la prise de vue du stock :
    coalesce(abc.classe_abc, 'C') as classe_abc
from stock s
left join produits p on s.produit_id = p.produit_id
left join segment_abc abc
    on s.produit_id = abc.produit_id
    and s.date_stock >= abc.debut_periode
    and s.date_stock <= abc.fin_periode