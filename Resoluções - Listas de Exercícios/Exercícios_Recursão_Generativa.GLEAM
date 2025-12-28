import gleam/int
import gleam/list
import gleam/string
import sgleam/check

/// Converte n, um número natural, em uma string.
pub fn int_to_string(n: Int) -> String {
  case n {
    0 -> "0"
    1 -> "1"
    2 -> "2"
    3 -> "3"
    4 -> "4"
    5 -> "5"
    6 -> "6"
    7 -> "7"
    8 -> "8"
    9 -> "9"
    _ -> int_to_string(n / 10) <> int_to_string(n % 10)
  }
}

pub fn int_to_string_examples() {
  check.eq(int_to_string(0), "0")
  check.eq(int_to_string(5), "5")
  check.eq(int_to_string(18), "18")
  check.eq(int_to_string(451), "451")
  check.eq(int_to_string(158_479_632), "158479632")
}

/// Inverte os caracteres de s.
pub fn inverte_string(s: String) -> String {
  let tamanho = string.length(s)
  case tamanho {
    0 | 1 -> s
    _ -> {
      let primeiro = string.slice(s, 0, 1)
      let ultimo = string.slice(s, tamanho - 1, 1)
      let meio = string.slice(s, 1, tamanho - 2)
      ultimo <> inverte_string(meio) <> primeiro
    }
  }
}

pub fn inverte_string_examples() {
  check.eq(inverte_string(""), "")
  check.eq(inverte_string("a"), "a")
  check.eq(inverte_string("oi"), "io")
  check.eq(inverte_string("mar"), "ram")
  check.eq(inverte_string("amor"), "roma")
  check.eq(inverte_string("cadeira"), "ariedac")
  check.eq(inverte_string("poltrona"), "anortlop")
}

/// Representa os possíveis resultados 
/// de busca do máximo de uma lista de números.
pub type Resultado {
  SemMaximo
  Maximo(n: Int)
}

/// Devolve o valor máximo de *lst*.
/// Caso *lst* seja vazia, devolve 'SemMaximo'.
pub fn maximo(lst: List(Int)) -> Resultado {
  case lst {
    [] -> SemMaximo
    [primeiro] -> Maximo(primeiro)
    _ -> {
      let tamanho: Int = conta_elementos(lst)
      let meio: Int = tamanho / 2
      let primeira_metade: List(Int) = slice_lista(lst, 0, meio)
      let segunda_metade: List(Int) = slice_lista(lst, meio, tamanho - meio)
      case maximo(primeira_metade), maximo(segunda_metade) {
        SemMaximo, SemMaximo -> SemMaximo
        SemMaximo, Maximo(n) -> Maximo(n)
        Maximo(n), SemMaximo -> Maximo(n)
        Maximo(n1), Maximo(n2) -> Maximo(int.max(n1, n2))
      }
    }
  }
}

pub fn maximo_examples() {
  check.eq(maximo([]), SemMaximo)
  check.eq(maximo([5]), Maximo(5))
  check.eq(maximo([1, 5]), Maximo(5))
  check.eq(maximo([5, 1]), Maximo(5))
  check.eq(maximo([5, -5, 1, 2, 3, 4, -15]), Maximo(5))
  check.eq(maximo([-5, 1, 2, 5, 3, 4, -15]), Maximo(5))
  check.eq(maximo([-5, 1, 2, 3, 4, -15, 5]), Maximo(5))
}

/// Conta a quantidade de elementos de lst.
pub fn conta_elementos(lst: List(a)) -> Int {
  list.fold(lst, 0, fn(acc: Int, _: a) -> Int { acc + 1 })
}

pub fn conta_elementos_examples() {
  check.eq(conta_elementos([]), 0)
  check.eq(conta_elementos([10]), 1)
  check.eq(conta_elementos(["a", "b", "c"]), 3)
  check.eq(conta_elementos([1, 2, 3, 4]), 4)
}

/// Devolve uma sublista contígua de *lst*, 
/// iniciando na posição *inicio* e contendo no máximo *tamanho* elementos.
/// Caso *lst* seja vazia, *inicio* seja negativo, *tamanho* seja menor ou igual a zero, 
/// ou *inicio* esteja fora dos limites da lista, devolve lista vazia.
/// Se *tamanho* exceder a quantidade de elementos disponíveis a partir de *inicio*,
/// todos os elementos restantes de *lst* são retornados.
pub fn slice_lista(lst: List(a), inicio: Int, tamanho: Int) -> List(a) {
  case lst, inicio, tamanho {
    [primeiro, ..resto], 0, _ if tamanho > 0 -> [
      primeiro,
      ..slice_lista(resto, 0, tamanho - 1)
    ]
    [_, ..resto], _, _ if inicio > 0 -> slice_lista(resto, inicio - 1, tamanho)
    _, _, _ -> []
  }
}

pub fn slice_lista_examples() {
  check.eq(slice_lista([], 0, 0), [])
  check.eq(slice_lista([], 0, 1), [])
  check.eq(slice_lista([], 2, 0), [])
  check.eq(slice_lista([], 2, 1), [])
  check.eq(slice_lista([], 0, -1), [])
  check.eq(slice_lista([], -2, 0), [])
  check.eq(slice_lista([], -2, -1), [])
  check.eq(slice_lista([], 2, -1), [])
  check.eq(slice_lista([], -2, 1), [])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], -2, -1), [])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], -2, 0), [])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], -2, 1), [])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 0, -1), [])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 0, 0), [])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 0, 1), [2])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 0, 4), [2, 5, 1, 8])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 2, -1), [])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 2, 0), [])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 2, 1), [1])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 2, 4), [1, 8, 9, -6])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 2, 6), [1, 8, 9, -6, 10, 0])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 2, 10), [1, 8, 9, -6, 10, 0])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 7, 10), [0])
  check.eq(slice_lista([2, 5, 1, 8, 9, -6, 10, 0], 8, 10), [])
}

/// Ordena *lst* em ordem não decrescente, utilizando
/// o método de ordenação por seleção.
pub fn selection_sort(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [_, ..] -> {
      let minimo: Int = minimo_lista(lst)
      let lista_minimos =
        list.filter(lst, fn(elemento: Int) -> Bool { elemento == minimo })
      let lista_resto =
        list.filter(lst, fn(elemento: Int) -> Bool { elemento != minimo })
      list.append(lista_minimos, selection_sort(lista_resto))
    }
  }
}

pub fn selection_sort_examples() {
  check.eq(selection_sort([]), [])
  check.eq(selection_sort([2]), [2])
  check.eq(selection_sort([1, 3]), [1, 3])
  check.eq(selection_sort([3, 1]), [1, 3])
  check.eq(selection_sort([3, 1, 1]), [1, 1, 3])
  check.eq(selection_sort([5, 1, 4, 1, 2, 5, 1]), [1, 1, 1, 2, 4, 5, 5])
  check.eq(selection_sort([9, 7, 5, 3, 1, 0, -1, -3]), [
    -3, -1, 0, 1, 3, 5, 7, 9,
  ])
  check.eq(selection_sort([5, 9, 1, -3, -1, 0, 7, 3]), [
    -3, -1, 0, 1, 3, 5, 7, 9,
  ])
}

/// Devolve o valor mínimo presente em *lst*.
/// Se *lst* for vazia, devolve 0.
pub fn minimo_lista(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] ->
      list.fold(resto, primeiro, fn(acc: Int, elemento: Int) -> Int {
        int.min(acc, elemento)
      })
  }
}

pub fn minimo_lista_examples() {
  check.eq(minimo_lista([]), 0)
  check.eq(minimo_lista([2]), 2)
  check.eq(minimo_lista([3, 1, 3]), 1)
  check.eq(minimo_lista([1, 3, 1]), 1)
  check.eq(minimo_lista([5, 1, -2, 0, 8]), -2)
  check.eq(minimo_lista([5, 10, 12, 4, 8]), 4)
}

/// Gera todas as permutações dos elementos de *lst*.
/// Requer que *lst* tenha apenas elementos distintos.
pub fn gera_permutacoes(lst: List(Int)) -> List(List(Int)) {
  case lst {
    [] -> [[]]
    _ -> {
      junta_listas(
        list.map(lst, fn(x: Int) -> List(List(Int)) {
          let resto = list.filter(lst, fn(y: Int) -> Bool { y != x })
          list.map(
            gera_permutacoes(resto),
            fn(permutacoes_resto: List(Int)) -> List(Int) {
              [x, ..permutacoes_resto]
            },
          )
        }),
      )
    }
  }
}

pub fn gera_permutacoes_examples() {
  check.eq(gera_permutacoes([]), [[]])
  check.eq(gera_permutacoes([1]), [[1]])
  check.eq(gera_permutacoes([1, 5]), [[1, 5], [5, 1]])
  check.eq(gera_permutacoes([1, 2, 3]), [
    [1, 2, 3],
    [1, 3, 2],
    [2, 1, 3],
    [2, 3, 1],
    [3, 1, 2],
    [3, 2, 1],
  ])
  check.eq(gera_permutacoes([2, 4, 6, 8]), [
    [2, 4, 6, 8],
    [2, 4, 8, 6],
    [2, 6, 4, 8],
    [2, 6, 8, 4],
    [2, 8, 4, 6],
    [2, 8, 6, 4],
    [4, 2, 6, 8],
    [4, 2, 8, 6],
    [4, 6, 2, 8],
    [4, 6, 8, 2],
    [4, 8, 2, 6],
    [4, 8, 6, 2],
    [6, 2, 4, 8],
    [6, 2, 8, 4],
    [6, 4, 2, 8],
    [6, 4, 8, 2],
    [6, 8, 2, 4],
    [6, 8, 4, 2],
    [8, 2, 4, 6],
    [8, 2, 6, 4],
    [8, 4, 2, 6],
    [8, 4, 6, 2],
    [8, 6, 2, 4],
    [8, 6, 4, 2],
  ])
}

/// Junta todas as listas de *lsts* em uma única lista.
pub fn junta_listas(lsts: List(List(a))) -> List(a) {
  case lsts {
    [] -> []
    [primeiro, ..resto] -> list.append(primeiro, junta_listas(resto))
  }
}

pub fn junta_listas_examples() {
  check.eq(junta_listas([]), [])
  check.eq(junta_listas([[1], [2]]), [1, 2])
  check.eq(junta_listas([[1, 3], [2, 4]]), [1, 3, 2, 4])
  check.eq(junta_listas([[[1, 3], [2, 4]], [[5, 6], [7, 8]]]), [
    [1, 3],
    [2, 4],
    [5, 6],
    [7, 8],
  ])
}

/// Calcula a quantidade de formas diferentes de obter *valor* 
/// somando-se os valores presentes em *moedas*.
pub fn conta_troco(valor: Int, moedas: List(Int)) -> Int {
  case valor, moedas {
    _, [] -> 0
    0, _ -> 1
    _, [primeira, ..resto] if valor < primeira -> conta_troco(valor, resto)
    _, [primeira, ..resto] -> {
      conta_troco(valor - primeira, moedas) + conta_troco(valor, resto)
    }
  }
}

pub fn conta_troco_examples() {
  check.eq(conta_troco(5, []), 0)
  check.eq(conta_troco(0, [3, 4]), 1)
  check.eq(conta_troco(3, [3]), 1)
  check.eq(conta_troco(3, [4]), 0)
  check.eq(conta_troco(4, [1, 2]), 3)
  check.eq(conta_troco(6, [2, 3]), 2)
  check.eq(conta_troco(10, [2, 3, 4]), 5)
  check.eq(conta_troco(10, [4, 2, 3]), 5)
  check.eq(conta_troco(15, [2, 4]), 0)
  check.eq(conta_troco(15, [2, 3, 4]), 7)
}
