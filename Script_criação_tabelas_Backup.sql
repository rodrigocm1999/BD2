drop table Transf_Treinador cascade constraints;
drop table Melhores_Goleadores cascade constraints;
drop table Melhores_Piores_Equipas cascade constraints;
drop table Equipas_Liga cascade constraints;
drop table Sancao_Disciplinar cascade constraints;
drop table Classificacao cascade constraints;
drop table Convocado cascade constraints;
drop table Jogo_Classificacao cascade constraints;
drop table Golo cascade constraints;
drop table Jogo cascade constraints;
drop table Liga cascade constraints;
drop table Treinador cascade constraints;
drop table Golos_Guarda_Redes cascade constraints;
drop table Jogador cascade constraints;
drop table Equipa cascade constraints;

------------------------------------------------------------------------
create table Equipa(
    Id_Equipa number(5) not null primary key,
    Nome varchar2(80) not null,
    Localidade varchar2(80) not null,
    Divisao number(1) not null check(Divisao = 1 or Divisao = 2),
    Nacionalidade varchar(80) not null
);

create table Jogador(
    Id_Jogador number(5) not null primary key,
    Id_Equipa number(5) not null,
    Nome varchar2(80) not null,
    Idade number(2) not null,
    Posicao varchar2(80) not null,
    Nacionalidade varchar2(80) not null,

    constraint FK_Id_Equipa foreign Key(Id_Equipa) references Equipa(Id_Equipa)
);

create table Treinador(
    Id_Treinador number(5) not null primary key,
    Id_Equipa number(5) not null,
    Nome varchar2(80) not null,
    Tipo varchar2(80) not null,    
    Nacionalidade varchar2(80) not null,
    
    constraint FK_Id_Equipa_Treinar foreign key(Id_Equipa) references Equipa(Id_Equipa)
);

create table Golos_Guarda_Redes(
    Id_Jogador number(5) not null,
    N_golos_sofridos number(3) not null,

    constraint FK_Id_Jogador_Guarda_Redes foreign key(Id_Jogador) references Jogador(Id_Jogador)
);

create table Liga(
    Id_Liga number(5) not null primary key,
    Divisao number(1) not null check(Divisao = 1 or Divisao = 2),
    Epoca number(8) not null,
    Inicio Date not null,
    Fim Date not null
);

create table Jogo(
    ID_Jogo number(5) not null primary key,
    Id_Equipa_Casa number(5) not null,
    Id_Equipa_Visitante number(5) not null,
    Id_Liga number(5) not null,
    N_Golos_Casa number(2) not null,
    N_Golos_Visitante number(2) not null,
    data_ Date not null,
   
    constraint FK_Id_Equipa_Casa foreign key(Id_Equipa_Casa) references Equipa(Id_Equipa),
    constraint FK_Id_Equipa_Visitante foreign key(Id_Equipa_Visitante) references Equipa(Id_Equipa),
    constraint Id_Liga foreign key(Id_Liga) references Liga(Id_Liga)
);

create table Convocado(
    Id_Jogo number(5) not null,
    Id_Jogador number(5) not null,
    
    primary key(Id_Jogo,Id_Jogador),
    constraint FK_Id_Jogo_Convocados foreign key(Id_Jogo) references Jogo(Id_Jogo),
    constraint FK_Id_Jogador_Convocados foreign key(Id_Jogador) references Jogador(Id_Jogador)
);

create table Golo(
    Id_Jogador number(5) not null,
    Id_Jogo number(5) not null,
    Temp_Jogo number(4) not null,

    primary key(Id_Jogador, Id_Jogo,Temp_Jogo),
    constraint FK_Id_Jogador_Golo foreign key(Id_Jogador) references Jogador(Id_Jogador),
    constraint FK_Id_Jogo_Golo foreign key(Id_Jogo) references Jogo(Id_jogo)
);

create table Classificacao(
    Id_Classificacao number(5) not null primary key,
    Id_Liga number(5) not null,
    Id_Equipa number(5) not null,
    N_Golos_Marcados number(2) not null,
    N_Golos_Sofridos number(2) not null,
    N_Jogos number(2) not null,
    N_Pontos number(2) not null,
    N_Jogos_Ganhos number(2) not null,
    N_Jogos_Perdidos number(2) not null,

    constraint FK_Id_Equipa_Class foreign key(Id_Equipa) references Equipa(Id_Equipa),
    constraint FK_Id_Liga_Class foreign key(Id_Liga) references Liga(Id_Liga)
);

create table Sancao_Disciplinar(
    Id_Sancao number(5) not null primary key,
    Id_Jogador number(5) not null,
    Inicio date not null,
    Fim date,
    Tipo varchar2(80) not null,
    Id_Jogo number(5) not null,
    constraint FK_Id_Jogador_Sancao foreign key(Id_Jogador) references Jogador(Id_Jogador),
    constraint FK_Id_Jogo_Sancao foreign key(Id_Jogo) references Jogo(Id_Jogo)
);

create table Equipas_Liga(
    Id_Equipa number(5) not null,
    Id_Liga number(5) not null,

    primary key(Id_Equipa, Id_liga),
    constraint FK_Id_Equipa_Equipas_Liga foreign key(Id_Equipa) references Equipa(Id_Equipa),
    constraint FK_Id_Liga_Equipas_Liga foreign key(Id_Liga) references Liga(Id_Liga)
);

create table Jogo_Classificacao(
    Id_Classificacao number(5) not null,
    Id_Jogo number(5) not null,
    
    primary key(Id_Classificacao,Id_Jogo),
    constraint FK_Id_Classificacao_Jogo_Class foreign key(Id_Classificacao) references Classificacao(Id_Classificacao),
    constraint FK_Id_Jogo_Jogo_Class foreign key(Id_Jogo) references Jogo(Id_Jogo)
);

create table Transf_Treinador(
    Id_Treinador number(5) not null,
    Id_Equipa_Antiga number(5)not null,
    Id_Equipa_Nova number(5)not null,
    data_ Date not null,
    
    primary key(Id_Treinador,Id_Equipa_Antiga,Id_Equipa_Nova),
    constraint FK_Id_Treinador_Transf_T foreign key(Id_Treinador) references Treinador(Id_Treinador),
    constraint FK_Id_Antiga_Transf_T foreign key(Id_Equipa_Antiga) references Equipa(Id_Equipa),
    constraint FK_Id_Nova_Transf_T foreign key(Id_Equipa_Nova) references Equipa(Id_Equipa)
);

create table Melhores_Piores_Equipas(
    Epoca number(8) primary key,
    Melhor_1 number(5),
    Melhor_2 number(5),
    Melhor_3 number(5),
    Pior_1 number(5),
    Pior_2 number(5),
    Pior_3 number(5),
    
    constraint FK_Melhor_1_Melhor_Pior foreign key(Melhor_1) references Equipa(Id_Equipa),
    constraint FK_Melhor_2_Melhor_Pior foreign key(Melhor_2) references Equipa(Id_Equipa),
    constraint FK_Melhor_3_Melhor_Pior foreign key(Melhor_3) references Equipa(Id_Equipa),
    constraint FK_Pior_1_Melhor_Pior foreign key(Pior_1) references Equipa(Id_Equipa),
    constraint FK_Pior_2_Melhor_Pior foreign key(Pior_2) references Equipa(Id_Equipa),
    constraint FK_Pior_3_Melhor_Pior foreign key(Pior_3) references Equipa(Id_Equipa)
);

create table Melhores_Goleadores(
    Lugar number(2) primary key,
    ID_Jogador number(5) not null,
    
    constraint FK_ID_Jogador_Melhores_Gols foreign key(id_jogador) references jogador(id_jogador)
);