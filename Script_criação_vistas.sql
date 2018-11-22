



create or replace view Vista_A as -- Mehh I dunno
    select x.nome_equipa
    from (
        select nome_equipa
        from (
                select sum(jogo.n_golos_casa) as Golos_Em_Casa,equipa.nome as nome_equipa
                from jogo,equipa
                where jogo.id_equipa_casa=equipa.id_equipa and to_char(jogo.data_,'YYYY-MM')>=to_char(add_months(sysdate,-1),'YYYY-MM')
                group by equipa.id_equipa,equipa.nome
                order by sum(jogo.n_golos_casa) )y
        where rownum<2
        )x
;
select * from Vista_A;




create or replace view Vista_B as -- Alittle not ready
    select count(jogo.id_Jogo) as Jogos,equipa.nome
    from equipa,jogo, liga, (
        select id_treinador,id_equipa
        from treinador
        where nacionalidade='Portuguese' )trein
        
    where jogo.id_liga=liga.id_liga and liga.epoca=epocaAtual()
        and equipa.id_equipa in (jogo.id_equipa_casa,jogo.id_equipa_visitante)
        and trein.id_equipa = equipa.id_equipa
    
    group by equipa.nome
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




create or replace view Vista_D as -- Ready
    select x.nome as "Nome do jogador",x.quant_golos as "Quantidade de golos",x.id_jogador as "Id do Jogador"
    from (
        select count(golo.id_jogo) as quant_golos,jog.id_jogador,jog.nome 
        from (
            select id_jogador,nome from jogador 
            where posicao='Extremo' 
            )jog, golo, jogo
            
        where golo.id_jogador=jog.id_jogador and jogo.id_jogo=golo.id_jogo 
            and jogo.data_>=add_months(sysdate,-1)
        group by jog.id_jogador,golo.id_jogo,jog.nome
        )x
    where x.quant_golos>=2
;
select * from Vista_D;




create or replace view Vista_E as -- Ready
    select count(golo.id_jogo) as Golos,eq.id_equipa as "Id da Equipa",eq.nome as "Nome da Equipa"
    from (
        select id_equipa,nome from equipa
        where localidade='Lisboa' or localidade='Porto'
        )eq, golo, jogador, liga, jogo
        
    where jogador.id_equipa=eq.id_equipa and golo.id_jogador=jogador.id_jogador
        and golo.id_jogo=jogo.id_jogo
        and jogo.id_liga=liga.id_liga and liga.epoca=epocaAtual(-1)
    
    group by eq.id_equipa,eq.nome
    order by count(golo.id_jogo) desc
;
select * from Vista_E;




create or replace view Vista_F as -- Well
    select
    from
    where
;
select * from Vista_F;




create or replace view Vista_G as -- Ready
    select x.Nome,  x.Golos
    from (
        select jogador.nome as Nome,count(golo.id_jogo) as Golos
        from jogador,golo,jogo
        where golo.id_jogador=jogador.id_jogador and jogo.id_jogo=golo.id_jogo and jogo.id_equipa_visitante=jogador.id_equipa
        
        group by jogador.id_jogador,jogador.nome
        order by count(golo.id_jogo) desc
        )x
    where rownum<=4
;
select * from Vista_G;




 


create or replace view Vista_H as -- Well Rafa
    select
    from
    where
;
select * from Vista_H;




create or replace view Vista_I as -- Well Rafa
    select
    from
    where
;
select * from Vista_I;
    


create or replace view Vista_J as -- Ready
    select equipa.id_equipa as "ID da Equipa",equipa.nome as "Nome da Equipa",equipa.localidade as "Local",treinador.nome as "Nome do Treinador"
        ,jog.N_casa as "Golos da Casa",jog.N_visitante as "Golos da Visitante"
    from (
        select jogo.N_golos_casa as N_casa, jogo.N_golos_Visitante as N_visitante, jogo.id_equipa_casa as id_equipa_casa
        from jogo,liga
        where liga.id_liga=jogo.id_liga and next_day(jogo.data_,'DOMINGO')-8 > next_day(sysdate,'DOMINGO')-48
        )jog, equipa,  treinador
        
    where equipa.id_equipa in (jog.id_equipa_casa)
        and treinador.id_equipa = equipa.id_equipa and treinador.tipo='Principal'
    order by equipa.nome desc,equipa.localidade,treinador.nome
;
select * from Vista_J;



create or replace view Vista_K as -- Ready
    select treinador.nome as "Nome dos Treinadores", transf.data_
    from (    select id_treinador,data_
        from transf_treinador
        where transf_treinador.data_>add_months(sysdate,-24)
    )transf,treinador
    where treinador.id_treinador=transf.id_treinador
;
select * from Vista_K;




create or replace view Vista_L as -- Ready
    select equipa.nome as "Nome da Equipa",jog.N_Golos_Casa+jog.N_Golos_Visitante as "Golos Totais"
    from equipa,(
        select * from jogo
        where to_char(data_,'HH24') between 17 and 23
        and N_Golos_Casa+N_Golos_Visitante>4
        )jog
    where equipa.id_equipa in (jog.id_equipa_casa,jog.id_equipa_visitante)

    order by jog.N_Golos_Casa+jog.N_Golos_Visitante desc
;
select * from Vista_L;



--Melhor Marcador Nao Extremo
create or replace view Vista_M as -- Ready
    select jogador.nome,gol.num_golos
    from (
        select count(*) as num_golos,id_jogador
        from golo
        group by golo.id_jogador
        order by count(*) desc)gol,jogador
    where jogador.id_jogador=gol.id_jogador and jogador.posicao!='Extremo' and rownum<2
;
select * from Vista_M;



-- Nº de golos totais dos jogadores não portugueses e não defesas na penúltima época
create or replace view Vista_N as -- Ready
    select count(jog.id_jog) as Quantiadade
    from (
        select id_jogador as id_jog
        from jogador
        where nacionalidade!='Portugal' and posicao!='Defesa'
        ) jog,golo,liga,jogo
    where golo.id_jogador=jog.id_jog and jogo.id_jogo=golo.id_jogo and liga.id_liga=jogo.id_liga
        and liga.epoca=epocaAtual(-2)
;
select * from Vista_N;



