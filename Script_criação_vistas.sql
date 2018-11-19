
create or replace view Vista_A as -- Well
    select
    from
    where
;
select * from Vista_A;

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




create or replace view Vista_E as -- Almost Ready 2º Try
    select count(golo.temp_jogo) as golos,eq.nome as nome,eq.id_equipa as ID
    from golo,jogador,
        (select id_equipa,nome from equipa
        where localidade='Lisboa' or localidade='Porto')eq  
        
    where jogador.id_equipa=eq.id_equipa and golo.id_jogador=jogador.id_jogador
    
    group by eq.id_equipa,eq.nome,jogador.id_jogador
;
select * from Vista_E;




create or replace view Vista_F as -- Well
    select
    from
    where
;
select * from Vista_F;




create or replace view Vista_G as -- Almost Ready I Think
    select jogador.nome as Nome,count(golo.temp_jogo) as Golos
    from jogador,golo,jogo
        
    where golo.id_jogador=jogador.id_jogador and jogo.id_jogo=golo.id_jogo and jogo.id_equipa_visitante=jogador.id_equipa
    
    group by jogador.id_jogador,jogador.nome
;
select * from Vista_G;




create or replace view Vista_H as -- Well
    select
    from
    where
;
select * from Vista_H;




create or replace view Vista_I as -- Well
    select
    from
    where
;
select * from Vista_I;
    


create or replace view Vista_J as -- Well
    select
    from
    where
;
select * from Vista_J;




create or replace view Vista_K as -- Basically Ready
    select treinador.nome as "Nome dos Treinadores"
    from (    select id_treinador
        from transf_treinador
        where transf_treinador.data_>add_months(sysdate,-24)
    )transf,treinador
    where treinador.id_treinador=transf.id_treinador
;
select * from Vista_K;




create or replace view Vista_L as -- Kinda Ready
    select equipa.nome,jog.N_Golos_Casa+jog.N_Golos_Visitante as Golos_Totais
    from equipa,(
        select * from jogo
        where to_char(data_,'HH24') between 17 and 23
        and N_Golos_Casa+N_Golos_Visitante>4
        )jog
    where equipa.id_equipa in (jog.id_equipa_casa,jog.id_equipa_visitante)

    order by equipa.nome asc,jog.N_Golos_Casa+jog.N_Golos_Visitante
;
select * from Vista_L;










