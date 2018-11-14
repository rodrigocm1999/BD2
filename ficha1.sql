--ex1
drop table temp;
create table temp(
    col1 number(10),
    col2 number(20),
    message varchar2(100)
);


--ex2
SET SERVEROUTPUT ON
    ACCEPT altura PROMPT 'Introduza a sua altura';
    ACCEPT sexo PROMPT 'Introduza sexo (M/F)';
DECLARE
    valor number(9,2);
    sexo_aux varchar2(10) := '&sexo';
BEGIN
    DBMS_OUTPUT.PUT_LINE(sexo_aux);
    if ( sexo_aux = 'H' ) then
        valor := (72.7 * &altura) - 58;
    elsif ( sexo_aux = 'M' ) then
        valor := (62.1 * &altura) - 44.7;
    end if;
    DBMS_OUTPUT.PUT_LINE('VALOR: '||valor);
END;

--ex4
SET SERVEROUTPUT ON
DECLARE
    mensagem varchar(50);
BEGIN
    
    for i in 1..100 loop
        if( mod(i,2) = 0 ) then
            mensagem := 'Col1 é par';
        else
            mensagem := 'Col1 é ímpar';
        end if;
        insert into temp values(i,i*100,mensagem);    
    end loop;
END;

--ex5
SET SERVEROUTPUT ON
    accept num prompt 'IMTRODUZA O NUMERO';
DECLARE
    codAutorLivro number;
BEGIN
    --insert into autores values(80,'Luis Moreno Campos',23432432,'Lisboa',30,'M','Portuguesa','informática');

    select codigo_autor into codAutorLivro from livros where codigo_livro=&num;
    DBMS_OUTPUT.PUT_LINE('codAutorLivro: '||codAutorLivro);
    if (codAutorLivro=17) then
        update livros set codigo_autor = 80 where codigo_livro = &num;
    end if;

END;


--ex6,7
SET SERVEROUTPUT ON
    accept num prompt 'IMTRODUZA O NUMERO';
DECLARE
    autor80exists number;
    codAutorLivro number;
BEGIN
    select count(*) into autor80exists from autores where codigo_autor=80;
    if(autor80exists = 0) then
        insert into autores values(80,'Luis Moreno Campos',23432432,'Lisboa',30,'M','Portuguesa','informática');
    end if;
    
    select codigo_autor into codAutorLivro from livros where codigo_livro=&num;
    DBMS_OUTPUT.PUT_LINE('codAutorLivro: '||codAutorLivro);
    if (codAutorLivro=17) then
        update livros set codigo_autor = 80 where codigo_livro = &num;
    end if;
END;

--ex8,9
SET SERVEROUTPUT ON
    accept num prompt 'IMTRODUZA O NUMERO';
DECLARE
    autor80exists number;
    codAutorLivro number;
BEGIN
    select count(*) into autor80exists from autores where codigo_autor=80;
    if(autor80exists = 0) then
        insert into autores values(80,'Luis Moreno Campos',23432432,'Lisboa',30,'M','Portuguesa','informática');
    end if;
    
    select codigo_autor into codAutorLivro from livros where codigo_livro=&num;
    DBMS_OUTPUT.PUT_LINE('codAutorLivro: '||codAutorLivro);
    if (codAutorLivro=17) then
        update livros set codigo_autor = 80 where codigo_livro = &num;
    end if;
    
EXCEPTION
    WHEN others then
        DBMS_OUTPUT.PUT_LINE('O livro correspondente a esse código não existe');
END;

--ex10
SET SERVEROUTPUT ON
    accept num prompt 'IMTRODUZA O NUMERO';
DECLARE
    preco number;
    tipo varchar2(50);
BEGIN
    select preco_tabela,genero into preco,tipo from livros where codigo_livro = &num;
    
    if(tipo='Aventura') then
        DBMS_OUTPUT.PUT_LINE('');
    elsif(preco>=25) then
        update livros set preco_tabela=preco_tabela*1.06 where codigo_livro = &num;
    else 
        update livros set preco_tabela=preco_tabela*1.1 where codigo_livro = &num;
    end if;
END;


--ex11
SET SERVEROUTPUT ON
    accept num prompt 'IMTRODUZA O NUMERO';
DECLARE
    quant number;
    unitsSold number;
BEGIN
    select quant_em_stock into quant from livros where codigo_livro = &num;
    select sum(quantidade) into unitsSold from vendas where codigo_livro = &num;
    
    if(quant<2) then
        dmbs_output.put_line('Encomendar com urgência');
    elsif(quant<unitsSold*0.01) then
        dmbs_output.put_line('Encomendar para a semana');
    else
        dmbs_output.put_line('Quantidade em Stock: '||quant);
    end if;
END;


--ex12
SET SERVEROUTPUT ON
DECLARE
    quant number;
    codigo number;
    preco number;
    pag number;
    tipo varchar2(10000);
    cursor cur is
        select codigo_livro,preco,quant_em_stock,paginas,genero
        from livros;
BEGIN
    open cur;
    loop
        exit when cur%NOTFOUND;
        fetch cur into codigo,preco,quant,pag,tipo;
        if preco>20 and preco<30 then
            update livros set quant_em_stock=quant+5 where codigo_livro=codigo;
        elsif preco>=30 and preco<40 and pag>30 then
            update livros set quant_em_stock=quant*1.1 where codigo_livro=codigo;
        elsif tipo='Informática' then
            update livros set quant_em_stock=quant-2 where codigo_livro=codigo;
        end if;    
    end loop;
    close cur;
END;







