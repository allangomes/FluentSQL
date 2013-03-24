FluentSQL
=========

SELECT
--------
    TSQL.Select('CLIENTE.ID, CLIENTE.NOME, CLIENTE.CIDADE_ID, CIDADE.NOME')
        .From('CLIENTE')
        .Inner('CIDADE', 'CID')
        .Where
          .Eq('CLIENTE.CARGO', 'DESENVOLVEDOR')
          .Eq('CLIENTE.IDADE', 21)
          .Eq('CLIENTE.SALARIO', 3200)
          .Eq('CLIENTE.DATANASC', EncodeDateTime(1992, 03, 01, 09, 0, 0, 0))
          .Inn('CLIENTE.ID', [1,2,3,4])
        .ToSQL;
======== 
    SELECT CLIENTE.ID, CLIENTE.NOME, CLIENTE.CIDADE_ID, CIDADE.NOME
    FROM CLIENTE 
    INNER JOIN CIDADE CID ON (CID.ID = CLIENTE.CIDADE_ID)
    WHERE CLIENTE.CARGO = 'DESENVOLVEDOR'
      AND CLIENTE.IDADE = 21
      AND CLIENTE.SALARIO = 3200
      AND CLIENTE.DATANASC = '03/01/1992 09:00:00'
      AND CLIENTE.ID IN (1,2,3,4)
________

INSERT
--------
    TSQL.Insert('CLIENTE')
          .Value('ID', 17)
          .Value('NOME', 'ALLAN')
          .Value('IDADE', 21)
          .Value('CIDADE', 'FORTALEZA')
          .Value('UF', 'CEARÁ')
          .Param('DATANASC').ToSQL;
======== 
    INSERT INTO CLIENTE (ID,NOME,IDADE,CIDADE,UF,DATANASC) VALUES (17,'ALLAN',21,'FORTALEZA','CEARÁ',:DATANASC)
________

UPDATE
-------
    TSQL.Update('CLIENTE')
          .Value('NOME', 'Allan Maia Gomes')
          .Value('IDADE', 21)
          .Value('DATANASC', EncodeDateTime(1992, 03, 01, 0, 0, 0, 0))
          .Value('SALARIO', 3500)
        .Where
          .Eq('ID', 17).ToSQL;
=====
    UPDATE CLIENTE SET 
      NOME = 'Allan Maia Gomes',
      IDADE = 21,
      DATANASC = '03/01/1992 00:00:00',
      SALARIO = 3500
    WHERE ID = 17
________

DELETE
--------
    TSQL.Delete('CLIENTE')
        .Where
          .Inn('ID', [1,2,3,4,5,6,7])
        .ExecSQL;
======== 
    DELETE FROM CLIENTE 
    WHERE ID IN (1,2,3,4,5,6,7)
________
