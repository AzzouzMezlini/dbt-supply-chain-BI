-- Fichier : models/staging/stg_stock_journalier.sql
with source as (
    select * from {{ source('raw', 'stock_journalier') }}
)

select
    produit_id,
    date::date as date_stock,
    quantite_en_stock::int as quantite_en_stock,
    quantite_en_transit::int as quantite_en_transit,
    quantite_reservee::int as quantite_reservee,
    greatest(0, quantite_en_stock - quantite_reservee) as quantite_disponible
from source