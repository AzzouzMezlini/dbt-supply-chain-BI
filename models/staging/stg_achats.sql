select
    ligne_po_id,
    produit_id,
    fournisseur_id,
    route_id,
    date_commande::date as date_commande,
    date_reception::date as date_reception,
    case 
        when date_reception is not null and date_commande is not null 
        then (date_reception::date - date_commande::date)
        else null 
    end as delai_livraison_jours,
    quantite_commandee,
    quantite_recue,
    cout_unitaire::numeric(10,2) as cout_unitaire,
    round((quantite_recue * cout_unitaire)::numeric, 2) as montant_total_achat,
    devise_achat
from {{ source('raw', 'achat') }}