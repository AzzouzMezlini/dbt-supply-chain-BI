with source as (
  select * from {{ source('raw', 'entreprise_client') }}
)

select
  client_id,
  nom_client,
  ville_client,
  segment_client
from source