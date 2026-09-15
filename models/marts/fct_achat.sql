with achats as (
    select * from {{ ref('stg_achats') }}
)
select
    ligne_po_id,
    produit_id,
    fournisseur_id,
    route_id,
    date_commande,
    date_livraison_prevue,
    date_reception,
    
    -- Remplacer delai_livraison_jours par le calcul de l'écart réel :
    (date_reception - date_commande)::integer as delai_livraison_jours,
    
    -- Ou utiliser le délai théorique directement :
    delai_theorique_jours,
    
    quantite_commandee,
    quantite_recue,
    cout_unitaire,
    cout_transport_alloue,
    cout_revient_total,
    devise_achat,
    statut_commande
from achats