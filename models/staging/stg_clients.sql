with source as (
    select * from {{ source('raw', 'entreprise_client') }}
),
renamed as (
    select
        client_id::bigint as client_id,
        nom_client::text as nom_client,
        id_ville_client::text as id_ville_client,
        segment_client::text as segment_client
    from source
)
select * from renamed