// Alunos:
// Guilherme Jucoski da Silva RA: 138642
// Matheus Henrique Borsato RA: 138246

import gleam/int
import gleam/list
import gleam/string
import sgleam/check

/// As quatro operações que são utilizadas pela calculadora.
pub type Operadores {
  Adicao
  Subtracao
  Multiplicacao
  Divisao
}

/// Os simbolos usados em uma representação posfixa de uma expressão.
pub type Simbolo {
  // Um operador aritmético (+, -, *, /) convertido para o tipo *Operadores*.
  Operador(operador: Operadores)
  // Um valor numérico que aparece na expressão.
  Operando(valor: Float)
}

/// Os simbolos usados em uma representação infixa de uma expressão.
pub type SimboloInfixo {
  // Um operador aritmético (+, -, *, /) convertido para o tipo *Operadores*.
  OperadorInfixo(operador: Operadores)
  // Um valor numérico que aparece na expressão.
  OperandoInfixo(valor: Float)
  // Um parêntese de abertura encontrado na expressão.
  AbreParenteses
  // Um parêntese de fechamento encontrado na expressão.
  FechaParenteses
}

/// Representa uma estrutura usada no processo de conversão de uma expressão
/// infixa para uma no formato posfixa.
pub type Tupla {
  // Uma pilha contendo os símbolos infixos ainda a serem processados,
  // e a lista final de símbolos em notação posfixa.
  Tupla(p: List(SimboloInfixo), s: List(Simbolo))
}

/// Representa os possíveis erros no processo de conversão de uma expressão infixa para um valor.
pub type Erro {
  DivisaoPorZero
  ParentesesDesbalanceados
  SimboloInvalido
  ExpressaoIncompleta
  ExpressaoVazia
}

/// Devolve o valor da avaliação de uma expressão com notação posfixa
/// representada pelos elementos de *lst*.
/// Requer que a expressão esteja correta em relação à notação.
///
/// Na notação posfixa, o operador aparece após seus dois operandos,
/// não sendo necessários parênteses, pois a ordem dos símbolos define a precedência.
/// Caso a expressão esteja inválida, retorna Error(Erro).
/// *Erro* descreve o tipo de erro correspondente que pode ser
/// DivisaoPorZero, ParentesesDesbalanceados, SimboloInvalido,
/// ExpressaoIncompleta e ExpressaoVazia.
pub fn avalia_posfixa(lst: List(Simbolo)) -> Result(Float, Erro) {
  resultado_pilha(list.fold(lst, Ok([]), processa_simbolo))
}

pub fn avalia_posfixa_examples() {
  check.eq(avalia_posfixa([]), Error(ExpressaoVazia))
  check.eq(avalia_posfixa([Operando(1.0)]), Ok(1.0))
  check.eq(
    avalia_posfixa([Operando(2.0), Operando(3.0), Operador(Multiplicacao)]),
    Ok(6.0),
  )
  check.eq(
    avalia_posfixa([Operando(0.0), Operando(3.0), Operador(Adicao)]),
    Ok(3.0),
  )
  check.eq(
    avalia_posfixa([Operando(1.0), Operando(3.0), Operador(Subtracao)]),
    Ok(-2.0),
  )
  check.eq(
    avalia_posfixa([Operando(6.0), Operando(3.0), Operador(Divisao)]),
    Ok(2.0),
  )
  check.eq(
    avalia_posfixa([
      Operando(0.0),
      Operando(3.0),
      Operador(Adicao),
      Operando(4.0),
      Operador(Multiplicacao),
    ]),
    Ok(12.0),
  )
  check.eq(
    avalia_posfixa([
      Operando(15.0),
      Operando(2.0),
      Operando(7.0),
      Operador(Subtracao),
      Operador(Divisao),
    ]),
    Ok(-3.0),
  )
}

/// Processa *s*, um símbolo da expressão posfixa,
/// utilizando *acc*, uma pilha auxiliar.
///
/// - Se já houver erro acumulado, ele é propagado.
/// - Se o símbolo for um operando, empilha o valor em *acc*.
/// - Se for um operador, tenta realizar a operação sobre os dois valores do topo de *acc*,
///  retirando eles da pilha e empilhando o resultado, posteriormente.
/// - Caso a operação não seja possível, devolve o erro segundo a situação.
pub fn processa_simbolo(
  acc: Result(List(Float), Erro),
  s: Simbolo,
) -> Result(List(Float), Erro) {
  case s, acc {
    _, Error(a) -> Error(a)
    Operando(valor), Ok(a) -> Ok([valor, ..a])
    Operador(op), Ok([segundo_argumento, primeiro_argumento, ..resto]) ->
      case realiza_operacao(op, primeiro_argumento, segundo_argumento) {
        Ok(resultado) -> Ok([resultado, ..resto])
        Error(a) -> Error(a)
      }
    Operador(_), _ -> Error(ExpressaoIncompleta)
  }
}

pub fn processa_simbolo_examples() {
  check.eq(
    processa_simbolo(Error(DivisaoPorZero), Operando(2.0)),
    Error(DivisaoPorZero),
  )
  check.eq(processa_simbolo(Ok([]), Operando(5.0)), Ok([5.0]))
  check.eq(
    processa_simbolo(Ok([4.0, -3.0]), Operando(5.0)),
    Ok([5.0, 4.0, -3.0]),
  )
  check.eq(processa_simbolo(Ok([2.0, 3.0]), Operador(Adicao)), Ok([5.0]))
  check.eq(processa_simbolo(Ok([-12.0, 3.0]), Operador(Divisao)), Ok([-0.25]))
  check.eq(
    processa_simbolo(Ok([0.0, 10.0]), Operador(Divisao)),
    Error(DivisaoPorZero),
  )
  check.eq(
    processa_simbolo(Ok([]), Operador(Adicao)),
    Error(ExpressaoIncompleta),
  )
  check.eq(
    processa_simbolo(Ok([2.0]), Operador(Adicao)),
    Error(ExpressaoIncompleta),
  )
}

/// Calcula o resultado da aplicação de *operador*
/// sobre dois valores retirados da pilha de resolução
/// de uma expressão em notação posfixa.
///
/// - O *segundo_argumento* é o último valor empilhado,
///   ou seja, o operando da direita na expressão.
/// - O *primeiro_argumento* é o valor empilhado antes dele,
///   ou seja, o operando da esquerda.
///
/// Em caso de divisão por zero, o erro é informado.
pub fn realiza_operacao(
  operador: Operadores,
  primeiro_argumento: Float,
  segundo_argumento: Float,
) -> Result(Float, Erro) {
  case operador {
    Adicao -> Ok(primeiro_argumento +. segundo_argumento)
    Subtracao -> Ok(primeiro_argumento -. segundo_argumento)
    Multiplicacao -> Ok(primeiro_argumento *. segundo_argumento)
    Divisao if segundo_argumento != 0.0 ->
      Ok(primeiro_argumento /. segundo_argumento)
    Divisao -> Error(DivisaoPorZero)
  }
}

pub fn realiza_operacao_examples() {
  check.eq(realiza_operacao(Adicao, 4.5, -2.5), Ok(2.0))
  check.eq(realiza_operacao(Adicao, -2.5, 4.5), Ok(2.0))
  check.eq(realiza_operacao(Subtracao, 4.5, -2.5), Ok(7.0))
  check.eq(realiza_operacao(Subtracao, -2.5, 4.5), Ok(-7.0))
  check.eq(realiza_operacao(Multiplicacao, 4.5, -2.5), Ok(-11.25))
  check.eq(realiza_operacao(Multiplicacao, -2.5, 4.5), Ok(-11.25))
  check.eq(realiza_operacao(Divisao, 4.5, -2.5), Ok(-1.8))
  check.eq(realiza_operacao(Divisao, 0.0, -2.5), Ok(0.0))
  check.eq(realiza_operacao(Divisao, 4.5, 0.0), Error(DivisaoPorZero))
}

/// Avalia *pilha*, devolvendo o resultado final da expressão.
///
/// - Se a pilha estiver vazia, devolve Error(ExpressaoVazia).
/// - Se a pilha conter exatamente um valor, esse valor é o resultado da avaliação.
/// - Se a pilha conter mais de um valor, devolve Error(ExpressaoIncompleta).
/// - Se já houver um erro acumulado durante o processamento, ele é propagado.
pub fn resultado_pilha(pilha: Result(List(Float), Erro)) -> Result(Float, Erro) {
  case pilha {
    Ok([]) -> Error(ExpressaoVazia)
    Ok([valor]) -> Ok(valor)
    Ok(_, ..) -> Error(ExpressaoIncompleta)
    Error(a) -> Error(a)
  }
}

pub fn resultado_pilha_examples() {
  check.eq(resultado_pilha(Ok([])), Error(ExpressaoVazia))
  check.eq(resultado_pilha(Ok([42.0])), Ok(42.0))
  check.eq(resultado_pilha(Ok([1.0, 2.0])), Error(ExpressaoIncompleta))
  check.eq(resultado_pilha(Ok([5.0, 3.0, 4.0])), Error(ExpressaoIncompleta))
  check.eq(resultado_pilha(Error(DivisaoPorZero)), Error(DivisaoPorZero))
}

/// Converte uma expressão escrita em notação infixa com os símbolos
/// em *lst* para notação posfixa.
///
/// A notação infixa consiste em operadores entre operandos, 
/// onde operadores de multiplicação e divisão tem prioridade maior. 
/// A notação infixa também contém parenteses para mudar 
/// a prioridade das operações (Exemplo: 3 + 3 * 5 = 18).
///
/// A notação posfixa consiste nos dois operandos escritos 
/// antes do operador (Exemplo: 3 5 * 3 + = 18)
///
/// Caso a expressão estiver inválida, retorna Error(Erro).
/// *Erro* descreve o tipo de erro correspondente que pode ser
/// ParentesesDesbalanceados e SimboloInvalido.
pub fn converte_infixa(lst: List(SimboloInfixo)) -> Result(List(Simbolo), Erro) {
  let resultado: Result(Tupla, Erro) =
    list.fold(
      lst,
      Ok(Tupla([], [])),
      fn(acc: Result(Tupla, Erro), simbolo: SimboloInfixo) -> Result(
        Tupla,
        Erro,
      ) {
        case simbolo, acc {
          _, Error(a) -> Error(a)
          OperandoInfixo(valor), Ok(Tupla(p, s)) ->
            Ok(Tupla(p, list.append(s, [Operando(valor)])))
          AbreParenteses, Ok(Tupla(p, s)) -> Ok(Tupla([AbreParenteses, ..p], s))
          OperadorInfixo(operador), Ok(t) -> compara_operadores(t, operador)
          FechaParenteses, Ok(t) -> fecha_parenteses(t)
        }
      },
    )
  case resultado {
    Error(a) -> Error(a)
    Ok(t) -> desempilha_restantes(t.p, t.s)
  }
}

pub fn converte_infixa_examples() {
  check.eq(converte_infixa([]), Ok([]))
  check.eq(converte_infixa([OperandoInfixo(30.0)]), Ok([Operando(30.0)]))
  check.eq(
    converte_infixa([
      OperandoInfixo(30.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(20.0),
    ]),
    Ok([Operando(30.0), Operando(20.0), Operador(Adicao)]),
  )
  check.eq(
    converte_infixa([
      OperandoInfixo(15.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(10.0),
      OperadorInfixo(Multiplicacao),
      OperandoInfixo(5.0),
    ]),
    Ok([
      Operando(15.0),
      Operando(10.0),
      Operando(5.0),
      Operador(Multiplicacao),
      Operador(Adicao),
    ]),
  )
  check.eq(
    converte_infixa([
      AbreParenteses,
      OperandoInfixo(25.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(5.0),
      FechaParenteses,
      OperadorInfixo(Multiplicacao),
      OperandoInfixo(2.0),
    ]),
    Ok([
      Operando(25.0),
      Operando(5.0),
      Operador(Adicao),
      Operando(2.0),
      Operador(Multiplicacao),
    ]),
  )
  check.eq(converte_infixa([AbreParenteses, FechaParenteses]), Ok([]))

  check.eq(
    converte_infixa([AbreParenteses, OperandoInfixo(20.0), FechaParenteses]),
    Ok([Operando(20.0)]),
  )

  check.eq(converte_infixa([OperadorInfixo(Adicao)]), Ok([Operador(Adicao)]))

  check.eq(
    converte_infixa([
      OperandoInfixo(1.0),
      OperandoInfixo(3.0),
      OperadorInfixo(Adicao),
    ]),
    Ok([Operando(1.0), Operando(3.0), Operador(Adicao)]),
  )

  check.eq(
    converte_infixa([OperandoInfixo(0.0), OperadorInfixo(Multiplicacao)]),
    Ok([Operando(0.0), Operador(Multiplicacao)]),
  )
  check.eq(
    converte_infixa([FechaParenteses, AbreParenteses]),
    Error(ParentesesDesbalanceados),
  )
}

/// Desempilha todos os elementos que restaram em *pilha*, adicionando-os
/// ao fim de *saida*.
/// *saida* é a lista final da conversão infixa para a posfixa e contém apenas operadores e operandos,
/// enquanto a *pilha*, nesse caso, só pode conter elementos do tipo OperadorInfixo.
/// Caso *pilha* tenha elementos inválidos, retorna Error(Erro).
/// *Erro* descreve o tipo de erro correspondente que pode ser
/// ParentesesDesbalanceados e SimboloInvalido.
pub fn desempilha_restantes(
  pilha: List(SimboloInfixo),
  saida: List(Simbolo),
) -> Result(List(Simbolo), Erro) {
  case pilha {
    [] -> Ok(saida)
    [OperadorInfixo(op), ..resto] ->
      desempilha_restantes(resto, list.append(saida, [Operador(op)]))
    [OperandoInfixo(_), ..] -> Error(SimboloInvalido)
    _ -> Error(ParentesesDesbalanceados)
  }
}

pub fn desempilha_restantes_examples() {
  check.eq(desempilha_restantes([], []), Ok([]))
  check.eq(desempilha_restantes([], [Operador(Adicao)]), Ok([Operador(Adicao)]))
  check.eq(
    desempilha_restantes([OperadorInfixo(Adicao)], [
      Operando(10.0),
      Operando(20.0),
    ]),
    Ok([Operando(10.0), Operando(20.0), Operador(Adicao)]),
  )
  check.eq(
    desempilha_restantes([OperadorInfixo(Adicao), OperadorInfixo(Divisao)], [
      Operando(10.0),
      Operando(20.0),
      Operando(3.0),
    ]),
    Ok([
      Operando(10.0),
      Operando(20.0),
      Operando(3.0),
      Operador(Adicao),
      Operador(Divisao),
    ]),
  )
  check.eq(
    desempilha_restantes([AbreParenteses], [Operador(Adicao)]),
    Error(ParentesesDesbalanceados),
  )
  check.eq(
    desempilha_restantes([OperandoInfixo(3.0)], []),
    Error(SimboloInvalido),
  )
}

/// Compara os operadores do topo da pilha de *tupla* e *op*.
/// Enquanto o topo da pilha conter um operador de precedência 
/// maior ou igual a *op*, retira o elemento do topo e adiciona ao final da saida de *tupla*.
/// Caso *op* for de precedência maior ou a pilha de *tupla* estiver vazia, empilha-o na pilha de *tupla*.
/// Caso o topo não for um OperandoInfixo ou AbreParenteses, retorna Error(SimboloInvalido).
pub fn compara_operadores(tupla: Tupla, op: Operadores) -> Result(Tupla, Erro) {
  case tupla {
    Tupla([], s) -> Ok(Tupla([OperadorInfixo(op)], s))
    Tupla([topo, ..resto], s) ->
      case topo {
        AbreParenteses -> Ok(Tupla([OperadorInfixo(op), topo, ..resto], s))
        OperadorInfixo(a) ->
          case precedencia(op, a) {
            True ->
              compara_operadores(
                Tupla(resto, list.append(s, [Operador(a)])),
                op,
              )
            False -> Ok(Tupla([OperadorInfixo(op), topo, ..resto], s))
          }
        _ -> Error(SimboloInvalido)
      }
  }
}

pub fn compara_operadores_examples() {
  check.eq(
    compara_operadores(Tupla([], []), Adicao),
    Ok(Tupla([OperadorInfixo(Adicao)], [])),
  )
  check.eq(
    compara_operadores(Tupla([OperadorInfixo(Multiplicacao)], []), Adicao),
    Ok(Tupla([OperadorInfixo(Adicao)], [Operador(Multiplicacao)])),
  )
  check.eq(
    compara_operadores(Tupla([OperadorInfixo(Adicao)], [Operando(2.0)]), Adicao),
    Ok(Tupla([OperadorInfixo(Adicao)], [Operando(2.0), Operador(Adicao)])),
  )
  check.eq(
    compara_operadores(Tupla([AbreParenteses], [Operando(2.0)]), Adicao),
    Ok(Tupla([OperadorInfixo(Adicao), AbreParenteses], [Operando(2.0)])),
  )
  check.eq(
    compara_operadores(
      Tupla([OperadorInfixo(Multiplicacao), OperadorInfixo(Adicao)], [
        Operando(2.0),
      ]),
      Divisao,
    ),
    Ok(
      Tupla([OperadorInfixo(Divisao), OperadorInfixo(Adicao)], [
        Operando(2.0),
        Operador(Multiplicacao),
      ]),
    ),
  )
  check.eq(
    compara_operadores(
      Tupla([OperadorInfixo(Divisao), FechaParenteses], []),
      Multiplicacao,
    ),
    Error(SimboloInvalido),
  )
  check.eq(
    compara_operadores(Tupla([OperandoInfixo(2.0)], []), Multiplicacao),
    Error(SimboloInvalido),
  )
}

/// Verifica se a precedência do *operador_pilha* é maior ou igual
/// à de *operador_novo*.
/// Operadores de Multiplicacao e Divisao tem precedência igual;
/// Operadores de Adicao e Subtracao tem precedência igual;
/// A precedência de Multiplicacao e Divisao é maior que de Adicao e Subtracao.
pub fn precedencia(
  operador_novo: Operadores,
  operador_pilha: Operadores,
) -> Bool {
  prioridade(operador_pilha) >= prioridade(operador_novo)
}

pub fn precedencia_examples() {
  check.eq(precedencia(Adicao, Adicao), True)
  check.eq(precedencia(Adicao, Subtracao), True)
  check.eq(precedencia(Adicao, Multiplicacao), True)
  check.eq(precedencia(Adicao, Divisao), True)
  check.eq(precedencia(Subtracao, Adicao), True)
  check.eq(precedencia(Subtracao, Subtracao), True)
  check.eq(precedencia(Subtracao, Multiplicacao), True)
  check.eq(precedencia(Subtracao, Divisao), True)
  check.eq(precedencia(Multiplicacao, Adicao), False)
  check.eq(precedencia(Multiplicacao, Subtracao), False)
  check.eq(precedencia(Multiplicacao, Multiplicacao), True)
  check.eq(precedencia(Multiplicacao, Divisao), True)
  check.eq(precedencia(Divisao, Adicao), False)
  check.eq(precedencia(Divisao, Subtracao), False)
  check.eq(precedencia(Divisao, Multiplicacao), True)
  check.eq(precedencia(Divisao, Divisao), True)
}

/// Relaciona um operador *op* com um número que representa a sua prioridade.
/// Adicao e Subtracao -> 1
/// Multiplicacao e Divisao -> 2
pub fn prioridade(op: Operadores) -> Int {
  case op {
    Adicao -> 1
    Subtracao -> 1
    Multiplicacao -> 2
    Divisao -> 2
  }
}

pub fn prioridade_examples() {
  check.eq(prioridade(Adicao), 1)
  check.eq(prioridade(Subtracao), 1)
  check.eq(prioridade(Multiplicacao), 2)
  check.eq(prioridade(Divisao), 2)
}

/// Adiciona o item no topo da pilha de *tupla* ao final
/// de saida de *tupla*, até encontrar um AbreParenteses na pilha.
/// Caso *pilha* tenha elementos inválidos ou o símbolo AbreParenteses, retorna Error(Erro).
/// *Erro* descreve o tipo de erro correspondente que pode ser
/// ParentesesDesbalanceados e SimboloInvalido.
pub fn fecha_parenteses(tupla: Tupla) -> Result(Tupla, Erro) {
  case tupla {
    Tupla([], _) -> Error(ParentesesDesbalanceados)
    Tupla([AbreParenteses, ..resto], s) -> Ok(Tupla(resto, s))
    Tupla([OperadorInfixo(op), ..resto], s) ->
      fecha_parenteses(Tupla(resto, list.append(s, [Operador(op)])))
    Tupla([_, ..], _) -> Error(SimboloInvalido)
  }
}

pub fn fecha_parenteses_examples() {
  check.eq(fecha_parenteses(Tupla([], [])), Error(ParentesesDesbalanceados))
  check.eq(
    fecha_parenteses(Tupla([OperadorInfixo(Adicao)], [])),
    Error(ParentesesDesbalanceados),
  )
  check.eq(
    fecha_parenteses(Tupla([OperandoInfixo(2.0)], [])),
    Error(SimboloInvalido),
  )
  check.eq(
    fecha_parenteses(Tupla([AbreParenteses], [Operando(20.0)])),
    Ok(Tupla([], [Operando(20.0)])),
  )
  check.eq(
    fecha_parenteses(
      Tupla([AbreParenteses, OperadorInfixo(Adicao)], [Operando(20.0)]),
    ),
    Ok(Tupla([OperadorInfixo(Adicao)], [Operando(20.0)])),
  )
  check.eq(
    fecha_parenteses(
      Tupla([OperadorInfixo(Adicao), AbreParenteses], [Operando(30.0)]),
    ),
    Ok(Tupla([], [Operando(30.0), Operador(Adicao)])),
  )
}

/// Calcula o resultado da expressão dos símbolos de *lst*, que representam
/// uma expressão matemática na notação infixa.
/// Retorna o valor final da combinação dos elementos de *lst* ou, caso durante o cálculo, 
/// ocorra algum erro, retorna o respectivo erro em Error(Erro).
/// *Erro* descreve o tipo de erro correspondente que pode ser
/// DivisaoPorZero, ParentesesDesbalanceados, SimboloInvalido,
/// ExpressaoIncompleta e ExpressaoVazia.
pub fn resultado_infixa(lst: List(SimboloInfixo)) -> Result(Float, Erro) {
  let posfixa = converte_infixa(lst)
  case posfixa {
    Ok(valido) -> avalia_posfixa(valido)
    Error(a) -> Error(a)
  }
}

pub fn resultado_infixa_examples() {
  check.eq(resultado_infixa([]), Error(ExpressaoVazia))
  check.eq(
    resultado_infixa([AbreParenteses, FechaParenteses]),
    Error(ExpressaoVazia),
  )
  check.eq(
    resultado_infixa([OperandoInfixo(3.0), OperadorInfixo(Adicao)]),
    Error(ExpressaoIncompleta),
  )
  check.eq(
    resultado_infixa([OperadorInfixo(Divisao)]),
    Error(ExpressaoIncompleta),
  )

  check.eq(
    resultado_infixa([
      OperandoInfixo(3.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(4.0),
      FechaParenteses,
    ]),
    Error(ParentesesDesbalanceados),
  )
  check.eq(
    resultado_infixa([
      AbreParenteses,
      OperandoInfixo(3.0),
      OperadorInfixo(Multiplicacao),
      OperandoInfixo(5.0),
    ]),
    Error(ParentesesDesbalanceados),
  )
  check.eq(
    resultado_infixa([
      OperandoInfixo(3.0),
      OperadorInfixo(Divisao),
      OperandoInfixo(0.0),
    ]),
    Error(DivisaoPorZero),
  )
  check.eq(resultado_infixa([OperandoInfixo(30.0)]), Ok(30.0))

  check.eq(
    resultado_infixa([
      OperandoInfixo(3.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(3.0),
    ]),
    Ok(6.0),
  )

  check.eq(
    resultado_infixa([
      OperandoInfixo(3.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(3.0),
      OperadorInfixo(Multiplicacao),
      OperandoInfixo(5.0),
    ]),
    Ok(18.0),
  )

  check.eq(
    resultado_infixa([
      AbreParenteses,
      OperandoInfixo(3.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(3.0),
      FechaParenteses,
      OperadorInfixo(Multiplicacao),
      OperandoInfixo(5.0),
    ]),
    Ok(30.0),
  )

  check.eq(
    resultado_infixa([
      OperandoInfixo(3.0),
      OperadorInfixo(Multiplicacao),
      OperandoInfixo(3.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(5.0),
    ]),
    Ok(14.0),
  )

  check.eq(
    resultado_infixa([
      OperandoInfixo(45.0),
      OperadorInfixo(Subtracao),
      OperandoInfixo(100.0),
      OperadorInfixo(Divisao),
      OperandoInfixo(25.0),
    ]),
    Ok(41.0),
  )

  check.eq(
    resultado_infixa([
      OperandoInfixo(2.0),
      OperadorInfixo(Multiplicacao),
      AbreParenteses,
      OperandoInfixo(3.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(4.0),
      OperadorInfixo(Multiplicacao),
      AbreParenteses,
      OperandoInfixo(5.0),
      OperadorInfixo(Subtracao),
      OperandoInfixo(1.0),
      FechaParenteses,
      OperadorInfixo(Divisao),
      OperandoInfixo(2.0),
      FechaParenteses,
      OperadorInfixo(Subtracao),
      OperandoInfixo(15.0),
    ]),
    Ok(7.0),
  )

  check.eq(
    resultado_infixa([
      AbreParenteses,
      OperandoInfixo(10.0),
      OperadorInfixo(Divisao),
      OperandoInfixo(2.0),
      OperadorInfixo(Subtracao),
      OperandoInfixo(1.0),
      FechaParenteses,
      OperadorInfixo(Multiplicacao),
      AbreParenteses,
      OperandoInfixo(7.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(3.0),
      FechaParenteses,
    ]),
    Ok(40.0),
  )
}

/// Transforma *lst*, uma lista de strings que representam os elementos
/// de uma equação em notação infixa, em uma lista de SimboloInfixo que representam
/// a mesma equação.
/// Caso a equação estiver com algum simbolo inválido, retorna Error(SimboloInvalido)
pub fn converte_lista(lst: List(String)) -> Result(List(SimboloInfixo), Erro) {
  list.fold(
    lst,
    Ok([]),
    fn(acc: Result(List(SimboloInfixo), Erro), str: String) -> Result(
      List(SimboloInfixo),
      Erro,
    ) {
      case acc {
        Error(a) -> Error(a)
        Ok(simbolo) ->
          case str {
            "(" -> Ok(list.append(simbolo, [AbreParenteses]))
            ")" -> Ok(list.append(simbolo, [FechaParenteses]))
            "+" -> Ok(list.append(simbolo, [OperadorInfixo(Adicao)]))
            "-" -> Ok(list.append(simbolo, [OperadorInfixo(Subtracao)]))
            "*" -> Ok(list.append(simbolo, [OperadorInfixo(Multiplicacao)]))
            "/" -> Ok(list.append(simbolo, [OperadorInfixo(Divisao)]))
            _ ->
              case int.parse(str) {
                Ok(n) ->
                  Ok(list.append(simbolo, [OperandoInfixo(int.to_float(n))]))
                _ -> Error(SimboloInvalido)
              }
          }
      }
    },
  )
}

pub fn converte_lista_examples() {
  check.eq(converte_lista([]), Ok([]))
  check.eq(converte_lista(["2"]), Ok([OperandoInfixo(2.0)]))
  check.eq(
    converte_lista(["2", "+", "5"]),
    Ok([OperandoInfixo(2.0), OperadorInfixo(Adicao), OperandoInfixo(5.0)]),
  )
  check.eq(
    converte_lista(["(", "9", "-", "5", ")"]),
    Ok([
      AbreParenteses,
      OperandoInfixo(9.0),
      OperadorInfixo(Subtracao),
      OperandoInfixo(5.0),
      FechaParenteses,
    ]),
  )
  check.eq(
    converte_lista(["3", "+", "5", "*", "6"]),
    Ok([
      OperandoInfixo(3.0),
      OperadorInfixo(Adicao),
      OperandoInfixo(5.0),
      OperadorInfixo(Multiplicacao),
      OperandoInfixo(6.0),
    ]),
  )
  check.eq(converte_lista(["a", "+", "2"]), Error(SimboloInvalido))
}

/// Calcula a expressão em *s* que representa uma expressão matemática na notação infixa.
/// Retorna o valor final de *s* ou, caso durante o cálculo, ocorra algum erro, 
/// retorna o respectivo erro em Error(Erro).
/// Os elementos em *s* precisam estar separados por um espaço (" "), caso contrário,
/// o retorno é indefinido.
pub fn conta(s: String) -> Result(Float, Erro) {
  let lista: List(String) = string.split(s, on: " ")
  case lista {
    [""] -> Error(ExpressaoVazia)
    _ -> {
      let convertida: Result(List(SimboloInfixo), Erro) = converte_lista(lista)
      let posfixa = case convertida {
        Ok(valido) -> converte_infixa(valido)
        Error(a) -> Error(a)
      }
      case posfixa {
        Ok(valido) -> avalia_posfixa(valido)
        Error(a) -> Error(a)
      }
    }
  }
}

pub fn conta_examples() {
  check.eq(conta(""), Error(ExpressaoVazia))
  check.eq(conta("( )"), Error(ExpressaoVazia))
  check.eq(conta("a b c"), Error(SimboloInvalido))
  check.eq(conta("3 +"), Error(ExpressaoIncompleta))
  check.eq(conta("+"), Error(ExpressaoIncompleta))
  check.eq(conta("+ 3"), Error(ExpressaoIncompleta))
  check.eq(conta("3 + 4 )"), Error(ParentesesDesbalanceados))
  check.eq(conta("( 3 + 4"), Error(ParentesesDesbalanceados))
  check.eq(conta("3 / 0"), Error(DivisaoPorZero))
  check.eq(conta("3 + 3"), Ok(6.0))
  check.eq(conta("3 + 3 * 5"), Ok(18.0))
  check.eq(conta("( 3 + 3 ) * 5"), Ok(30.0))
  check.eq(conta("3 * 3 + 5"), Ok(14.0))
  check.eq(conta("3 + 5 * 6"), Ok(33.0))
  check.eq(conta("45 - 100 / 25"), Ok(41.0))
  check.eq(conta("2 * ( 3 + 4 * ( 5 - 1 ) / 2 )"), Ok(22.0))
  check.eq(conta("( 10 / 2 - 1 ) * ( 7 + 3 )"), Ok(40.0))
}
