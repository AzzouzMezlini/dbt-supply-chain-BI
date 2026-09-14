select
    route_id,
    fournisseur_id,
    ville_origine,
    ville_destination,
    mode_transport,
    delai_moyen_jours,
    delai_ecart_type_jours,
    cout_expedition_forfaitaire
from {{ source('raw', 'route_achat') }}