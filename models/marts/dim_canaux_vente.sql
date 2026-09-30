select
    canal_id,
    nom_canal,
    type_execution,
    mode_expedition,
    sla_jours
from {{ ref('stg_canaux_vente') }}