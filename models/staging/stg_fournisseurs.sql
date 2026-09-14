with source as (
    select * from {{ source('raw', 'fournisseur') }}
),
renamed as (
    select
        fournisseur_id::bigint as fournisseur_id,
        nom_fournisseur::text as nom_fournisseur,
        ville_fournisseur::text as ville_fournisseur,
        pays_fournisseur::text as pays_fournisseur,
        est_actif::boolean as est_actif
    from source
)
select * from renamed