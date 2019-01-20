set serveroutput on;
begin
dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('Start');dbms_output.put_line('Start');dbms_output.put_line('Start');
end;
/
--Auxiliares
create or replace procedure updateGolosJogos is
    golosCasa number(4);
    golosVisitante number(4);
    
    cursor cadaJogo is
        select id_jogo,id_equipa_casa,id_equipa_visitante from jogo;
begin
    for jog in cadaJogo loop
    
        select count(golo.id_jogador) into golosCasa
            from golo,pessoa
            where golo.id_jogo = jog.id_jogo and golo.id_jogador = pessoa.id_pessoa
                and pessoa.id_equipa = jog.id_equipa_casa;
        
        select count(golo.id_jogador) into golosVisitante
            from golo,pessoa
            where golo.id_jogo = jog.id_jogo and golo.id_jogador = pessoa.id_pessoa
                and pessoa.id_equipa = jog.id_equipa_visitante;
                
        update jogo set n_golos_casa = golosCasa, n_golos_visitante = golosVisitante where id_jogo = jog.id_jogo;
    
    end loop;
end;
/
exec UpdateGolosJogos();

--Pedidas Para o Trabalho
create or replace procedure epoca_desportiva(epoca_ number) as -- Ready
    melhor_1 number;
    melhor_2 number;
    melhor_3 number;
    pior_1 number;
    pior_2 number;
    pior_3 number;

    cursor curAsc is
        select classificacao.id_equipa from classificacao,liga
        where liga.id_liga = classificacao.id_liga
        and liga.epoca = epoca_
        order by n_pontos asc;
    cursor curDesc is
        select classificacao.id_equipa from classificacao,liga
        where liga.id_liga = classificacao.id_liga
        and liga.epoca = epoca_
        order by n_pontos Desc;
begin
    open curAsc;
    fetch curAsc into melhor_1;
    fetch curAsc into melhor_2;
    fetch curAsc into melhor_3;
    close curAsc;
    
    open curDesc;
    fetch curDesc into pior_1;
    fetch curDesc into pior_2;
    fetch curDesc into pior_3;
    close curDesc;
    
    insert into melhores_piores_equipas values(epoca_,melhor_1,melhor_2,melhor_3,pior_1,pior_2,pior_3);
end;
/
exec epoca_desportiva(epocaAtual(-3));

create or replace procedure alertas_treinador_processo(idTreinador number) as --DONE
 epoca_jogos varchar(256);
 nome_equipa varchar(256);
 n_jogos_realizados number(8); 
 n_jogos_ganhos number(8);       /*por clube e por época desportiva*/
 n_jogos_perdidos number(8); 
 n_golos_marcados number(8);
 n_id number(8);


        CURSOR c1 IS
            SELECT DISTINCT L.EPOCA, EQ.NOME, CLA.N_JOGOS_GANHOS, CLA.N_JOGOS_PERDIDOS, CLA.N_GOLOS_MARCADOS, CLA.N_JOGOS
                FROM
                    CLASSIFICACAO CLA,
                    EQUIPA EQ,
                    LIGA L
                WHERE
                     CLA.ID_EQUIPA = (SELECT P.ID_EQUIPA FROM PESSOA P WHERE P.ID_PESSOA = idTreinador) AND
                     EQ.NOME = (SELECT EQUIPA.NOME FROM EQUIPA WHERE EQUIPA.ID_EQUIPA = CLA.ID_EQUIPA) AND
                     L.EPOCA = (SELECT LIGA.EPOCA FROM LIGA WHERE LIGA.ID_LIGA = CLA.ID_LIGA) 
            ORDER BY L.EPOCA;
 begin
        SELECT MAX(ID_ALERTAS) into n_id
        FROM Alertas_Treinador;
        
        
        open c1;
            fetch c1 into nome_equipa, epoca_jogos, n_jogos_ganhos, n_jogos_perdidos, n_golos_marcados, n_jogos_realizados;           
        close c1;
        
        if n_id is null then 
         insert into Alertas_Treinador values(1,nome_equipa,epoca_jogos,n_jogos_ganhos,n_jogos_perdidos,n_golos_marcados,n_jogos_realizados);
         else
            insert into Alertas_Treinador values(n_id +1 ,nome_equipa,epoca_jogos,n_jogos_ganhos,n_jogos_perdidos,n_golos_marcados,n_jogos_realizados);
        end if;
end;
/
exec alertas_treinador_processo(83);