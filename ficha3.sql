--ex1
SET SERVEROUTPUT ON
DECLARE
    aux_v varchar2(30);
BEGIN
    select nome into aux_v from autores ;
Exception
    when TOO_MANY_ROWS then
        dbms_output.put_line('Too Many Rows');
    when NO_DATA_FOUND then
        dbms_output.put_line('No Data Found');
    when CURSOR_ALREADY_OPEN then
        dbms_output.put_line('Cursor Already Open');
    when OTHERS then
        dbms_output.put_line('No Data Found');
END;
/
--ex2,3
SET SERVEROUTPUT ON
    accept cod_livro prompt 'BOI O NUMERO UHHH?';
Declare
    autor80 number := 0;
    cod_autor number;
    errorM varchar2(500);
Begin
    select count(codigo_autor) into autor80 from autores where codigo_autor=80;
    if autor80 = 0 then
        insert into autores values(80,'Luis Moreno Campos',23432432,'Lisboa',30,'M','Portuguesa','informática');
    end if;
    
    select codigo_autor into cod_autor from livros where codigo_livro='&cod_livro';
    if cod_autor = 17 then
        update livros set codigo_autor=80 where codigo_livro='&cod_livro';
    end if;    
Exception
    when OTHERS then
        errorM:= sqlerrm;
        insert into erros values(sqlcode,errorM,sysdate);
End;
/
create table Erros(
    Cod_Erro number(10) not null primary key,
    Msg_Erro varchar2(250) not null,
    Data_ date not null
);
drop table Erros;
/
--ex4
SET SERVEROUTPUT ON
Declare
Begin
End;
/










--ex4
SET SERVEROUTPUT ON
    accept _genero prompt 'Introduza o genero';
DECLARE
    cursor cur (gen varchar2)is
        select preco_tabela from livros
        where genero=gen
        order by preco_tabela asc
        for update of preco_tabela;
    preco_total number;
    preco number;
BEGIN
open cur('&_genero');
    loop
        fetch cur into preco;
        exit when cur%notfound;

        select sum(preco_tabela) 
            into preco_total
            from livros
            where genero= '&_genero';
        if preco_total >= 150 then
            exit;
        end if;
        
        update livros set preco_tabela=preco_tabela*1.1 where current of cur;
    end loop;
END;
/
--ex5
SET SERVEROUTPUT ON
    accept _genero prompt 'Introduza o genero';
DECLARE
    cursor cur (gen varchar2)is
        select preco_tabela from livros
        where genero=gen
        order by preco_tabela asc
        for update of preco_tabela;
    preco_total number;
    preco number;
BEGIN
    for item in cur('&_genero') loop

        select sum(preco_tabela) 
            into preco_total
            from livros
            where genero= '&_genero';
        if preco_total >= 150 then
            exit;
        end if;
        
        update livros set preco_tabela=preco_tabela*1.1 where current of cur;
    end loop;
END;
/
--ex6
drop table temp;
create table temp(
    codigo_livro int not null primary key,
    preco_tabela int not null,
    titulo varchar(512) not null
);
DECLARE
    cursor cur is
        select codigo_livro,preco_tabela,titulo from livros
        order by preco_tabela desc
        for update of preco_tabela;
    cod number;
    pre number;
    tit varchar2(10000);
BEGIN
    open cur;
    loop
        fetch cur into cod,pre,tit;

        insert into temp(codigo_livro,preco_tabela,titulo) values(cod,pre,tit);
        if cur%rowcount = 8 then
            exit;
        end if;
    end loop;
    close cur;
END;
/
--ex7
DECLARE
    cursor cur is
        select codigo_livro,preco_tabela,titulo from livros
        order by preco_tabela desc
        for update of preco_tabela;
BEGIN
    for item in cur loop
        insert into temp(codigo_livro,preco_tabela,titulo) values(item.codigo_livro,item.preco_tabela,item.titulo);
        if cur%rowcount = 8 then
            exit;
        end if;
    end loop;
END;
/
--ex8
DECLARE
    cursor cur is
        select preco_tabela,paginas
        from livros
        where genero='Informática';
    total number := 0;
    pag500 number := 0;
    pre25 number := 0;
BEGIN
    for item in cur loop
        total := total + item.preco_tabela;
        if item.preco_tabela > 25 then
            pre25 := pre25 + 1;
        end if;
        if item.paginas > 500 then
            pag500 := pag500 + 1;
        end if;    
    end loop;
    
    insert into temp values (pre25,pag500,'Preço total : ' || total );
END;
/
--ex9
DECLARE
    cursor cur is
        select codigo_livro,quant_em_stock
        from livros
        where genero='Informática';
    quantStock number := 0;
    quantVend number := 0;
    tempStock number;
    cod number;
    temp number;
BEGIN
    open cur;
    loop
        fetch cur into cod,tempStock;
        exit when cur%notfound;
        quantStock := quantStock + tempStock;
        
        select sum(quantidade) into temp from vendas where codigo_livro = cod;
        if temp > 0 then
            quantVend := quantVend + temp;
        end if;
    end loop;
    close cur;
    insert into temp values (quantStock,quantVend,'Informática');
END;
/
--ex10
DECLARE
    cursor cur is
        select codigo_livro,quant_em_stock
        from livros
        where genero='Informática';
    quantStock number := 0;
    quantVend number := 0;
    temp number;
BEGIN
    for item in cur loop
        quantStock := quantStock + item.quant_em_stock;
        
        select sum(quantidade) into temp from vendas where codigo_livro = item.codigo_livro;
        if temp > 0 then
            quantVend := quantVend + temp;
        end if;
    end loop;
    insert into temp values (quantStock,quantVend,'Informática');
END;
/
--ex11
DECLARE
    cursor cur is
        select titulo,quant_em_stock,paginas
        from livros;
BEGIN
    for item in cur loop
        insert into temp values (item.quant_em_stock,item.paginas,item.titulo);
    end loop;
END;
/
--ex12
DECLARE
    cursor cur is
        select codigo_autor,nome
        from autores;
    tempQuant number;
BEGIN
    for item in cur loop
        select count(titulo) into tempQuant from livros where codigo_autor=item.codigo_autor and genero='Informática';
        insert into temp values (item.codigo_autor,tempQuant,reverse(item.nome));
    end loop;
END;
/
--ex13
DECLARE
    cursor cur is
        select codigo_autor,genero_preferido,nome
        from autores;
    total_livros number;
    total_preferido number;
BEGIN
    for item in cur loop
        select count(*) into total_livros from livros
            where codigo_autor=item.codigo_autor;
        select count(*) into total_preferido from livros
            where codigo_autor=item.codigo_autor and genero=item.genero_preferido;
        insert into temp values (total_livros,total_preferido,  substr(item.nome,1,instr(item.nome,' ')-1)   );
    end loop;
END;
/
--ex14
DECLARE
    cursor cur is
        select codigo_autor,genero_preferido,nome
        from autores;
    cursor lirvos (cod_autor number) is
        select codigo_livro
        from livros
        where codigo_autor = cod_autor and genero='Informática';
    total_livros number;
    quant number := 0;
    temp number;
    sum_total number := 0;
BEGIN
    for item in cur loop
        for livro in lirvos(item.codigo_autor) loop
            select sum(quantidade) into temp from vendas 
            where codigo_livro=livro.codigo_livro;
            if temp is not null then
                quant := quant + temp;
            end if;
        end loop;        
        
        sum_total := sum_total + quant;
        quant := 0;
    end loop;


    for item in cur loop
        for livro in lirvos(item.codigo_autor) loop
            select sum(quantidade) into temp from vendas 
            where codigo_livro=livro.codigo_livro;
            if temp is not null then
                quant := quant + temp;
            end if;
        end loop;        
    
        if quant > 3 then
            insert into temp values (sum_total, quant, item.nome);
        end if;
        quant := 0;
    end loop;
END;
/




