

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