with source as (
    select * from {{ source('raw', 'segment_abc') }}
),
renamed as (
    select
        abc_id::bigint as abc_id,
        produit_id::bigint as produit_id,
        debut_periode::date as debut_periode,
        fin_periode::date as fin_periode,
        classe_abc::text as classe_abc
    from source
)
select * from renamed