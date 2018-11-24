--ex4 Garantir que idade >= 18
create or replace trigger ex4
    before insert or update of idade on autores
    for each row
begin
    if ( :new.idade<18 ) then
        raise_application_error(-20001,'Idade nao pode ser menor que 18');
    end if;
end;
/
update Autores set idade = 17 where codigo_autor=1;
--ex5
create or replace trigger ex5
    before delete on clientes
    for each row
begin
    delete from vendas where codigo_cliente=:old.codigo_cliente;   
end;
/
delete from clientes where codigo_cliente=5;
--ex6
create or replace trigger update_stock
    after insert on vendas
    for each row
begin
    update livros set quant_em_stock = quant_em_stock - :new.quantidade
        where codigo_livro = :new.codigo_livro;
end;
/
create or replace trigger ex6
    before update of quant_em_stock on livros
    for each row
begin
    if :new.quant_em_stock <= 2 then
        :new.preco_tabela := :new.preco_tabela * 1.1;
    end if;
end;
/
