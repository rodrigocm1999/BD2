

create or replace view Vista_B as -- Not Ready
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






create or replace view Vista_D as -- Not Ready
    select x.nome as "Nome do jogador",x.quant_golos as "Quantidade de golos"
    from (
        select count(golo.id_golo) as quant_golos,jogador.id_jogador,jogador.nome 
        from golo,jogo,jogador
        where jogador.id_jogador=golo.id_jogador and golo.id_jogo=jogo.id_jogo 
            and jogo.data_>=add_month(sysdate,-1) and jogador.posicao='Extremo'
        group by golo.id_jogador  )x
    where x.quant_golos>=2    
;
select * from Vista_D;