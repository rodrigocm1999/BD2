--ex1
create or replace function ex1(ano number) return boolean as
begin
    if mod(ano,4)=0 and mod(ano,4)=0 and mod(ano,4)=0 then
        return true;
    end if;
    return false;
end;
/
--ex2
create or replace function ex2(numero number) return boolean as
begin
    
end;
/