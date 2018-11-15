

create or replace view Vista_B as -- Not Ready Super Imcomplete
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



create or replace view Vista_C as --Not Ready Rafa
    select Nome
    from jogador, sancao_disciplinar, liga
    where jogadores.nacionalidade = 'Portuguesa' and
    count(sancao_disciplinar.ID_jogador = jogadores.Id_jogador) <= 0 and
    equipa.ID_JOgador = jogador.Id_jogador and
    liga.id_equipa = equipa.id_equipa and
    divisao = 2
;
select * from Vista_C;





create or replace view Vista_D as -- Almost Ready
    select x.nome as "Nome do jogador",x.quant_golos as "Quantidade de golos"
    from (
        select count(golo.temp_jogo) as quant_golos,jog.id_jogador,jog.nome 
        from (
            select id_jogador,nome from jogador 
            where posicao='Extremo' 
            )jog,golo,jogo
        where jog.id_jogador=golo.id_jogador and golo.id_jogo=jogo.id_jogo 
            and jogo.data_>=add_months(sysdate,-1)
        group by jog.id_jogador,golo.id_jogo,jog.nome
        )x
    where x.quant_golos>=2    
;
select * from Vista_D;




create or replace view Vista_E as -- Not Ready
    select count(*) as "Golos da equipa",equipa.nome as "Nome da Equipa"
    from golo,jogador,
        (select id_equipa from equipa
        where localidade='Lisboa' or localidade='Porto')eq
        
    where jogador.id_equipa=eq.id_equipa and golo.id_jogador=jogador.id_jogador
    --and equipa.id_equipa=eq.id_equipa
    group by equipa.nome
;
select * from Vista_E;






