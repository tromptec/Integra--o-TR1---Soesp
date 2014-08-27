/******************************************************************************
* Cliente:     Tromp
* Programa:    trfunc/pi-retorna-clientes.p
* Objetivo:    Conectar atrav‚s de Web Service no sistema TR1 e integrar 
               clientes
* Data:        27/08/2014
******************************************************************************
* Alteracoes
* 
******************************************************************************/
asdasdasd
/* Includes */
{trinc/proc-gerais.i}
{trinc/webservice.i tr1_webservice_itemPortType} /*M‚todo para incluir Tabela de pre‡o*/

/* Vari veis Locais */
def var c-mensagem      as  char    no-undo.
def var c-token         as  char    no-undo.
def var c-indisponivel  as  char    no-undo.

/*atribui o token do m‚todo na vari vel*/
assign c-token  =   tr-integr-proc.token.

/* Main-block */
run pi-inicializa.

run pi-mensagem (input 'Conectando no webservice...').

do trans:
    
    /* Conecta o webservice */
    run pi-connect.

    /*Percorre as tabelas ativas para serem gravadas no TR1*/
    for each tb-preco no-lock
        where tb-preco.situacao =   1:

        /*chama o m‚todo para gravar a tabela de pre‡o no TR1*/
        run gravaTabPreco IN h-port(input   c-token,
                                    input  tb-preco.nr-tabpre,   /*c¢digo*/
                                    input  tb-preco.descricao,   /*Nome*/
                                    input  tb-preco.dt-inival,   /*validade_inicio*/
                                    input  tb-preco.dt-fimval,   /*validade_fim*/
                                    input  tb-preco.situacao,    /*situacao*/
                                    output c-mensagem).          /*return1*/
    end. 
    
    run pi-disconnect.
    
    /* Trata o erro retornado do Ws */
    run pi-erro-ws (input i-mensagem, output c-mensagem).
    if c-mensagem <> '' then do:
        assign p-mensagem = c-mensagem.
        run pi-finaliza.
        return 'ok':u.
    end.
end.

return 'OK':U.

