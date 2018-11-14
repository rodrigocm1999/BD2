create or replace view Vista_A as
    select 
    from
    where

;



create or replace view Vista_B as
    select sum(jogo.id_Jogo),equipa.nome
    from equipa,jogo, (
        select id_treinador,id_equipa
        from treinador
        where nacionalidade='Portuguese' )trein
    where trein.id_equipa = equipa.id_equipa 
    and (jogo.id_equipa_casa = equipa.id_equipa or jogo.id_equipa_visitante = equipa.id_equipa)
    
    group by jogo.id_jogo
;
select * from Vista_B;