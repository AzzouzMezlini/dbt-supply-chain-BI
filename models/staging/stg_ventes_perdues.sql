with source as (
    select * from {{ source('raw', 'vente_perdue') }}
),
renamed as (
    select
        perte_id::bigint as perte_id,
        produit_id::bigint as produit_id,
        client_id::bigint as client_id,
        canal_id::bigint as canal_id,
        date_commande::date as date_commande,
        quantite_manquante::integer as quantite_manquante,
        chiffre_affaires_perdu::numeric(12,2) as chiffre_affaires_perdu,
        motif_rupture::text as motif_rupture
    from source
)
select * from renamed