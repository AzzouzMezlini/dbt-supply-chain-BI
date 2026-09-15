with clients as (
    select * from {{ ref('stg_clients') }}
)
select
    client_id,
    nom_client,
    id_ville_client,
    segment_client
from clients