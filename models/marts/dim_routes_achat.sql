select
    route_id,
    fournisseur_id,
    id_ville_origine,
    id_ville_destination,
    mode_transport,
    delai_moyen_jours,
    delai_ecart_type_jours,
    cout_expedition_forfaitaire
from {{ ref('stg_routes_achat') }}