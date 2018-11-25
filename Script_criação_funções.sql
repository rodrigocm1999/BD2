--Funcões de Ajuda às vistas

create or replace function epocaAtual(quantos number default 0) return number as
    epoca number := 0;
    anoAtual number;
Begin
    anoAtual := to_char(sysdate,'YYYY');
    epoca := epoca + anoAtual + quantos;
    epoca := epoca +(anoAtual - 1 + quantos) * 10000;
    return epoca;
End;
/
create or replace function N_JGCL (idEquipa number, Epoca number) return number as
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
        select count(golo.id_jogo)
        into temp
        from golo,jogo
        where golo.id_jogador=item.id_jogador and jogo.id_jogo=golo.id_jogo 
            and jogo.data_>= add_months(sysdate,-3);
            
        amount := amount + temp;
        temp := 0;
    end loop;
    return amount;
End;
/
create or replace function numero_amarelos(jog_nome varchar2,dataInicio date,dataFim date) return number as
    id_jog number;
    eq_jog number;
    counter number := 0;
    amount number := 0;
    cursor cur(jogo_id number) is
        select sandis.id_jogo as id_jogo
        from sancao_disciplinar sandis
        where sandis.id_jogador=jogo_id and tipo='Amarelo'
            and jogo_id=sandis.id_jogo;
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
End;
/
create or replace function ultimo_jogo(nome_equipa varchar2) return date as
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
End;
/
create or replace function primeira_substituição return number as

Begin

End;
/
create or replace function clubes_cidade(place varchar2) return number as

Begin

End;
/
create or replace function idade(idade number, dataInicio date, dataFim date) return number as

Begin

End;
/
create or replace function tempo_medio_venda(idEquipa number) return number as

Begin

End;
/
create or replace function AMeuCriterio return number as

Begin

End;
/



