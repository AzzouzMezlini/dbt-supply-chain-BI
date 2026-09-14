select
    r.route_id,
    f.fournisseur_id,
    f.nom_fournisseur,
    r.ville_origine,
    r.ville_destination as ville_entrepot,
    f.pays_fournisseur,
    r.mode_transport,
    r.delai_moyen_jours,
    r.delai_ecart_type_jours,
    r.cout_expedition_forfaitaire
from {{ ref('stg_routes_achat') }} r
left join {{ ref('stg_fournisseurs') }} f on r.fournisseur_id = f.fournisseur_id