set serveroutput on;
begin
dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('Start');dbms_output.put_line('Start');dbms_output.put_line('Start');
end;
/
--Funcões de Suporte às Vistas

create or replace function epocaAtual(quantos number default 0) return number as -- Ready
    epoca number := 0;
    anoAtual number;
Begin
    anoAtual := to_char(sysdate,'YYYY');
    epoca := epoca + anoAtual + quantos;
    epoca := epoca +(anoAtual - 1 + quantos) * 10000;
    return epoca;
End;
/
create or replace function N_JGCL (idEquipa number, Epoca number) return number as -- Ready
    temp number := 0;
    ConsWins number := 0;
    
    cursor cur (equipa number, epoc number) is
        select id_jogo,id_equipa_casa,n_golos_casa,id_equipa_visitante,n_golos_visitante
        from jogo,liga
        where equipa in (jogo.id_equipa_casa,jogo.id_equipa_visitante)
            and jogo.id_liga=liga.id_liga and liga.epoca=epoc
        order by jogo.data_;
    
Begin   
    for item in cur(idEquipa,Epoca) loop
        if (item.id_equipa_visitante=idEquipa and item.n_golos_visitante>item.n_golos_casa) or (item.id_equipa_casa=idEquipa and item.n_golos_casa>item.n_golos_visitante) then
            temp := temp + 1;
            if temp > ConsWins then
                ConsWins := temp;
            end if;            
        else
            temp := 0;
        end if;
    end loop;
    return ConsWins;
End;
/
-- Funções Pedidas para o Trabalho

create or replace function numero_golos(posicao varchar2) return number as -- Ready
    temp number := 0;
    amount number := 0;
    cursor cur(pos varchar2) is
        select * from jogador
        where jogador.posicao=pos;
Begin
    for item in cur(posicao) loop
        select count(golo.id_jogo) into temp
        from golo,jogo
        where golo.id_jogador=item.id_jogador and jogo.id_jogo=golo.id_jogo 
            and jogo.data_>= add_months(sysdate,-3);
            
        amount := amount + temp;
        temp := 0;
    end loop;
    return amount;
End;
/
--select numero_golos('Extremo') from dual;

create or replace function numero_amarelos(jog_nome varchar2,dataInicio date,dataFim date) return number as --Ready needs more testing
    id_jog number;
    eq_jog number;
    counter number := 0;
    amount number := 0;
    
    cursor cur(jogador_id number) is
        select cart.id_jogo as id_jogo
        from cartoes cart
        where cart.id_pessoa=jogador_id;
Begin
    select id_jogador,id_equipa into id_jog,eq_jog
    from jogador
    where jogador.nome = jog_nome;
        
    for item in cur(id_jog) loop

        select count(jogo.id_jogo) into counter
        from jogo
        where jogo.id_jogo=item.id_jogo and jogo.id_equipa_casa=eq_jog
            and jogo.data_ between dataInicio and dataFim;
        
        if(counter = 1) then
            amount := amount + 1;
        end if;    
    end loop;
    return amount;
    
Exception
   when TOO_MANY_ROWS then
      return -1;
End;
/
--select numero_amarelos('Dell',TO_DATE('2003/07/09', 'yyyy/mm/dd'),TO_DATE('2003/07/09', 'yyyy/mm/dd')) from dual;

create or replace function ultimo_jogo(nome_equipa varchar2) return date as -- Ready
    id_eq number;
    cursor cur(idEquipa number) is
        select data_
        from jogo
        where jogo.id_equipa_visitante=idEquipa and jogo.n_golos_casa>jogo.n_golos_visitante
        order by data_ desc;
Begin
    select id_equipa into id_eq from equipa where nome=nome_equipa;
    for item in cur(id_eq) loop
        return item.data_;  
    end loop;
Exception
    when TOO_MANY_ROWS then
        return -1;
End;
/
--select ultimo_jogo('AAC') as "ultimo jogo perdido" from dual;


create or replace function primeira_substituição(jogador1 number) return number as -- Have to check
    jg1 number;
    cursor cur(joga number) is
        SELECT tempo_jogo
        FROM SUBSTITUICAO
        WHERE SUBSTITUICAO.ID_JOGADOR = joga;
Begin
    SELECT tempo_jogo into jg1 from Substituicao where id_jogador = jogador1;
    FOR item in cur(jg1) loop
        return item.tempo_jogo;
    end loop;
End;
/

create or replace function clubes_cidade(place varchar2) return varchar2 as -- Nao esta completamente correto
    cursor cur(place_ varchar2) is
        select posicao,count(posicao) as quant
        from (select jogador.id_jogador,jogador.posicao,jogador.localidade 
            from jogador,equipa,liga
            where equipa.id_equipa = jogador.id_equipa 
                and liga.id_liga = equipa.id_equipa and liga.epoca = epocaAtual(-1)
        ) x
        where localidade = place_
        group by posicao 
        order by quant desc;
Begin
for item in cur(place) loop
    return item.posicao;
end loop;
End;
/
--select clubes_cidade('Lisboa') from dual;
    
create or replace function idade(idade_ number, dataInicio date, dataFim date) return number as -- Incompleto falta excluir  jogadores a menos de duas epocas no clube
    total number;
Begin
    select sum(y.golos) into total
        from(
            select count(x.id_jogador) as golos
            from(
                select jog.id_jogador as id_jogador, jog.nome as nome
                from (select id_jogador,nome from jogador where jogador.idade=23)jog,golo,jogo,liga
                where golo.id_jogador=jog.id_jogador and jogo.id_jogo=golo.id_jogo
                   and liga.id_liga=jogo.id_liga and liga.epoca=epocaAtual(-2) -- Mudar para 0 para apresentar resultados da epoca atual
                ) x                                                             -- Na epoca presente nao existem resultados a serem mostrados
            group by id_jogador,nome
            order by count(x.id_jogador)
        ) y;
    
    return total;
End;
/
--select idade(12,TO_DATE('2003/07/09', 'yyyy/mm/dd'),TO_DATE('2003/07/09', 'yyyy/mm/dd')) as resultado from dual;





create or replace function tempo_medio_venda(idEquipa number) return number as

Begin

End;
/
create or replace function AMeuCriterio return number as

Begin

End;
/


