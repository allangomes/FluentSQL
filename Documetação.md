TSQL
-------
    function: Select(Fields: string): ISelectSQL
      Params:
        Fields: Os campos que irão aparecer no select.                
      Ex: Select('DISTINCT CLIENTE.CODIGO, CLIENTE.NOME')
      ReturnSQL: 'SELECT DISTINCT CLIENTE.CODIGO, CLIENTE.NOME'
    ----------------------------------------------------  
    function: Insert(Table: string): IInsertSQL
      Params:
        Table: Tabela em que deseja inserir registro
      Ex: Insert('CLIENTE')
      ReturnSQL: 'INSERT INTO CLIENTE'
    ----------------------------------------------------
    function: Update(Table: string): IUpdateSQL
      Params:
        Table: Tabela em que deseja atualizar registro
      Ex: Update('CLIENTE')
      ReturnSQL: 'UPDATE CLIENTE SET'
    ----------------------------------------------------  
    function: Delete(Table: string): IDeleteSQL
      Params:
        Table: Tabela em que deseja deletar registro
      Ex: Delete('CLIENTE')
      ReturnSQL: 'DELETE FROM CLIENTE'
ISelectSQL
--------
    function: From(Table: string): IFromSQL
      Params:
        Table: Tabela em que deseja realizar consulta
      Ex: From('CLIENTE')
      ReturnSQL: 'FROM CLIENTE'
IInsertSQL
--------
    function: Value(Field: string; Value: Variant; ValueEmpty: TValueEmpty = SetNull): IUpdateSQL; overload;
      Params:
        Field: Campo que desejar inserir o valor.          
        Value: Valor que deseja atribuir ao campo informado.          
        [ValueEmpty]: Tratamento do valor caso ele seja vazio. DEFAULT: SetNull
      Ex: Value('DATANASC', EncodeDate(1992, 03, 01), ExceptEmpty)
      ReturnSQL: '(DATANASC) VALUES ('03/01/1992 00:00:00')'
    ----------------------------------------------------------
    function: Param(Field: string): IUpdateSQL; overload;      
      Params:
        Field: Campo que desejar inserir o valor e que também tera o nome do parâmetro
      Ex: Param('CODIGO')
      ReturnSQL: '(CODIGO) VALUES (:CODIGO)'
IUpdateSQL
--------
    function: Value(Field: string; Value: Variant; ValueEmpty: TValueEmpty = SetNull): IUpdateSQL; overload;
      Params:
        Field: Campo que desejar atualizar o valor.          
        Value: Valor que deseja atribuir ao campo informado.          
        [ValueEmpty]: Tratamento do valor caso ele seja vazio. DEFAULT: SetNull
      Ex: Value('DATANASC', EncodeDate(1992, 03, 01), ExceptEmpty)
      ReturnSQL: 'DATANASC = '03/01/1992 00:00:00''
    ----------------------------------------------------------
    function: Param(Field: string): IUpdateSQL; overload;      
      Params:
        Field: Campo que desejar atualizar o valor e que também tera o nome do parâmetro
      Ex: Param('CODIGO')
      ReturnSQL: 'CODIGO = :CODIGO'
    ----------------------------------------------------------          
    function: Where: IWhereSQL;
IDeleteSQL
--------
    function Where: IWhereSQL;    
IFromSQL
--------
    function Inner(Table: string; Alias: string = ''): IJoinSQL;
      Ex: Inner('CIDADE', 'CID')
      ReturnSQL: 'INNER JOIN CIDADE CID ON '
    function Left(Table: string; Alias: string = ''): IJoinSQL;
      Ex: Left('CIDADE', 'CID')
      ReturnSQL: 'LEFT JOIN CIDADE CID ON '
    function Outer(Table: string; Alias: string = ''): IJoinSQL;
      Ex: Left('CIDADE', 'CID')
      ReturnSQL: 'OUTER JOIN CIDADE CID ON '
    function Group(Fields: string): IGroupSQL;
      Ex: Group('CLIENTE.IDADE')
      ReturnSQL: 'GROUP BY CLIENTE.IDADE'
    function Order(Fields: string): IOrderSQL;
      Ex: Order('CLIENTE.IDADE')
      ReturnSQL: 'ORDER BY CLIENTE.IDADE'
    function Where: IWhereSQL;
IWhereSQL
--------
    function BeginIF(Condition: Boolean): IWhereSQL;
      Params:
        Condition: Caso o valor do parametro Condition seja falso, desconsidera todas as condições até o ElseIF ou EndIF
      Ex: BeginIF(RetornaClientesMaioresDeIdade)
            .GtOrEq('CLIENTE.IDADE', 18)
      ReturnSQL: Se verdadeiro add 'AND CLIENTE.IDADE >= 18' na Clausula WHERE      
    ------------------------------------------------------------------      
    function ElseIF(Condition: Boolean = True): IWhereSQL;
      Params:
        Condition: Caso as condições anteriores sejam falsas e esta seja verdadeira então add todas as condições até o ElseIF ou EndIF
      Ex: ElseIF(RetornaClientesIdosos)
            .GtOrEq('CLIENTE.IDADE', 65)
      ReturnSQL: Se verdadeiro add 'AND CLIENTE.IDADE >= 65' na Clausula WHERE
    ------------------------------------------------------------------
    function EndIF: IWhereSQL;
      Descrição: Finaliza as condições acima.
    ------------------------------------------------------------------
    function IfThen(Condition: Boolean): IWhereSQL;
      Params:
        Condition: Caso seja verdadeira add a condição posterior se não a desconsidera.
      Ex: IfThen(RetornaClientesIdosos)
            .GtOrEq('CLIENTE.IDADE', 65)
      ReturnSQL: Se verdadeiro add 'AND CLIENTE.IDADE >= 65' na Clausula WHERE
    ------------------------------------------------------------------
    function Andd(Condition: string): IWhereSQL;  
      Params:
        Condition: Adiciona a condicão acima na clausula WHERE concatenando com AND ou WHERE
      Ex: Andd('((CLIENTE.NOME = NULL) or (CLIENTE.NOME = ''))') 
      ReturnSQL: 'AND ((CLIENTE.NOME = NULL) OR (CLIENTE.NOME = ''))' ou
                 'WHERE ((CLIENTE.NOME = NULL) OR (CLIENTE.NOME = ''))' (se for primeira condição)    
    ------------------------------------------------------------------                 
    function Inn(Field: string; Values: string): IWhereSQL; overload;
      Params:
        Field: Campo em que deseja incluir condição
        Values: Valores separado por "Virgula" ou "Ponto e Virgula" 
          PS: Entre Parenteses ou não
        Ex: Inn('CLIENTE.CODIGO', '1, 2, 3, 4'); ou 
            Inn('CLIENTE.CODIGO', 'SELECT CODIGOCLIENTE FROM CONTASAPAGAR');
        ReturnSQL: 'AND CLIENTE.CODIGO IN (1, 2, 3, 4)' or
                   'AND CLIENTE.CODIGO IN (SELECT CODIGOCLIENTE FROM CONTASAPAGAR)'
    ------------------------------------------------------------------
    function Inn(Field: string; Values: array of Variant): IWhereSQL; overload;
    Params:        
        Values: Array de valores String, Integer, Data....          
        Ex: Inn('CLIENTE.CODIGO', [1, 2, 3, 4]);
        ReturnSQL: 'AND CLIENTE.CODIGO IN (1, 2, 3, 4)'
    ------------------------------------------------------------------
    function Eq(Field: string): IWhereSQL; overload;
      Params:        
        Field: Campo em que deseja incluir condição usando parametro
      Ex: Eq('CLIENTE.CODIGO')
      ReturnSQL: 'AND CLIENTE.CODIGO = :CLIENTE_CODIGO'
    ------------------------------------------------------------------      
    function Gt(Field: string): IWhereSQL; overload;    
      ReturnSQL: 'AND CLIENTE.CODIGO > :CLIENTE_CODIGO'
    ------------------------------------------------------------------
    function Lt(Field: string): IWhereSQL; overload;
      ReturnSQL: 'AND CLIENTE.CODIGO < :CLIENTE_CODIGO'
    ------------------------------------------------------------------
    function GtOrEq(Field: string): IWhereSQL; overload;
      ReturnSQL: 'AND CLIENTE.CODIGO >= :CLIENTE_CODIGO'
    ------------------------------------------------------------------
    function LtOrEq(Field: string): IWhereSQL; overload;
      ReturnSQL: 'AND CLIENTE.CODIGO <= :CLIENTE_CODIGO'
    ------------------------------------------------------------------      
    function Lk(Field: string): IWhereSQL; overload;
      ReturnSQL: 'AND CLIENTE.NOME LIKE :CLIENTE_NOME'
    ------------------------------------------------------------------
    function Eq(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
      Params:        
        Field: Campo em que deseja incluir condição
        Value: Valor para condição (Integer, TDateTime, String, Double)
        ValueEmpty: Forma que deseja ser tratado caso valor seja vazio
      Ex: Eq('CLIENTE.CODIGO', 17)
      SQL: 'AND CLIENTE.CODIGO = 17'
    ------------------------------------------------------------------
    function Gt(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
      Ex: Gt('CLIENTE.CODIGO', 0, DidEmpty)
      SQL: 'AND CLIENTE.CODIGO > 0'
    ------------------------------------------------------------------
    function Lt(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
      Ex: Lt('CLIENTE.CODIGO', 0)
      SQL: '' PS: Valor é vazio e por padrão ignora caso seja vazio.
    ------------------------------------------------------------------
    function GtOrEq(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
      Ex: GtOrEq('CLIENTE.SALARIO', 3000.5)
      SQL: 'CLIENTE.SALARIO >= 3000.5'
    ------------------------------------------------------------------
    function LtOrEq(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
      Ex: LtOrEq('CLIENTE.SALARIO', 0, ExceptEmpty)
      SQL: ''  Lança uma execeção do tipo ESQLValueEmpty
    ------------------------------------------------------------------
    function Between(Field: string; MinValue, MaxValue: Variant): IWhereSQL; overload;
      PS:
          Caso seja passado Data (Somente Data sem Hora no Valor Maximo) então acrecenta mais um Dia na Data Final para pegar todo o dia.
      Ex:
          Between('DATAVENC', EncodeDate(2013, 03, 01), EncodeDate(2013, 04, 10))
      SQL:
          'AND DATAVENC BETWEEN '03/01/2013' AND '04/11/2013''
    ------------------------------------------------------------------
    function Lk(Field: string; Value: string; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
      Ex: Lk('NOME', '%All') 
      SQL: 'AND NOME LIKE '%All''
    function Group(Fields: string): IGroupSQL;    
    function Order(Fields: string): IOrderSQL;
IJoin
    //    Caso não seja chamada a função Eq apos o metódo Inner, Left, Outer ou Right então
    //  é usado uma convenção que pode ser mudada na variavel global SQLConvetions.
    
    function Eq(FieldInner: string; FieldFrom: string): IJoinSQL;
      Ex: TSQL.Select('').From('CLIENTE')
              .Inner('CIDADE').Eq('CODIGO', 'CIDADE')
      SQL: '(CIDADE.CODIGO = CLIENTE.CIDADE)'  
      //Perceba que automaticamente ele add CIDADE e CLIENTE. Isso só ocorre quando não tiver "."
      Ex: TSQL.Select('').From('CLIENTE')
              .Left('CLIENTE', 'PAI')
              .Left('CIDADE', 'CID_PAI').Eq('CODIGO', 'PAI.CIDADE')
      SQL: '(CID_PAI.CODIGO = PAI.CIDADE)'
      
_______________________________________

Convenções
---------------
      unit FluentSQLConventions
      
      TSQLConventions   
        FormatDateTimeSQL   =  'MM/dd/yyyy hh:mm:ss'
          Utilizado para converter um valor do tipo DateTime para SQL
        PrimaryKeyName      =  'ID'
          Chave primaria da Tabela para Auxiliar ao fazer Join com outra table sem precisar informar os campos
        ForeingKeyName      =  '$(TABLE)_ID';
          Chave primaria da Tabela para Auxiliar ao fazer Join com outra table sem precisar informar os campos        
      end;
      
      PS: $(TABLE) é uma variavel que é substituida pelo nome da tabela que contem a chave primaria.
      
      Você pode mudar a convenção da propridade PrimaryKeyName por exemplo para:
         'CODIGO'  ou   '$(TABLE)_ID'.
         
      Para isso use a unit FluentSQLConventions. e acesse o objeto publico SQLConventions.
