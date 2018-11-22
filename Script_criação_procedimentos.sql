

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