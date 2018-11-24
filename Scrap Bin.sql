/*create or replace view Vista_N as -- Almost Ready 2º Try         -- NAO FUNCA
    select count(*) as num_golos,golo.id_jogador
    from golo,jogador
    where jogador.id_jogador=golo.id_jogador and jogador.posicao!='Extremo' and rownum<2
    group by golo.id_jogador
    order by count(*) desc
;*/

/*create or replace view Vista_B as -- Rafa
    select count(jogo.id_jogo) as numero_de_jogos,equipa.nome
    from jogo, equipa, liga, treinador
    where jogo.id_liga = liga.id_liga and liga.epoca=20172018
        and equipa.id_equipa = treinador.id_equipa and treinador.nacionalidade like 'Portugal'
;*/

/*select count(golo.id_jogo)
from golo,jogo,liga
where jogo.id_jogo=golo.id_jogo and liga.id_liga=jogo.id_liga
and liga.epoca=epocaAtual(-1)
;*/

/*where jogador.id_equipa=eq.id_equipa and golo.id_jogador=jogador.id_jogador
and jogo.id_jogo=golo.id_jogo
and jogo.id_liga = liga.id_liga and liga.epoca=epocaAtual(-2)
;*/


/*create table Cartao(
    Id_Cartao number(5) not null primary key,
    Id_Jogador number(5) not null,
    Id_Jogo number(5) not null,
    Cor varchar2(80) not null,
    constraint FK_Id_Jogador_Cartao foreign key(Id_Jogador) references Jogador(Id_Jogador),
    constraint FK_Id_Jogo_Cartao foreign key(Id_Jogo) references Jogo(Id_Jogo)
);*/
--drop table Cartao;