create or replace function prendas_em_falta(codigo number,nome varchar) return number as
    nomeInst varchar2(250);
    countInst number(3);
    codInst number(3);
    quantNecessaria number(3);
    quantRecebida number(3);
begin

    select count(codInstit) into countInst
    from instituicao
    where nomeInst = nome;
    
    if countInst = 0 then
        raise_application_error(-20511,'Institulição '+ nomeInst +' inexistente');
    end if;
    
    select codInstit  into codInst
    from instituicao
    where rownum < 2 and nomeInst = nome;
    
    select quantidade into quantNecessaria
    from necessita
    where codPrenda = codigo and codInstit = codInst
        and ano = to_char(sysdate,'YYYY');
    
    if quantNecessaria is null then
        raise_application_error(-20512,'A Instituição ' + nomeInst + ' não indicou as prendas que necessita.');
    end if;
       
    select sum(nPrendas) into quantRecebida
    from doacao
    where codPrenda = codigo and codInstit = codInst and to_char(dataDoacao,'YYYY')=to_char(sysdate,'YYYY');

    return quantNecessaria - quantRecebida;
end;
/

CREATE PROCEDURE PRENDAS_POR_INSTITUICAO(tipo_Prenda VARCHAR2, nomeInstit VARCHAR2) as
    institInexistente exception;
    pragma exception_init( institInexistente, -20511 );
    naoIndPrend exception;
    pragma exception_init( naoIndPrend, -20512 );
begin
    delete from temp;
    for prenda in (select * from prenda where tipoPrenda = tipo_Prenda) loop
        insert into temp values (prenda.codPrenda,prendas_em_falta(prenda.codPrenda,nomeInstit),prenda.nome);     
    end loop;
exception
    when institInexistente then
        insert into temp values (prenda.codPrenda,SQLCODE,prenda.nome);     
    when naoIndPrend then
        insert into temp values (prenda.codPrenda,SQLCODE,prenda.nome);     
    when others then return;
end;
/

CREATE TRIGGER ALTERACAO_NPRENDAS_DOADAS
    
