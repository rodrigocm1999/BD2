set serveroutput on;
--ex1
create or replace function ficha5ex1(ano number) return number as
begin
    if mod(ano,4)=0 and not ( mod(ano,100)=0 and mod(ano,400)!=0 ) then
        return 1;
    end if;
    return 0;
end;
/
select ficha5ex1(2016) from dual;
--ex2
create or replace function ficha5ex2(num1 number,num2 number,num3 number) return number as
begin
    if(num1=num2 or num1=num3 or num2=num3) then
        raise_application_error(-20100,'2 numeros iguais');
    end if;
    return num2;
end;
/
select ficha5ex2(3,4,2) from dual;
--ex3
create or replace function ficha5ex3(numero number) return number as
    prime boolean;
begin
    for i in 2..numero-1 loop
    dbms_output.put_line('asd');
        if mod(numero,i)=0 then
            return 0;
        end if;    
    end loop;
    return 1;
end;
/
select ficha5ex3(97) from dual;
--ex4 
create or replace function ficha5ex4(frase_ varchar2) return varchar2 as
    frase varchar2(500) := trim(frase_);
    frase_temp varchar2(500) := trim(frase);
begin
    return substr(frase,length(frase)- instr(frase_temp,' '),length(frase));
end;
/
select ficha5ex4('Boi do U even') from dual;
--ex5
create or replace function ficha5ex5(genero_ varchar2) return varchar2 as
    quant number;
    titulo_livro varchar2(500) := 'Erro';
begin
    select count(genero) into quant from livros;
    if quant=0 then
        raise_application_error(-20300,'Não existe');
    end if;

    select titulo into titulo_livro from livros
        where genero=genero_ and preco_tabela=(select max(preco_tabela) from livros 
                                                where genero=genero_);
        
    return titulo_livro;
end;
/
select ficha5ex6('Informática') from dual;
--ex6
create or replace function ficha5ex6(nome_ varchar2) return number as
    existe number;
    id number;
    quant number;
begin
    select count(codigo_autor) into existe from autores where nome=nome_;
    if existe=0 then
        raise_application_error(-20700,'Não existe');
    end if;

    select codigo_autor into id from autores where nome=nome_;

    select count(codigo_livro) into quant from livros
        where codigo_autor=id;
        
    if quant = 0 then
        raise_application_error(-20800,'Não escreveu livros');
    end if;
    
    return quant;
end;
/
select ficha5ex6('Eurico Fonseca') from dual;
--ex7
create or replace function ficha5ex7(id_cliente number) return varchar2 as
    nome varchar2(500);
    cod_livro number(8);
    
    cursor cur_codigo_livro is
        select codigo_livro into cod_livro
        from vendas 
        where codigo_cliente = id_cliente
        order by data_venda;
begin
    for item in cur_codigo_livro loop
        cod_livro:= item.codigo_livro;
        exit;
    end loop;
   
   select titulo into nome from livros where livros.codigo_livro = cod_livro;
   
   if nome is null or nome = '' then
        return 'Não encontrado';
   end if;
   
   return nome;
end;
/
select ficha5ex7(6000) from dual;
--ex8
create or replace function ficha5ex8(cod_editora number) return number as
    quant number(8);  
begin
    select sum(quantidade*preco_unitario) into quant
    from (
        select codigo_venda
        from vendas,livros
        where vendas.codigo_livro=livros.codigo_livro and codigo_editora = cod_editora
    )x , vendas
    where vendas.codigo_venda = x.codigo_venda;
    return quant;
end;
/
select ficha5ex8(1) from dual;



