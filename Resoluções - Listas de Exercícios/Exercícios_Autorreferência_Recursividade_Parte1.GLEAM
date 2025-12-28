import gleam/int
import sgleam/check

/// Concatena todos os elementos de *lst*.
/// Se *lst* for vazia, retorna uma string vazia.
pub fn concatena(lst: List(String)) -> String {
  case lst {
    [] -> ""
    [primeiro, ..resto] -> primeiro <> concatena(resto)
  }
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
  case lst {
    [] -> 0
    [_, ..resto] -> 1 + quantidade_numeros(resto)
  }
}

pub fn quantidade_numeros_examples() {
  check.eq(quantidade_numeros([]), 0)
  check.eq(quantidade_numeros([5]), 1)
  check.eq(quantidade_numeros([1, 2, 3, 4, 4, 3, 2, 1]), 8)
}

/// Converte *lst* para uma lista de strings.
pub fn ints_para_strings(lst: List(Int)) -> List(String) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> [int.to_string(primeiro), ..ints_para_strings(resto)]
  }
}

pub fn ints_para_strings_examples() {
  check.eq(ints_para_strings([]), [])
  check.eq(ints_para_strings([2]), ["2"])
  check.eq(ints_para_strings([2, 4, 6, 8]), ["2", "4", "6", "8"])
}

/// Remove as strings vazias de *lst*.
pub fn remove_vazias(lst: List(String)) -> List(String) {
  case lst {
    [] -> []
    [primeiro, ..resto] if primeiro == "" -> remove_vazias(resto)
    [primeiro, ..resto] -> [primeiro, ..remove_vazias(resto)]
  }
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
  case lst {
    [] -> True
    [primeiro, ..resto] -> primeiro && todos_true(resto)
  }
}

pub fn todos_true_examples() {
  check.eq(todos_true([]), True)
  check.eq(todos_true([False]), False)
  check.eq(todos_true([True]), True)
  check.eq(todos_true([True, False]), False)
  check.eq(todos_true([True, True]), True)
  check.eq(todos_true([True, True, True]), True)
}

/// Verifica se uma lista de núemros está em ordem não decrescente.
/// Devolve True, caso esteja e False, caso contrário.
pub fn verifica_ordem(lst: List(Int)) -> Bool {
  case lst {
    [] | [_] -> True
    [primeiro, segundo, ..resto] ->
      primeiro <= segundo && verifica_ordem([segundo, ..resto])
  }
}

pub fn verifica_ordem_examples() {
  check.eq(verifica_ordem([]), True)
  check.eq(verifica_ordem([3]), True)
  check.eq(verifica_ordem([3, 4]), True)
  check.eq(verifica_ordem([4, 3]), False)
  check.eq(verifica_ordem([4, 4]), True)
  check.eq(verifica_ordem([3, 4, 4, 5]), True)
  check.eq(verifica_ordem([3, 4, 4, 3]), False)
  check.eq(verifica_ordem([3, 6, 4, 5]), False)
  check.eq(verifica_ordem([5, 4, 4, 3]), False)
}

/// Adiciona *n* no final de *lst*.
pub fn adiciona_final(n: Int, lst: List(Int)) -> List(Int) {
  case lst {
    [] -> [n]
    [primeiro, ..resto] -> [primeiro, ..adiciona_final(n, resto)]
  }
}

pub fn adiciona_final_examples() {
  check.eq(adiciona_final(2, []), [2])
  check.eq(adiciona_final(3, [2]), [2, 3])
  check.eq(adiciona_final(5, [9, 1, 4, 6]), [9, 1, 4, 6, 5])
}

/// Devolve *lst* com os seus elementos em ordem contrária.
pub fn ordem_contraria(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> adiciona_final(primeiro, ordem_contraria(resto))
  }
}

pub fn ordem_contraria_examples() {
  check.eq(ordem_contraria([]), [])
  check.eq(ordem_contraria([2]), [2])
  check.eq(ordem_contraria([2, 5]), [5, 2])
  check.eq(ordem_contraria([1, 9, 6, 4]), [4, 6, 9, 1])
}

pub type Par {
  Par(chave: String, valor: Int)
}

/// Atualiza *lst*, adicionando o par *chave* e *valor*, caso *chave* ainda não está presente
/// nela. ou atualiza o valor associado com *chave* para *valor* caso a chave esteja presente.
pub fn adiciona_associacao(
  lst: List(Par),
  chave: String,
  valor: Int,
) -> List(Par) {
  case lst {
    [] -> [Par(chave, valor)]
    [primeiro, ..resto] if primeiro.chave == chave -> [
      Par(chave, valor),
      ..resto
    ]
    [primeiro, ..resto] -> [
      primeiro,
      ..adiciona_associacao(resto, chave, valor)
    ]
  }
}

pub fn adiciona_associacao_examples() {
  check.eq(adiciona_associacao([], "hoje", 5), [Par("hoje", 5)])
  check.eq(adiciona_associacao([Par("hoje", 4)], "amanha", 5), [
    Par("hoje", 4),
    Par("amanha", 5),
  ])
  check.eq(adiciona_associacao([Par("hoje", 2)], "amanha", 2), [
    Par("hoje", 2),
    Par("amanha", 2),
  ])
  check.eq(adiciona_associacao([Par("hoje", 3)], "hoje", 6), [Par("hoje", 6)])
  check.eq(
    adiciona_associacao([Par("hoje", 4), Par("ontem", 10)], "amanha", 5),
    [Par("hoje", 4), Par("ontem", 10), Par("amanha", 5)],
  )
  check.eq(adiciona_associacao([Par("hoje", 4), Par("ontem", 10)], "ontem", 5), [
    Par("hoje", 4),
    Par("ontem", 5),
  ])
}

/// Devolve o valor máximo de *lst*.
/// Em caso de *lst* vazia, devolve Error(Nil).
pub fn maximo(lst: List(Int)) -> Result(Int, Nil) {
  case lst {
    [] -> Error(Nil)
    [primeiro, ..resto] ->
      case maximo(resto) {
        Error(Nil) -> Ok(primeiro)
        Ok(maximo_resto) -> Ok(int.max(primeiro, maximo_resto))
      }
  }
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
  case lst {
    [] -> Ok([])
    [primeiro, ..resto] ->
      case int.parse(primeiro) {
        Ok(primeiro) ->
          case strings_para_ints(resto) {
            Ok(resto) -> Ok([primeiro, ..resto])
            Error(Nil) -> Error(Nil)
          }
        Error(Nil) -> Error(Nil)
      }
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

/// Cria uma nova lista sem os valores negativos de *lst*.
pub fn remove_negativos(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro, ..resto] if primeiro < 0 -> remove_negativos(resto)
    [primeiro, ..resto] -> [primeiro, ..remove_negativos(resto)]
  }
}

pub fn remove_negativos_examples() {
  check.eq(remove_negativos([]), [])
  check.eq(remove_negativos([-3]), [])
  check.eq(remove_negativos([-8, 2, -5]), [2])
  check.eq(remove_negativos([2, 5, 9, 0]), [2, 5, 9, 0])
  check.eq(remove_negativos([3, 6, -1, 7, 15]), [3, 6, 7, 15])
}

const venda_sorvete: Int = 10

const custo_producao_manga: Int = 6

const custo_producao_uva: Int = 7

const custo_producao_morango: Int = 8

/// O sabor de um sorvete vendido.
pub type Sabor {
  Manga
  Uva
  Morango
}

/// Calcula o lucro obtido a partir da venda dos sorvetes em *lst*.
/// Os sorvetes são vendidos por 10 reais e 
/// *lst* pode conter sorvetes de três sabores, sendo que:
/// - O custo de produção do sorvete de Manga é 6 reais;
/// - O custo de produção do sorvete de Uva é 7 reais;
/// - O custo de produção do sorvete de Morango é 8 reais.
pub fn calcula_lucro(lst: List(Sabor)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] ->
      case primeiro {
        Manga -> venda_sorvete - custo_producao_manga + calcula_lucro(resto)
        Uva -> venda_sorvete - custo_producao_uva + calcula_lucro(resto)
        Morango -> venda_sorvete - custo_producao_morango + calcula_lucro(resto)
      }
  }
}

pub fn calcula_lucro_examples() {
  check.eq(calcula_lucro([]), 0)
  check.eq(calcula_lucro([Manga]), 4)
  check.eq(calcula_lucro([Uva]), 3)
  check.eq(calcula_lucro([Morango]), 2)
  check.eq(calcula_lucro([Uva, Morango, Manga]), 9)
  check.eq(
    calcula_lucro([Morango, Manga, Manga, Morango, Uva, Manga, Uva, Morango]),
    24,
  )
}

/// Remove os valores repetidos de *lst*, que deve ser uma
/// lista não decrescente de valores.
pub fn elimina_repeticao(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro] -> [primeiro]
    [primeiro, segundo, ..resto] if segundo > primeiro -> [
      primeiro,
      ..elimina_repeticao([segundo, ..resto])
    ]
    [_, segundo, ..resto] -> elimina_repeticao([segundo, ..resto])
  }
}

pub fn elimina_repeticao_examples() {
  check.eq(elimina_repeticao([]), [])
  check.eq(elimina_repeticao([5]), [5])
  check.eq(elimina_repeticao([3, 3, 7, 7, 7, 10]), [3, 7, 10])
  check.eq(elimina_repeticao([1, 2, 2, 3, 3, 4, 4, 4, 5]), [1, 2, 3, 4, 5])
  check.eq(elimina_repeticao([1, 1, 1, 1]), [1])
}

/// Representa um item de um compra.
pub type Item {
  /// Representa as informações necessários de um item no contexto de um compra:
  /// seu nome, a quantidade desejada, o valor unitário com imposto, o percentual do imposto
  /// e se o produto pertence a categoria de cesta básica.
  Item(
    nome: String,
    quantidade: Int,
    valor_unitario: Float,
    imposto: Float,
    cesta_basica: Bool,
  )
}

/// Calcula o valor total de uma compra dos itens de *lst*.
/// Os itens de *lst* de cesta básica possuem o imposto aplicado
/// sobre o valor unitário retirado. Os demais itens permanecem
/// com os valores unitários cadastrados.
pub fn calcula_valor_compra(lst: List(Item)) -> Float {
  case lst {
    [] -> 0.0
    [primeiro, ..resto] if primeiro.cesta_basica == True ->
      int.to_float(primeiro.quantidade)
      *. primeiro.valor_unitario
      /. { 1.0 +. primeiro.imposto /. 100.0 }
      +. calcula_valor_compra(resto)
    [primeiro, ..resto] ->
      int.to_float(primeiro.quantidade)
      *. primeiro.valor_unitario
      +. calcula_valor_compra(resto)
  }
}

pub fn calcula_valor_compra_examples() {
  let i1 = Item("Arroz", 2, 125.0, 25.0, True)
  let i2 = Item("Chocolate", 3, 200.0, 20.0, False)
  let i3 = Item("Sabão", 1, 110.0, 10.0, True)
  let i4 = Item("Queijo", 5, 50.0, 20.0, False)

  check.eq(calcula_valor_compra([]), 0.0)
  check.eq(calcula_valor_compra([i2, i4]), 850.0)
  check.eq(calcula_valor_compra([i3, i1]), 300.0)
  check.eq(calcula_valor_compra([i1, i2, i3]), 900.0)
}

/// Devolve uma nova lista com os mesmos elementos de *lst* junto com *n* em ordem
/// não decrescente.
/// Requer que *lst* esteja em ordem não decrescente.
pub fn ordena_elemento(n: Int, lst: List(Int)) -> List(Int) {
  case lst {
    [] -> [n]
    [primeiro, ..resto] if n < primeiro -> [n, primeiro, ..resto]
    [primeiro, ..resto] -> [primeiro, ..ordena_elemento(n, resto)]
  }
}

pub fn ordena_elemento_examples() {
  check.eq(ordena_elemento(8, []), [8])
  check.eq(ordena_elemento(-1, [2]), [-1, 2])
  check.eq(ordena_elemento(5, [2]), [2, 5])
  check.eq(ordena_elemento(0, [2, 6, 9]), [0, 2, 6, 9])
  check.eq(ordena_elemento(4, [2, 6, 9]), [2, 4, 6, 9])
  check.eq(ordena_elemento(6, [2, 6, 9]), [2, 6, 6, 9])
  check.eq(ordena_elemento(8, [2, 6, 9]), [2, 6, 8, 9])
  check.eq(ordena_elemento(15, [2, 6, 9]), [2, 6, 9, 15])
}

/// Cria uma lista com os elementos de *lst* em ordem não decrescente usando o
/// algoritmo de ordenação por inserção.
pub fn ordena(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> ordena_elemento(primeiro, ordena(resto))
  }
}

pub fn ordena_examples() {
  check.eq(ordena([]), [])
  check.eq(ordena([2]), [2])
  check.eq(ordena([3, 2]), [2, 3])
  check.eq(ordena([5, -2, 3]), [-2, 3, 5])
  check.eq(ordena([1, 9, 5, -2, 8, 3]), [-2, 1, 3, 5, 8, 9])
  check.eq(ordena([3, 4, 2, 2, 6, 1]), [1, 2, 2, 3, 4, 6])
}

/// Busca o elemento de posição *indice* em *lst*.
/// Se não existir, retorna Error(Nil).
/// Requer que o índice seja não negativo.
pub fn busca_indice(indice: Int, lst: List(String)) -> Result(String, Nil) {
  case lst {
    [] -> Error(Nil)
    [primeiro, ..] if indice == 0 -> Ok(primeiro)
    [_, ..resto] -> busca_indice(indice - 1, resto)
  }
}

pub fn busca_indice_examples() {
  check.eq(busca_indice(0, []), Error(Nil))
  check.eq(busca_indice(5, []), Error(Nil))
  check.eq(busca_indice(0, ["2"]), Ok("2"))
  check.eq(busca_indice(1, ["2"]), Error(Nil))
  check.eq(busca_indice(0, ["4", "1", "9", "3", "5", "0", "8"]), Ok("4"))
  check.eq(busca_indice(1, ["4", "1", "9", "3", "5", "0", "8"]), Ok("1"))
  check.eq(busca_indice(2, ["4", "1", "9", "3", "5", "0", "8"]), Ok("9"))
  check.eq(busca_indice(3, ["4", "1", "9", "3", "5", "0", "8"]), Ok("3"))
  check.eq(busca_indice(4, ["4", "1", "9", "3", "5", "0", "8"]), Ok("5"))
  check.eq(busca_indice(5, ["4", "1", "9", "3", "5", "0", "8"]), Ok("0"))
  check.eq(busca_indice(6, ["4", "1", "9", "3", "5", "0", "8"]), Ok("8"))
  check.eq(busca_indice(7, ["4", "1", "9", "3", "5", "0", "8"]), Error(Nil))
}
