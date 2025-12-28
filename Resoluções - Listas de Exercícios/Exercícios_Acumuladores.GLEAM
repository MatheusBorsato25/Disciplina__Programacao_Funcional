import gleam/int
import gleam/list
import sgleam/check

/// Concatena todos os elementos de *lst*.
/// Se *lst* for vazia, retorna uma string vazia.
pub fn concatena(lst: List(String)) -> String {
  list.fold(lst, "", fn(acc: String, elemento: String) { acc <> elemento })
}

pub fn concatena_examples() {
  check.eq(concatena([]), "")
  check.eq(concatena(["Corinthians"]), "Corinthians")
  check.eq(
    concatena(["Hoje", " é", " um", " belo", " dia."]),
    "Hoje é um belo dia.",
  )
}

/// Devolve a quantidade de números em *lst*.
pub fn quantidade_numeros(lst: List(Int)) -> Int {
  list.fold(lst, 0, fn(acc: Int, _: Int) { acc + 1 })
}

pub fn quantidade_numeros_examples() {
  check.eq(quantidade_numeros([]), 0)
  check.eq(quantidade_numeros([5]), 1)
  check.eq(quantidade_numeros([1, 2, 3, 4, 4, 3, 2, 1]), 8)
}

/// Converte *lst* para uma lista de strings.
pub fn ints_para_strings(lst: List(Int)) -> List(String) {
  list.reverse(
    list.fold(lst, [], fn(acc: List(String), elemento: Int) {
      [int.to_string(elemento), ..acc]
    }),
  )
}

pub fn ints_para_strings_examples() {
  check.eq(ints_para_strings([]), [])
  check.eq(ints_para_strings([2]), ["2"])
  check.eq(ints_para_strings([2, 4, 6, 8]), ["2", "4", "6", "8"])
}

/// Remove as strings vazias de *lst*.
pub fn remove_vazias(lst: List(String)) -> List(String) {
  list.reverse(
    list.fold(lst, [], fn(acc: List(String), elemento: String) {
      case elemento == "" {
        True -> acc
        False -> [elemento, ..acc]
      }
    }),
  )
}

pub fn remove_vazias_examples() {
  check.eq(remove_vazias([]), [])
  check.eq(remove_vazias([""]), [])
  check.eq(remove_vazias(["Corinthians"]), ["Corinthians"])
  check.eq(remove_vazias(["", "Hoje", "Bom", "", "Oi", "", "Tarde"]), [
    "Hoje", "Bom", "Oi", "Tarde",
  ])
}

/// Verifica se todos os elementos de *lst* são verdadeiros.
pub fn todos_true(lst: List(Bool)) -> Bool {
  list.fold(lst, True, fn(acc: Bool, elemento: Bool) { acc && elemento })
}

pub fn todos_true_examples() {
  check.eq(todos_true([]), True)
  check.eq(todos_true([False]), False)
  check.eq(todos_true([True]), True)
  check.eq(todos_true([True, False]), False)
  check.eq(todos_true([True, True]), True)
  check.eq(todos_true([True, True, True]), True)
}

/// Devolve *lst* com os seus elementos em ordem contrária.
pub fn ordem_contraria(lst: List(Int)) -> List(Int) {
  list.fold(lst, [], fn(acc: List(Int), elemento: Int) { [elemento, ..acc] })
}

pub fn ordem_contraria_examples() {
  check.eq(ordem_contraria([]), [])
  check.eq(ordem_contraria([2]), [2])
  check.eq(ordem_contraria([2, 5]), [5, 2])
  check.eq(ordem_contraria([1, 9, 6, 4]), [4, 6, 9, 1])
}

/// Devolve o valor máximo de *lst*.
/// Em caso de *lst* vazia, devolve Error(Nil).
pub fn maximo(lst: List(Int)) -> Result(Int, Nil) {
  list.fold(lst, Error(Nil), fn(acc: Result(Int, Nil), elemento: Int) {
    case acc {
      Error(Nil) -> Ok(elemento)
      Ok(maximo) -> Ok(int.max(maximo, elemento))
    }
  })
}

pub fn maximo_examples() {
  check.eq(maximo([]), Error(Nil))
  check.eq(maximo([5]), Ok(5))
  check.eq(maximo([2, 5, 1, 8, 6, 3]), Ok(8))
  check.eq(maximo([9, 2, 3, 4, 6, 8]), Ok(9))
  check.eq(maximo([2, 5, 4, 6, 7, 15]), Ok(15))
}

/// Converte cada string de *lst* para um inteiro.
/// Devolve Error(Nil) em caso de conversão impossível.
pub fn strings_para_ints(lst: List(String)) -> Result(List(Int), Nil) {
  let conversao: Result(List(Int), Nil) =
    list.fold(lst, Ok([]), fn(acc: Result(List(Int), Nil), s: String) {
      case acc {
        Error(Nil) -> Error(Nil)
        Ok(numeros) ->
          case int.parse(s) {
            Error(Nil) -> Error(Nil)
            Ok(numero) -> Ok([numero, ..numeros])
          }
      }
    })
  case conversao {
    Ok(lista) -> Ok(list.reverse(lista))
    _ -> Error(Nil)
  }
}

pub fn strings_para_ints_examples() {
  check.eq(strings_para_ints([]), Ok([]))
  check.eq(strings_para_ints(["1"]), Ok([1]))
  check.eq(strings_para_ints(["a"]), Error(Nil))
  check.eq(strings_para_ints(["1", "2", "15", "-8"]), Ok([1, 2, 15, -8]))
  check.eq(strings_para_ints(["1", "a", "2"]), Error(Nil))
  check.eq(strings_para_ints(["2", "3", "9", "m"]), Error(Nil))
}

/// Representa uma posição em um mundo aberto tridimensional.
pub type Posicao {
  // As coordenadas x, y e z de uma posição.
  Posicao(x: Int, y: Int, z: Int)
}

/// Representa as possibilidades de deslocamento em um mundo tridimensional.
pub type Deslocamento {
  Leste
  Oeste
  Norte
  Sul
  Cima
  Baixo
}

/// Devolve a nova posição de um personagem em um mundo aberto tridimensional,
/// com base em sua *posicao_inicial* e uma sequência de deslocamentos por todos
/// os eixos *lst_deslocamentos*.
pub fn calcula_posicao(
  posicao_inicial: Posicao,
  lst_deslocamentos: List(Deslocamento),
) -> Posicao {
  list.fold(lst_deslocamentos, posicao_inicial, desloca)
}

pub fn calcula_posicao_examples() {
  let pos1: Posicao = Posicao(0, 0, 0)
  let pos2: Posicao = Posicao(3, -5, 4)

  check.eq(calcula_posicao(pos1, []), pos1)
  check.eq(calcula_posicao(pos1, [Leste]), Posicao(1, 0, 0))
  check.eq(calcula_posicao(pos1, [Sul]), Posicao(0, -1, 0))
  check.eq(calcula_posicao(pos1, [Cima]), Posicao(0, 0, 1))
  check.eq(calcula_posicao(pos1, [Oeste, Norte, Baixo]), Posicao(-1, 1, -1))
  check.eq(
    calcula_posicao(pos1, [Leste, Sul, Baixo, Sul, Leste, Leste, Cima]),
    Posicao(3, -2, 0),
  )
  check.eq(
    calcula_posicao(pos2, [Oeste, Norte, Cima, Cima, Leste, Norte, Baixo]),
    Posicao(3, -3, 5),
  )
}

/// Devolve a nova posição de um personagem em um mundo aberto tridimensional, 
/// com base em sua posição atual *acc* e *movimento*, um deslocamento realizado.
/// O deslocamento representado por *movimento* move o personagem exatamente 
/// uma unidade ao longo de um único eixo, mantendo os demais inalterados:
///  - Leste:  desloca o personagem uma unidade no sentido positivo do eixo X
///  - Oeste:  desloca o personagem uma unidade no sentido negativo do eixo X
///  - Norte:  desloca o personagem uma unidade no sentido positivo do eixo Y
///  - Sul:    desloca o personagem uma unidade no sentido negativo do eixo Y
///  - Cima:   desloca o personagem uma unidade no sentido positivo do eixo Z
///  - Baixo:  desloca o personagem uma unidade no sentido negativo do eixo Z
pub fn desloca(acc: Posicao, movimento: Deslocamento) -> Posicao {
  case movimento {
    Leste -> Posicao(..acc, x: acc.x + 1)
    Oeste -> Posicao(..acc, x: acc.x - 1)
    Norte -> Posicao(..acc, y: acc.y + 1)
    Sul -> Posicao(..acc, y: acc.y - 1)
    Cima -> Posicao(..acc, z: acc.z + 1)
    Baixo -> Posicao(..acc, z: acc.z - 1)
  }
}

pub fn desloca_examples() {
  let pos: Posicao = Posicao(4, 3, -2)

  check.eq(desloca(pos, Leste), Posicao(5, 3, -2))
  check.eq(desloca(pos, Oeste), Posicao(3, 3, -2))
  check.eq(desloca(pos, Norte), Posicao(4, 4, -2))
  check.eq(desloca(pos, Sul), Posicao(4, 2, -2))
  check.eq(desloca(pos, Cima), Posicao(4, 3, -1))
  check.eq(desloca(pos, Baixo), Posicao(4, 3, -3))
}

/// Representa uma conta bancária.
pub type Conta {
  // O saldo atual da conta e a quantidade de vezes em que o saldo ficou
  // negativo durante o processamento de uma sequência de transações.
  Conta(saldo: Float, quantidade_saldos_negativos: Int)
}

/// Calcula o valor total que deve ser doado com base em *saldo_inicial*
/// e em *transacoes*, que contém os gastos (valores negativos) e os
/// recebimentos (valores positivos) registrados em uma conta.
/// O cálculo é feito, considerando-se que, após uma transação, 
/// se o saldo da conta ficar negativo, é contabilizada 
/// uma doação de R$ 10.
pub fn gerencia_conta(saldo_inicial: Float, transacoes: List(Float)) -> Int {
  calcula_valor_doacao(
    list.fold(
      transacoes,
      Conta(saldo_inicial, 0),
      fn(acc: Conta, transacao: Float) {
        let novo_saldo: Float = acc.saldo +. transacao
        case novo_saldo >=. 0.0 {
          True -> Conta(..acc, saldo: novo_saldo)
          False ->
            Conta(
              novo_saldo,
              quantidade_saldos_negativos: acc.quantidade_saldos_negativos + 1,
            )
        }
      },
    ),
  )
}

pub fn gerencia_conta_examples() {
  check.eq(gerencia_conta(10.0, []), 0)
  check.eq(gerencia_conta(10.0, [5.0]), 0)
  check.eq(gerencia_conta(10.0, [-5.0]), 0)
  check.eq(gerencia_conta(50.0, [-10.0, -5.0, 20.0]), 0)
  check.eq(gerencia_conta(2.0, [-5.0]), 10)
  check.eq(gerencia_conta(2.0, [-5.0, -3.0, -2.0]), 30)
  check.eq(gerencia_conta(2.0, [-5.0, 2.0, -2.0]), 30)
  check.eq(gerencia_conta(2.0, [-5.0, 3.0, -2.0]), 20)
  check.eq(
    gerencia_conta(10.0, [-20.0, 15.0, -10.0, -5.0, 10.0, 5.0, -3.0, -5.0]),
    40,
  )
}

/// Calcula o valor total de doações, com base em 
/// *c*, uma conta com a quantidade de doações previstas.
/// Se a quantidade for menor ou igual a 0, devolve 0.
/// Caso contrário, calcula o valor total, considerando que 
/// cada doação corresponde a R$ 10.
pub fn calcula_valor_doacao(c: Conta) -> Int {
  let quantidade: Int = c.quantidade_saldos_negativos
  case quantidade > 0 {
    True -> quantidade * 10
    False -> 0
  }
}

pub fn calcula_valor_doacao_examples() {
  let c1: Conta = Conta(50.0, -2)
  let c2: Conta = Conta(50.0, 0)
  let c3: Conta = Conta(50.0, 2)
  let c4: Conta = Conta(50.0, 45)

  check.eq(calcula_valor_doacao(c1), 0)
  check.eq(calcula_valor_doacao(c2), 0)
  check.eq(calcula_valor_doacao(c3), 20)
  check.eq(calcula_valor_doacao(c4), 450)
}
