set serveroutput on;
--ex1
create or replace procedure ex1(num1 number,num2 number) as
    j number;
    i number;
Begin
    for i in num1..num2 loop
        for j in 1..10 loop
            dbms_output.put_line(i||' X '|| j ||' = ' || i*j);
        end loop;
    end loop;

End;
/
exec ex1(2,5);

--ex2
create table resultados(
    nome varchar2(100),
    nota1 number(5),
    nota2 number(5),
    nota3 number(5),
    nota4 number(5),
    media number(5),
    resultado varchar2(80)
);
create or replace procedure ex2(nome varchar2,    nota1 number,    nota2 number,    nota3 number,    nota4 number) as
    average number := (nota1+nota2+nota3+nota4)/4;
Begin
    if(average >= 9.5) then
        insert into resultados values(nome,nota1,nota2,nota3,nota4,average,'Aprovado');
    else
        insert into resultados values(nome,nota1,nota2,nota3,nota4,average,'Retardado');
    end if;
End;
/
exec ex2('Alface2',19,10,6,9);

--ex3
create or replace procedure ex3(codCliente number) as
    nome varchar2(80);
    contribuinte number(10);
    telefone number(12);
Begin
    select nome,n_contribuinte,telefone into nome,contribuinte,telefone
    from clientes where codigo_cliente=codCliente;

    dbms_output.put_line('Nome: ' || nome || '  Contribuinte: ' || contribuinte || '  Telefone: ' || telefone);
End;
/
exec ex3(4);

--ex4
create or replace procedure ex4(codLivro number) as
    nome varchar2(80);
    codAutor number(10);
    genero varchar2(80);
    totalGenero number(10);
Begin
    
    select autores.nome, autores.codigo_autor, livros.genero into nome, codAutor, genero
    from livros, autores
    where livros.codigo_livro=codLivro and autores.codigo_autor=livros.codigo_autor;
    
    select sum(quantidade*preco_unitario) as total_venda into totalGenero
    from livros,vendas
    where livros.genero = genero 
        and vendas.codigo_livro = livros.codigo_livro
    group by livros.genero;
    
    dbms_output.put_line('Nome Autor: '|| nome ||'   Total Venda do Gênero: '||totalGenero);
End;
/
exec ex4(3);

--ex5
create or replace procedure pesquisa_cliente(codCliente number) as
    codLivro number(10);
    contribuinte number(10);
    
    cursor cur is
        select codigo_livro 
        from vendas
        where codigo_cliente=codCliente
        order by data_venda;
Begin

    select n_contribuinte into contribuinte
    from clientes where codigo_cliente=codCliente;

    for item in cur loop
        insert into temp values(contribuinte,item.codigo_livro,(select titulo from livros where codigo_livro=item.codigo_livro));
        exit;
    end loop;
End;
/
exec pesquisa_cliente(3);

--ex6
create table aula4(
     string1 varchar2(500) , num1 number, num2 number, num3 number, string2 varchar2(1000)
);
create or replace procedure ex6 as  -- Nao funciona completamente
    cursor autores is select * from autores;
Begin
    delete from aula4;
    for autor in autores loop
    
        insert into aula4 values(
            autor.nome,(
            select sum(quantidade)
                from vendas,livros
                where vendas.codigo_livro=livros.codigo_livro and livros.codigo_autor=autor.codigo_autor
                group by vendas.codigo_livro
            ),(
            select sum(quant_em_stock)
                from livros
                where livros.codigo_autor=autor.codigo_autor
            ),(
            select sum(quantidade*preco_unitario)
                from vendas,livros
                where vendas.codigo_livro=livros.codigo_livro and livros.codigo_autor=autor.codigo_autor
                group by codigo_autor
            ),(
            select livros.titulo
                from vendas,livros
                where livros.codigo_livro=vendas.codigo_livro and livros.codigo_autor=autor.codigo_autor
                    and vendas.quantidade=(select max(quantidade) from vendas ven,livros liv 
                                            where ven.codigo_livro=liv.codigo_livro 
                                                and liv.codigo_autor=autor.codigo_autor)
            )
        );
    
    end loop;
End;
/
exec ex6;

--ex7
create or replace procedure ex7(codLivro number) as
Begin
    update livros set preco_tabela=preco_tabela*1.1 where codigo_livro=codLivro;
End;
/
exec ex7(1);

--ex8
create or replace procedure ex8(nome varchar2, n_contribuiente number, morada varchar2, telefone number)  as
Begin
    insert into Clientes values((select max(codigo_cliente)+1 from clientes) ,nome,n_contribuiente,morada,telefone);
End;
/
exec ex8('Alface',1203123,'Rua dos Monqos',9123123123);