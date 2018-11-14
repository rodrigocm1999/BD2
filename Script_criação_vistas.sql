

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






create or replace view Vista_D as
    select jog.nome
    
    from (select nome,id_jogador from jogadores where posicao='Extremo'  )jog,
        (select count(id_golo),id_jogador 
        from golo,jogo,jogador
        where jogador.id_jogador=golo.id_jogador and golo.id_jogo=jogo.id_jogo 
        and jogo.data_>=add_month(sysdate,-1)
        group by id_jogador  )
    
    
    where
    
;
