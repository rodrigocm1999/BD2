--Auxiliares
create or replace procedure updateGolosJogos as

begin

end;
/
--Pedidas Para o Trabalho
create or replace procedure epoca_desportiva(epoca_ number) as
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
exec epoca_desportiva(20162017);
create or replace procedure alertas_treinador(idTreinador number) as

begin

end;
/
create or replace procedure AMeuCriterio as

begin

end;
/