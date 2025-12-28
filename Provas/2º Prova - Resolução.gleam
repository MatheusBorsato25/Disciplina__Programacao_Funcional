// Aluno: Matheus Henrique Borsato - RA: 138246

import gleam/int
import gleam/list
import sgleam/check

/// Exercício 1:
/// 
/// Representa um par entre uma palavra e sua quantidade de repetições. 
pub type Par {
  // A *palavra* associada com a sua quantidade de *repeticoes* em uma lista.
  Par(palavra: String, repeticoes: Int)
}

/// Devolve os elementos de *lst* que mais se repetem na lista.
pub fn mais_repetem(lst: List(String)) -> List(String) {
  let pares: List(Par) = converte_pares(lst)
  let maior_repeticao: Int = maior_repeticao(pares)
  let mais_repetem: List(Par) =
    list.filter(pares, fn(a: Par) -> Bool { a.repeticoes == maior_repeticao })
  list.map(mais_repetem, fn(a: Par) -> String { a.palavra })
}

pub fn mais_repetem_examples() {
  check.eq(mais_repetem([]), [])
  check.eq(mais_repetem(["hoje"]), ["hoje"])
  check.eq(mais_repetem(["hoje", "lugar"]), ["lugar", "hoje"])
  check.eq(mais_repetem(["hoje", "lugar", "bom", "hoje"]), ["hoje"])
  check.eq(mais_repetem(["casa", "onde", "talvez", "casa", "nada", "onde"]), [
    "onde",
    "casa",
  ])
  check.eq(
    mais_repetem([
      "casa",
      "onde",
      "talvez",
      "onde",
      "talvez",
      "casa",
      "nada",
      "onde",
    ]),
    ["onde"],
  )
}

/// Devolve o maior valor dentre os campos *repeticoes* dos 
/// elementos de *lst*.
/// Se *lst* for vazia, devolve 0.
pub fn maior_repeticao(lst: List(Par)) -> Int {
  list.fold(lst, 0, fn(acc: Int, p: Par) -> Int { int.max(acc, p.repeticoes) })
}

pub fn maior_repeticao_examples() {
  let p1 = Par("hoje", 2)
  let p2 = Par("oi", 1)
  let p3 = Par("garrafa", 1)
  let p4 = Par("dia", 4)
  let p5 = Par("oculos", 3)
  let p6 = Par("bom", 2)

  check.eq(maior_repeticao([]), 0)
  check.eq(maior_repeticao([p1]), 2)
  check.eq(maior_repeticao([p2, p3]), 1)
  check.eq(maior_repeticao([p2, p1, p3]), 2)
  check.eq(maior_repeticao([p3, p6, p2, p1]), 2)
  check.eq(maior_repeticao([p3, p5, p6, p2, p1]), 3)
  check.eq(maior_repeticao([p3, p5, p6, p2, p1, p4]), 4)
}

/// Converte *lst*, uma lista de strings para uma lista de Par, com
/// as palavras de *lst* associadas às suas quantidades de repetições em *lst*.
/// Retorna uma lista de Par com ordem indefinida em relação à *lst*.
pub fn converte_pares(lst: List(String)) -> List(Par) {
  list.fold(lst, [], fn(acc: List(Par), palavra: String) {
    insere_par(acc, palavra, [])
  })
}

pub fn converte_pares_examples() {
  check.eq(converte_pares([]), [])
  check.eq(converte_pares(["casa"]), [Par("casa", 1)])
  check.eq(converte_pares(["casa", "hoje", "dia", "hoje", "dia", "bem"]), [
    Par("bem", 1),
    Par("hoje", 2),
    Par("casa", 1),
    Par("dia", 2),
  ])
}

/// Insere *palavra* em *acc*. Caso *palavra* não exista em *acc*, insere um novo elemento
/// em *acc* com número de repetições igual a 1. Caso *palavra* já exista em *acc*,
/// incrementa a sua quantidade de repetições e o coloca no início de *acc*.
/// A lista *acc_inicio* é utilizada como um acumulador da lista, permitindo o armazenamento
/// dos elementos de *acc* até *palavra* ser encontrada.
pub fn insere_par(
  acc: List(Par),
  palavra: String,
  acc_inicio: List(Par),
) -> List(Par) {
  case acc {
    [] -> [Par(palavra, 1), ..acc_inicio]
    [primeiro, ..resto] if primeiro.palavra == palavra -> [
      Par(palavra, primeiro.repeticoes + 1),
      ..list.append(acc_inicio, resto)
    ]
    [primeiro, ..resto] -> insere_par(resto, palavra, [primeiro, ..acc_inicio])
  }
}

pub fn insere_par_examples() {
  check.eq(insere_par([], "hoje", []), [Par("hoje", 1)])
  check.eq(
    insere_par([Par("oi", 1), Par("hoje", 2), Par("gol", 1)], "hoje", []),
    [Par("hoje", 3), Par("oi", 1), Par("gol", 1)],
  )
  check.eq(insere_par([Par("oi", 1), Par("hoje", 2)], "gol", []), [
    Par("gol", 1),
    Par("hoje", 2),
    Par("oi", 1),
  ])
}

/// Análise - Tempo de Execução:
/// Dentre todas as etapas de construção da função ("mais_repetem"), a etapa com maior custo
/// de recurso é a parte de construção dos pares, em que se percorre toda a lista de strings e,
/// para cada elemento, é necessário buscar a correspondência na lista de pares, configurando-se
/// como um processo O(n²). Os demais processos como a função ("maior_repeticao") e o "list.filter + list.map",
/// utilizados na confecção da função, não interferem assintoticamente na ordem de crescimento do 
/// tempo de execução da função, sendo desconsiderados nesse momento.
/// Portanto, no pior caso, o tempo de execução é O(n²).
/// 
/// 
/// 
/// 
/// 
/// Exercício 2:
/// 
/// Representa os elementos de uma lista,
/// divididos em *minimos* e *resto*.
pub type Lista {
  // Os elementos de *minimos* representam os menores valores da lista,
  // enquanto os elementos de *resto* representam todos os demais.
  Lista(minimos: List(Int), resto: List(Int))
}

/// Ordena *lst* em ordem não decrescente, utilizando
/// o método de ordenação por seleção.
pub fn selection_sort(lst: List(Int)) -> List(Int) {
  case lst {
    [] -> []
    [_, ..] -> {
      let minimo: Int = minimo_lista(lst)
      let lista_separada: Lista = divide_lista(lst, minimo)
      list.append(lista_separada.minimos, selection_sort(lista_separada.resto))
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
    -3,
    -1,
    0,
    1,
    3,
    5,
    7,
    9,
  ])
  check.eq(selection_sort([5, 9, 1, -3, -1, 0, 7, 3]), [
    -3,
    -1,
    0,
    1,
    3,
    5,
    7,
    9,
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

/// Divide os elementos de *lst*, segundo o valor de *minimo*.
/// Caso o elemento de *lst* seja igual a *minimo*, ele é direcionado a lista de saída *minimos*.
/// Caso contrário, ele é direcionado a lista de saída *resto*.
pub fn divide_lista(lst: List(Int), minimo: Int) -> Lista {
  list.fold_right(lst, Lista([], []), fn(acc: Lista, elemento: Int) -> Lista {
    case minimo == elemento {
      True -> Lista([elemento, ..acc.minimos], acc.resto)
      False -> Lista(acc.minimos, [elemento, ..acc.resto])
    }
  })
}

pub fn divide_lista_examples() {
  check.eq(divide_lista([], 0), Lista([], []))
  check.eq(divide_lista([5], 5), Lista([5], []))
  check.eq(divide_lista([5], 2), Lista([], [5]))
  check.eq(divide_lista([3, 2], 2), Lista([2], [3]))
  check.eq(
    divide_lista([5, 1, 4, 1, 2, 5, 1], 1),
    Lista([1, 1, 1], [5, 4, 2, 5]),
  )
}
/// Equações de Recorrência:
/// 
/// Melhor caso (todos os elementos são iguais):
/// Nesse caso, não há a necessidade de chamada recursiva. Portanto,
/// nessa situação, desconsiderando o caso base, a equação de recorrência é:
/// T(n) = T(n - 1) + f(n)
/// T(n) = T(0) + f(n)
/// T(n) = f(n) 
/// T(n) = n
/// No melhor caso, o tempo de execução é O(n).
/// 
/// Pior caso(elementos diferentes):
/// Nessa situação, desconsiderando o caso base, a equação de recorrência é:
/// T(n) = T(n - 1) + f(n)
/// T(n) = T(n - 1) + n = O(n²).
/// No pior caso, o tempo de execução é O(n²).
/// 
