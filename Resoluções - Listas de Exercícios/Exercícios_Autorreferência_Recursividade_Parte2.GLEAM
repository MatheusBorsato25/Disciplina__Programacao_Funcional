import gleam/float
import gleam/int
import gleam/list
import gleam/string
import sgleam/check

/// Devolve uma lista com *n* repetições de *v*.
pub fn numero_repeticoes(n: Int, v: Int) -> List(Int) {
  case n {
    _ if n <= 0 -> []
    _ -> [v, ..numero_repeticoes(n - 1, v)]
  }
}

pub fn numero_repeticoes_examples() {
  check.eq(numero_repeticoes(-1, 6), [])
  check.eq(numero_repeticoes(0, 6), [])
  check.eq(numero_repeticoes(1, 5), [5])
  check.eq(numero_repeticoes(3, -9), [-9, -9, -9])
  check.eq(numero_repeticoes(8, 2), [2, 2, 2, 2, 2, 2, 2, 2])
}

/// Calcula o valor de *a* elevado a *n*. Se *a* e *n* forem zeros ou se *n*
/// for negativo, devolve Error(Nil).
pub fn exponencial(a: Float, n: Int) -> Result(Float, Nil) {
  case a == 0.0 && n == 0 || n < 0 {
    True -> Error(Nil)
    False -> Ok(calcula_potencia(a, n))
  }
}

pub fn calcula_potencia(a: Float, n: Int) -> Float {
  case n {
    0 -> 1.0
    _ -> a *. calcula_potencia(a, n - 1)
  }
}

pub fn exponencial_examples() {
  check.eq(exponencial(0.0, -2), Error(Nil))
  check.eq(exponencial(0.0, 0), Error(Nil))
  check.eq(exponencial(0.0, 2), Ok(0.0))
  check.eq(exponencial(3.0, -2), Error(Nil))
  check.eq(exponencial(3.0, 0), Ok(1.0))
  check.eq(exponencial(3.0, 2), Ok(9.0))
  check.eq(exponencial(6.0, 3), Ok(216.0))
}

/// Devolve o produto dos números 1, 2, ..., *n*.
/// Se *n* for menor que 1, devolve o próprio 1.
pub fn produto_antecessores(n: Int) -> Int {
  case n {
    _ if n <= 1 -> 1
    _ -> n * produto_antecessores(n - 1)
  }
}

pub fn produto_antecessores_examples() {
  check.eq(produto_antecessores(-5), 1)
  check.eq(produto_antecessores(0), 1)
  check.eq(produto_antecessores(1), 1)
  check.eq(produto_antecessores(2), 2)
  check.eq(produto_antecessores(5), 120)
  check.eq(produto_antecessores(8), 40_320)
}

/// Verifica se *n* é par. Devolve True, caso seja
/// e False, caso contrário.
pub fn eh_par(n: Int) -> Bool {
  case n {
    _ if n < 0 -> eh_impar(n + 1)
    0 -> True
    _ -> eh_impar(n - 1)
  }
}

/// Verifica se *n* é ímpar. Devolve True, caso seja
/// e False, caso contrário.
pub fn eh_impar(n: Int) -> Bool {
  case n {
    _ if n < 0 -> eh_par(n + 1)
    0 -> False
    _ -> eh_par(n - 1)
  }
}

pub fn eh_par_examples() {
  check.eq(eh_par(-3), False)
  check.eq(eh_par(-2), True)
  check.eq(eh_par(-1), False)
  check.eq(eh_par(0), True)
  check.eq(eh_par(1), False)
  check.eq(eh_par(2), True)
  check.eq(eh_par(3), False)
}

pub fn eh_impar_examples() {
  check.eq(eh_impar(-3), True)
  check.eq(eh_impar(-2), False)
  check.eq(eh_impar(-1), True)
  check.eq(eh_impar(0), False)
  check.eq(eh_impar(1), True)
  check.eq(eh_impar(2), False)
  check.eq(eh_impar(3), True)
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

/// Devolve o valor mínimo de *lst*.
/// Em caso de *lst* vazia, devolve Error(Nil).
pub fn minimo(lst: List(Int)) -> Result(Int, Nil) {
  case lst {
    [] -> Error(Nil)
    [primeiro, ..resto] ->
      case minimo(resto) {
        Error(Nil) -> Ok(primeiro)
        Ok(minimo_resto) -> Ok(int.min(primeiro, minimo_resto))
      }
  }
}

pub fn minimo_examples() {
  check.eq(minimo([]), Error(Nil))
  check.eq(minimo([5]), Ok(5))
  check.eq(minimo([2, 5, 1, 8, 6, 3]), Ok(1))
  check.eq(minimo([9, 2, 3, 4, 6, 8]), Ok(2))
  check.eq(minimo([2, 5, 4, 6, 7, -5]), Ok(-5))
}

/// Calcula a amplitude dos valores de *lst*, isto é, a diferença
/// entre o valor máximo e mínimo de *lst*. 
/// Devolve Error(Nil) caso *lst* seja vazia.
pub fn amplitude(lst: List(Int)) -> Result(Int, Nil) {
  case maximo(lst), minimo(lst) {
    Ok(maximo), Ok(minimo) -> Ok(maximo - minimo)
    _, _ -> Error(Nil)
  }
}

pub fn amplitude_examples() {
  check.eq(amplitude([]), Error(Nil))
  check.eq(amplitude([5]), Ok(0))
  check.eq(amplitude([4, 3, 8]), Ok(5))
  check.eq(amplitude([9, 2, 5]), Ok(7))
  check.eq(amplitude([-2, -5, 0, 4, 6]), Ok(11))
}

/// Calcula o tamanho médio das strings de uma *lst*.
/// Se *lst* estiver vazia, devolve 0.0.
pub fn media_strings(lst: List(String)) -> Float {
  case
    float.divide(
      int.to_float(total_caracteres(lst)),
      int.to_float(total_strings(lst)),
    )
  {
    Ok(media) -> media
    Error(Nil) -> 0.0
  }
}

pub fn media_strings_examples() {
  check.eq(media_strings([]), 0.0)
  check.eq(media_strings(["", "", ""]), 0.0)
  check.eq(media_strings(["oi"]), 2.0)
  check.eq(media_strings(["a", "bb", "ccc"]), 2.0)
  check.eq(media_strings(["matheus", "henrique", "uem", "computação"]), 7.0)
}

/// Devolve o total da soma dos caracteres das strings de *lst*. 
pub fn total_caracteres(lst: List(String)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] -> string.length(primeiro) + total_caracteres(resto)
  }
}

pub fn total_caracteres_examples() {
  check.eq(total_caracteres([]), 0)
  check.eq(total_caracteres(["oi"]), 2)
  check.eq(total_caracteres(["oi", "bom", "dia"]), 8)
  check.eq(total_caracteres(["a", "bb", "ccc"]), 6)
}

/// Devolve o total de strings de *lst*.
pub fn total_strings(lst: List(String)) -> Int {
  case lst {
    [] -> 0
    [_, ..resto] -> 1 + total_strings(resto)
  }
}

pub fn total_strings_examples() {
  check.eq(total_strings([]), 0)
  check.eq(total_strings(["oi"]), 1)
  check.eq(total_strings(["oi", "bom"]), 2)
  check.eq(total_strings(["a", "bb", "ccc"]), 3)
}

/// Representa a maioria dos valores existentes.
pub type Maioria {
  Positivo
  Negativo
  Nenhum
}

/// Determina se em *lst*, existem mais números negativos ou positivos.
/// Se a quantidade for igual, devolve Nenhum.
pub fn maioria(lst: List(Int)) -> Maioria {
  let npositivos = num_positivos(lst)
  let nnegativos = num_negativos(lst)
  case npositivos == nnegativos {
    True -> Nenhum
    False ->
      case npositivos > nnegativos {
        True -> Positivo
        False -> Negativo
      }
  }
}

/// Conta a quantidade de elementos positivos em *lst*, ou seja,
/// valores maiores que zero.
fn num_positivos(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] if primeiro > 0 -> 1 + num_positivos(resto)
    [_, ..resto] -> num_positivos(resto)
  }
}

/// Conta a quantidade de elementos negativos em *lst*, ou seja,
/// valores menores que zero.
fn num_negativos(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] if primeiro < 0 -> 1 + num_negativos(resto)
    [_, ..resto] -> num_negativos(resto)
  }
}

pub fn maioria_examples() {
  check.eq(maioria([]), Nenhum)
  check.eq(maioria([0]), Nenhum)
  check.eq(maioria([10]), Positivo)
  check.eq(maioria([-2]), Negativo)
  check.eq(maioria([2, 10]), Positivo)
  check.eq(maioria([-1, 10]), Nenhum)
  check.eq(maioria([-1, -2]), Negativo)
  check.eq(maioria([10, -2, 5]), Positivo)
  check.eq(maioria([-10, -2, 5]), Negativo)
  check.eq(maioria([10, -2, 5, -9]), Nenhum)
}

pub type Arvore(a) {
  Vazia
  No(valor: a, esq: Arvore(a), dir: Arvore(a))
}

/// Determina quantos nós de *r*, uma árvore
/// binária, possuem grau 2.
pub fn grau_dois(r: Arvore(a)) -> Int {
  case r {
    Vazia -> 0
    No(_, esq, dir) if esq != Vazia && dir != Vazia ->
      1 + grau_dois(esq) + grau_dois(dir)
    No(_, esq, dir) -> grau_dois(esq) + grau_dois(dir)
  }
}

pub fn grau_dois_examples() {
  //     t4  3
  //       /   \
  //  t3  4     7  t2
  //     / \   / \
  //    3   2 8   9  t1
  //             /
  //        t0  10
  //           /  \
  //        t 4    6
  let t = No(4, Vazia, Vazia)
  let t0 = No(10, t, No(6, Vazia, Vazia))
  let t1 = No(9, t0, Vazia)
  let t2 = No(7, No(8, Vazia, Vazia), t1)
  let t3 = No(4, No(3, Vazia, Vazia), No(2, Vazia, Vazia))
  let t4 = No(3, t3, t2)

  check.eq(grau_dois(Vazia), 0)
  check.eq(grau_dois(t), 0)
  check.eq(grau_dois(t0), 1)
  check.eq(grau_dois(t1), 1)
  check.eq(grau_dois(t2), 2)
  check.eq(grau_dois(t3), 1)
  check.eq(grau_dois(t4), 4)
}

/// Verifica se *r* é uma árvore cheia, ou seja,
/// possui todos os nós com grau 0 ou 2.
pub fn arvore_cheia(r: Arvore(a)) -> Bool {
  case r {
    Vazia | No(_, Vazia, Vazia) -> True
    No(_, esq, dir) if esq != Vazia && dir != Vazia ->
      arvore_cheia(esq) && arvore_cheia(dir)
    _ -> False
  }
}

pub fn arvore_cheia_examples() {
  //     t4  3
  //       /   \
  //  t3  4     7  t2
  //     / \   / \
  //    3   2 8   9  t1
  //             /
  //        t0  10
  let t0 = No(10, Vazia, Vazia)
  let t1 = No(9, t0, Vazia)
  let t2 = No(7, No(8, Vazia, Vazia), t1)
  let t3 = No(4, No(3, Vazia, Vazia), No(2, Vazia, Vazia))
  let t4 = No(3, t3, t2)

  check.eq(arvore_cheia(Vazia), True)
  check.eq(arvore_cheia(t0), True)
  check.eq(arvore_cheia(t1), False)
  check.eq(arvore_cheia(t2), False)
  check.eq(arvore_cheia(t3), True)
  check.eq(arvore_cheia(t4), False)
}

/// Devolve a altura de *r*. A altura de uma árvore binária é a distância da
/// raiz a seu descendente mais afastado. Uma árvore com um único nó tem altura
/// 0 e uma árvore vazia tem altura -1.
pub fn altura(r: Arvore(a)) -> Int {
  case r {
    Vazia -> -1
    No(_, esq, dir) -> 1 + int.max(altura(esq), altura(dir))
  }
}

pub fn altura_examples() {
  //     t4  3
  //       /   \
  //  t3  4     7  t2
  //     /     / \
  //    3     8   9  t1
  //             /
  //        t0  10

  let t0 = No(10, Vazia, Vazia)
  let t1 = No(9, t0, Vazia)
  let t2 = No(7, No(8, Vazia, Vazia), t1)
  let t3 = No(4, No(3, Vazia, Vazia), Vazia)
  let t4 = No(3, t3, t2)

  check.eq(altura(Vazia), -1)
  check.eq(altura(t0), 0)
  check.eq(altura(t1), 1)
  check.eq(altura(t2), 2)
  check.eq(altura(t3), 1)
  check.eq(altura(t4), 3)
}

/// Verifica se *r* é uma árvore binária balanceada, ou seja, a altura de suas subárvores a direita 
/// e a esquerda diferem em no máximo 1 e as duas subárvores também são balanceadas.
/// Devolve True, caso seja e False, caso contrário.
pub fn arvore_balanceada(r: Arvore(a)) -> Bool {
  case r {
    Vazia -> True
    No(_, esq, dir) ->
      int.absolute_value(altura(esq) - altura(dir)) <= 1
      && arvore_balanceada(esq)
      && arvore_balanceada(dir)
  }
}

pub fn arvore_balanceada_examples() {
  //     t5  3
  //       /   \
  //  t4  4     7  t2
  //     /     / \
  // t3 3     8   9  t1
  //   /         /
  //  1     t0  10

  let t0 = No(10, Vazia, Vazia)
  let t1 = No(9, t0, Vazia)
  let t2 = No(7, No(8, Vazia, Vazia), t1)
  let t3 = No(3, No(1, Vazia, Vazia), Vazia)
  let t4 = No(4, t3, Vazia)
  let t5 = No(3, t4, t2)

  check.eq(arvore_balanceada(Vazia), True)
  check.eq(arvore_balanceada(t0), True)
  check.eq(arvore_balanceada(t1), True)
  check.eq(arvore_balanceada(t2), True)
  check.eq(arvore_balanceada(t3), True)
  check.eq(arvore_balanceada(t4), False)
  check.eq(arvore_balanceada(t5), False)
}

/// Devolve os elementos de *r* em uma lista seguindo a ordem simétrica (em-ordem).
/// Percorre primeiro a subárvore esquerda, depois o nó atual e por fim a subárvore direita.
/// Retorna lista vazia se *r* for vazia.
pub fn em_ordem(r: Arvore(Int)) -> List(Int) {
  case r {
    Vazia -> []
    No(valor, esq, dir) -> list.append(em_ordem(esq), [valor, ..em_ordem(dir)])
  }
}

pub fn eh_ordem_examples() {
  //     t5  3
  //       /   \
  //  t4  4     7  t2
  //     /     / \
  // t3 3     8   9  t1
  //   /         /
  //  1     t0  10

  let t0 = No(10, Vazia, Vazia)
  let t1 = No(9, t0, Vazia)
  let t2 = No(7, No(8, Vazia, Vazia), t1)
  let t3 = No(3, No(1, Vazia, Vazia), Vazia)
  let t4 = No(4, t3, Vazia)
  let t5 = No(3, t4, t2)

  check.eq(em_ordem(Vazia), [])
  check.eq(em_ordem(t0), [10])
  check.eq(em_ordem(t1), [10, 9])
  check.eq(em_ordem(t2), [8, 7, 10, 9])
  check.eq(em_ordem(t3), [1, 3])
  check.eq(em_ordem(t4), [1, 3, 4])
  check.eq(em_ordem(t5), [1, 3, 4, 3, 8, 7, 10, 9])
}

/// Verifica se os elementos de *lst* estão em ordem crescente.
/// Devolve True, caso estejam e False, caso contrário.
pub fn verifica_ordem(lst: List(Int)) -> Bool {
  case lst {
    [] | [_] -> True
    [primeiro, segundo, ..resto] ->
      primeiro < segundo && verifica_ordem([segundo, ..resto])
  }
}

pub fn verifica_ordem_examples() {
  check.eq(verifica_ordem([]), True)
  check.eq(verifica_ordem([1]), True)
  check.eq(verifica_ordem([2, 3]), True)
  check.eq(verifica_ordem([3, 2]), False)
  check.eq(verifica_ordem([2, 2]), False)
  check.eq(verifica_ordem([-2, 0, 5, 8]), True)
  check.eq(verifica_ordem([-2, 5, 5, 8]), False)
  check.eq(verifica_ordem([-2, 5, 0, 8]), False)
}

/// Verifica se *r* é uma árvore binária de busca. 
/// Uma árvore binária de busca tem as seguintes propriedades: 
/// 1) A subárvore a esquerda contém valores nos nós menores que o valor no nó raiz. 
/// 2) A subárvore a direita contém valores nos nós maiores que o valor no nó raiz.
/// 3) As subárvores a esquerda e a direita também são árvores binárias de busca.
/// Devolve True, caso *r* seja uma árvore binária de busca e False, caso contrário.
pub fn eh_abb(r: Arvore(Int)) -> Bool {
  let lista_elementos: List(Int) = em_ordem(r)
  verifica_ordem(lista_elementos)
}

pub fn eh_abb_examples() {
  //     t5  5
  //       /   \
  //  t4  2     7  t2
  //     /     / \
  // t3 3     6   10  t1
  //   / \        / \
  //  1  15  t0  9   15

  let t0 = No(9, Vazia, Vazia)
  let t1 = No(10, t0, No(15, Vazia, Vazia))
  let t2 = No(7, No(6, Vazia, Vazia), t1)
  let t3 = No(3, No(1, Vazia, Vazia), No(15, Vazia, Vazia))
  let t4 = No(2, t3, Vazia)
  let t5 = No(5, t4, t2)

  check.eq(eh_abb(Vazia), True)
  check.eq(eh_abb(t0), True)
  check.eq(eh_abb(t1), True)
  check.eq(eh_abb(t2), True)
  check.eq(eh_abb(t3), True)
  check.eq(eh_abb(t4), False)
  check.eq(eh_abb(t5), False)
}

/// Produz True se *elemento* está em *r* e False, caso contrário.
/// Requer que *r* seja uma árvore binária de busca, isto é:
/// 1) A subárvore à esquerda contém valores nos nós menores que o valor no nó raiz.
/// 2) A subárvore à direita contém valores nos nós maiores que o valor do nó raiz.
/// 3) As subárvores à esquerda e à direita também são árvores binárias de busca.
pub fn contem_arvore_busca(r: Arvore(Int), elemento: Int) -> Bool {
  case r {
    Vazia -> False
    No(valor, esq, _) if valor > elemento -> contem_arvore_busca(esq, elemento)
    No(valor, _, dir) if valor < elemento -> contem_arvore_busca(dir, elemento)
    _ -> True
  }
}

pub fn contem_arvore_busca_examples() {
  //     t4  4
  //        / \
  //       /   \
  //  t3  3     8  t2
  //     /     / \
  //    1     7   10  t1
  //             /
  //        t0  9

  let t0 = No(9, Vazia, Vazia)
  let t1 = No(10, t0, Vazia)
  let t2 = No(8, No(7, Vazia, Vazia), t1)
  let t3 = No(3, No(1, Vazia, Vazia), Vazia)
  let t4 = No(4, t3, t2)

  check.eq(contem_arvore_busca(Vazia, 3), False)
  check.eq(contem_arvore_busca(t4, 4), True)
  check.eq(contem_arvore_busca(t4, 3), True)
  check.eq(contem_arvore_busca(t4, 1), True)
  check.eq(contem_arvore_busca(t4, 10), True)
  check.eq(contem_arvore_busca(t4, 6), False)
  check.eq(contem_arvore_busca(t4, 2), False)
}

/// Verifica se um aluno deve receber Láurea Acadêmica.
/// Para isso, pelo menos 2/3 de *notas* precisam ser maiores ou iguais a 9.0.
/// Caso sejam, devolve True. Caso contrário, devolve False.
/// Se *notas* estiver vazia, retorna False.
pub fn laureado(notas: List(Float)) -> Bool {
  let num_maiores_que_9 = int.to_float(conta_maiores_que_9(notas))
  let total = int.to_float(conta_numeros(notas))

  total >. 0.0 && num_maiores_que_9 >=. { total *. 2.0 /. 3.0 }
}

pub fn laureado_examples() {
  check.eq(laureado([]), False)
  check.eq(laureado([9.2]), True)
  check.eq(laureado([8.2]), False)
  check.eq(laureado([7.5, 9.2]), False)
  check.eq(laureado([9.0, 10.0]), True)
  check.eq(laureado([9.0, 8.0, 9.4]), True)
  check.eq(laureado([9.0, 8.0, 8.9]), False)
  check.eq(laureado([9.0, 9.1, 8.0, 8.9, 10.0]), False)
  check.eq(laureado([9.0, 9.1, 8.0, 8.9, 10.0, 9.6]), True)
  check.eq(laureado([9.0, 9.1, 9.5, 8.9, 10.0, 9.6]), True)
}

/// Conta a quantidade de notas maiores ou iguais a 9.0 em *notas*.
fn conta_maiores_que_9(notas: List(Float)) -> Int {
  case notas {
    [] -> 0
    [primeiro, ..resto] if primeiro >=. 9.0 -> 1 + conta_maiores_que_9(resto)
    [_, ..resto] -> conta_maiores_que_9(resto)
  }
}

pub fn conta_maiores_que_9_examples() {
  check.eq(conta_maiores_que_9([]), 0)
  check.eq(conta_maiores_que_9([7.5]), 0)
  check.eq(conta_maiores_que_9([9.2]), 1)
  check.eq(conta_maiores_que_9([7.5, 9.3]), 1)
  check.eq(conta_maiores_que_9([6.0, 7.5, 8.0]), 0)
  check.eq(conta_maiores_que_9([9.0, 9.0, 9.0]), 3)
  check.eq(conta_maiores_que_9([8.5, 9.0, 10.0, 7.5, 9.5]), 3)
}

/// Conta a quantidade de elementos de *notas*.
pub fn conta_numeros(notas: List(Float)) -> Int {
  case notas {
    [] -> 0
    [_, ..resto] -> 1 + conta_numeros(resto)
  }
}

pub fn conta_numeros_examples() {
  check.eq(conta_numeros([]), 0)
  check.eq(conta_numeros([8.4]), 1)
  check.eq(conta_numeros([7.8, 5.0]), 2)
  check.eq(conta_numeros([6.0, 7.5, 8.0]), 3)
  check.eq(conta_numeros([8.5, 9.0, 10.0, 7.5, 9.5]), 5)
}

/// Representa os possíveis votos dos eleitores.
pub type Candidatos {
  Primeiro
  Segundo
  Branco
}

/// Representa o resultado final da eleição.
pub type Resultado {
  VitoriaPrimeiro
  VitoriaSegundo
  NovasEleicoes
}

/// Determina o resultado de uma eleição entre dois candidatos, cujas possibilidades de votação
/// são um deles e o voto em branco, com base em *lst*, uma lista com os votos.
/// - Se mais da metade dos votos (> 50%) forem brancos, ou houver empate entre os dois candidatos, 
/// novas eleições devem ser convocadas.
/// - Caso contrário, vence o candidato com mais votos.
pub fn verifica_resultado(lst: List(Candidatos)) -> Resultado {
  let total_primeiro_candidato: Int = conta_candidatos(Primeiro, lst)
  let total_segundo_candidato: Int = conta_candidatos(Segundo, lst)
  let total_branco: Int = conta_candidatos(Branco, lst)
  let total_votos: Int =
    total_primeiro_candidato + total_segundo_candidato + total_branco
  case
    total_branco > { total_votos / 2 }
    || total_primeiro_candidato == total_segundo_candidato
  {
    True -> NovasEleicoes
    False ->
      case total_primeiro_candidato > total_segundo_candidato {
        True -> VitoriaPrimeiro
        False -> VitoriaSegundo
      }
  }
}

/// Conta a quantidade de votos de *candidato* em *lst*.
pub fn conta_candidatos(candidato: Candidatos, lst: List(Candidatos)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] if primeiro == candidato ->
      1 + conta_candidatos(candidato, resto)
    [_, ..resto] -> conta_candidatos(candidato, resto)
  }
}

pub fn verifica_resultado_examples() {
  check.eq(verifica_resultado([]), NovasEleicoes)
  check.eq(verifica_resultado([Primeiro]), VitoriaPrimeiro)
  check.eq(verifica_resultado([Segundo]), VitoriaSegundo)
  check.eq(verifica_resultado([Branco, Branco, Branco]), NovasEleicoes)
  check.eq(verifica_resultado([Primeiro, Segundo]), NovasEleicoes)
  check.eq(
    verifica_resultado([Primeiro, Branco, Primeiro, Segundo, Branco]),
    VitoriaPrimeiro,
  )
  check.eq(
    verifica_resultado([Primeiro, Segundo, Branco, Segundo, Branco]),
    VitoriaSegundo,
  )
  check.eq(
    verifica_resultado([Primeiro, Primeiro, Branco, Branco]),
    VitoriaPrimeiro,
  )
  check.eq(
    verifica_resultado([Branco, Segundo, Primeiro, Branco, Segundo, Branco]),
    VitoriaSegundo,
  )
  check.eq(
    verifica_resultado([Branco, Segundo, Branco, Branco, Segundo, Branco]),
    NovasEleicoes,
  )
}

/// Representa uma entrada em um sistema de arquivos.
/// Cada entrada pode ser:
/// - Arq(nome, tamanho): um arquivo com seu nome e tamanho em bytes.
/// - Dir(nome, entradas): um diretório identificado por um nome e contendo uma lista de outras entradas.
pub type Entrada {
  Arq(nome: String, tamanho: Int)
  Dir(nome: String, entradas: List(Entrada))
}

/// Devolve o tamanho em bytes dos arquivos de *ent*, uma entrada com arquivos e diretórios.
pub fn calcula_tamanho(ent: Entrada) -> Int {
  case ent {
    Arq(_, tamanho) -> tamanho
    Dir(_, entradas) -> calcula_tamanho_lista(entradas)
  }
}

pub fn calcula_tamanho_examples() {
  let arq = Arq("final.txt", 875)
  let dir1 = Dir("correcoes", [Arq("rascunho.txt", 12_450), arq])
  let dir2 = Dir("trabs", [Arq("trab1.md", 1680), dir1, Arq("trab2.md", 65)])
  let dir3 = Dir("6879", [])
  let ent =
    Dir("disciplinas", [
      Dir("12026", [Arq("alunos.txt", 2500), dir2]),
      dir3,
      Dir("6884", []),
      Arq("anotacoes.txt", 9),
    ])
  check.eq(calcula_tamanho(arq), 875)
  check.eq(calcula_tamanho(dir1), 13_325)
  check.eq(calcula_tamanho(dir2), 15_070)
  check.eq(calcula_tamanho(dir3), 0)
  check.eq(calcula_tamanho(ent), 17_579)
}

/// Devolve o tamanho em bytes dos arquivos de *lst*, uma lista de entradas.
pub fn calcula_tamanho_lista(lst: List(Entrada)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] ->
      calcula_tamanho(primeiro) + calcula_tamanho_lista(resto)
  }
}

pub fn calcula_tamanho_lista_examples() {
  let arq = Arq("final.txt", 875)
  let dir1 = Dir("correcoes", [Arq("rascunho.txt", 12_450), arq])
  let dir2 = Dir("trabs", [Arq("trab1.md", 1680), dir1, Arq("trab2.md", 65)])
  let dir3 = Dir("6879", [])
  let ent =
    Dir("disciplinas", [
      Dir("12026", [Arq("alunos.txt", 2500), dir2]),
      dir3,
      Dir("6884", []),
      Arq("anotacoes.txt", 9),
    ])
  check.eq(calcula_tamanho_lista(dir1.entradas), 13_325)
  check.eq(calcula_tamanho_lista(dir2.entradas), 15_070)
  check.eq(calcula_tamanho_lista(dir3.entradas), 0)
  check.eq(calcula_tamanho_lista(ent.entradas), 17_579)
}

/// Devolve o maior arquivo de *ent*, considerando o tamanho em bytes.
/// Caso não haja nenhum arquivo em *ent*, devolve Error(Nil)
/// Caso haja dois arquivos de mesmo tamanho em *ent*, devolve um deles.
pub fn maior_arquivo(ent: Entrada) -> Result(Entrada, Nil) {
  case ent {
    Arq(_, _) -> Ok(ent)
    Dir(_, entradas) -> maior_arquivo_lista(entradas)
  }
}

pub fn maior_arquivo_examples() {
  let arq = Arq("final.txt", 875)
  let dir1 = Dir("correcoes", [Arq("rascunho.txt", 10_000), arq])
  let dir2 =
    Dir("trabs", [
      Arq("trab1.md", 12_000),
      dir1,
      Arq("trab2.md", 65),
      Arq("trab3.md", 12_000),
    ])
  let dir3 = Dir("6879", [])
  let ent =
    Dir("disciplinas", [
      Dir("12026", [Arq("alunos.txt", 12_500), dir2]),
      dir3,
      Dir("6884", []),
      Arq("anotacoes.txt", 10_000),
    ])
  check.eq(maior_arquivo(arq), Ok(Arq("final.txt", 875)))
  check.eq(maior_arquivo(dir1), Ok(Arq("rascunho.txt", 10_000)))
  check.eq(maior_arquivo(dir2), Ok(Arq("trab1.md", 12_000)))
  check.eq(maior_arquivo(dir3), Error(Nil))
  check.eq(maior_arquivo(ent), Ok(Arq("alunos.txt", 12_500)))
}

/// Devolve o maior arquivo de *lst*, considerando o tamanho em bytes.
/// Caso não haja nenhum arquivo em *lst*, devolve Error(Nil)
/// Caso haja dois arquivos de mesmo tamanho em *ent*, devolve um deles.
pub fn maior_arquivo_lista(lst: List(Entrada)) -> Result(Entrada, Nil) {
  case lst {
    [] -> Error(Nil)
    [primeiro, ..resto] ->
      case maior_arquivo(primeiro), maior_arquivo_lista(resto) {
        Ok(arq), Ok(arq2) ->
          case arq, arq2 {
            Arq(_, tamanhoa), Arq(_, tamanhob) if tamanhoa >= tamanhob ->
              Ok(arq)
            Arq(_, _), Arq(_, _) -> Ok(arq2)
            _, _ -> Error(Nil)
          }
        Ok(arq), Error(Nil) -> Ok(arq)
        Error(Nil), Ok(arq) -> Ok(arq)
        _, _ -> Error(Nil)
      }
  }
}

pub fn maior_arquivo_lista_examples() {
  let arq = Arq("final.txt", 875)
  let dir1 = Dir("correcoes", [Arq("rascunho.txt", 10_000), arq])
  let dir2 =
    Dir("trabs", [
      Arq("trab1.md", 12_000),
      dir1,
      Arq("trab2.md", 65),
      Arq("trab3.md", 12_000),
    ])
  let dir3 = Dir("6879", [])
  let ent =
    Dir("disciplinas", [
      Dir("12026", [Arq("alunos.txt", 12_500), dir2]),
      dir3,
      Dir("6884", []),
      Arq("anotacoes.txt", 10_000),
    ])
  check.eq(maior_arquivo_lista(dir1.entradas), Ok(Arq("rascunho.txt", 10_000)))
  check.eq(maior_arquivo_lista(dir2.entradas), Ok(Arq("trab1.md", 12_000)))
  check.eq(maior_arquivo_lista(dir3.entradas), Error(Nil))
  check.eq(maior_arquivo_lista(ent.entradas), Ok(Arq("alunos.txt", 12_500)))
}

/// Representa um ponto no sistema cartesiano com as coordenadas x e y.
pub type Ponto {
  Ponto(x: Int, y: Int)
}

/// Representa um retângulo e suas dimensões largura e altura.
pub type Retangulo {
  Retangulo(largura: Int, altura: Int)
}

/// Determina o retângulo delimitador de altura e largura mínimas que cobre
/// *pontos*, uma lista de pontos no plano cartesiano. 
/// Se *pontos* for uma lista vazia, devolve Error(Nil).
/// Se existir 1 ponto, o retângulo terá altura e largura iguais a 0.
pub fn retangulo_delimitador(pontos: List(Ponto)) -> Result(Retangulo, Nil) {
  let px = pontos_x(pontos)
  let py = pontos_y(pontos)
  let menor_x = minimo(px)
  let maior_x = maximo(px)
  let menor_y = minimo(py)
  let maior_y = maximo(py)
  case menor_x, maior_x, menor_y, maior_y {
    Ok(menor_x), Ok(maior_x), Ok(menor_y), Ok(maior_y) ->
      Ok(Retangulo(maior_x - menor_x, maior_y - menor_y))
    _, _, _, _ -> Error(Nil)
  }
}

pub fn retangulo_delimitador_examples() {
  //                |
  //                |        p5
  //       p1       |
  //                |    p4
  //                | p3
  //  --------------+-------------
  //            p2  |
  //                |   p6
  //                |
  let p1 = Ponto(-10, 5)
  let p2 = Ponto(-3, -1)
  let p3 = Ponto(1, 1)
  let p4 = Ponto(4, 3)
  let p5 = Ponto(9, 8)
  let p6 = Ponto(2, -3)

  check.eq(retangulo_delimitador([]), Error(Nil))
  check.eq(retangulo_delimitador([p1]), Ok(Retangulo(0, 0)))
  check.eq(retangulo_delimitador([p2, p3]), Ok(Retangulo(4, 2)))
  check.eq(retangulo_delimitador([p2, p3, p6]), Ok(Retangulo(5, 4)))
  check.eq(retangulo_delimitador([p1, p5, p4]), Ok(Retangulo(19, 5)))
  check.eq(retangulo_delimitador([p6, p5, p4]), Ok(Retangulo(7, 11)))
  check.eq(
    retangulo_delimitador([p2, p3, p1, p6, p4, p5]),
    Ok(Retangulo(19, 11)),
  )
}

/// Devolve as coordenadas x de *pontos*.
fn pontos_x(pontos: List(Ponto)) -> List(Int) {
  case pontos {
    [] -> []
    [Ponto(x, _), ..resto] -> [x, ..pontos_x(resto)]
  }
}

pub fn pontos_x_examples() {
  let p1 = Ponto(-10, 5)
  let p2 = Ponto(-3, -1)
  let p3 = Ponto(1, 1)
  let p4 = Ponto(4, 3)
  let p5 = Ponto(9, 8)
  let p6 = Ponto(2, -3)

  check.eq(pontos_x([]), [])
  check.eq(pontos_x([p1]), [-10])
  check.eq(pontos_x([p2, p1, p5]), [-3, -10, 9])
  check.eq(pontos_x([p4, p2, p6, p1, p5, p3]), [4, -3, 2, -10, 9, 1])
}

/// Devolve as coordenadas y de *pontos*.
fn pontos_y(pontos: List(Ponto)) -> List(Int) {
  case pontos {
    [] -> []
    [Ponto(_, y), ..resto] -> [y, ..pontos_y(resto)]
  }
}

pub fn pontos_y_examples() {
  let p1 = Ponto(-10, 5)
  let p2 = Ponto(-3, -1)
  let p3 = Ponto(1, 1)
  let p4 = Ponto(4, 3)
  let p5 = Ponto(9, 8)
  let p6 = Ponto(2, -3)

  check.eq(pontos_y([]), [])
  check.eq(pontos_y([p1]), [5])
  check.eq(pontos_y([p2, p1, p5]), [-1, 5, 8])
  check.eq(pontos_y([p4, p2, p6, p1, p5, p3]), [3, -1, -3, 5, 8, 1])
}

/// Calcula quantos itens de classe 1 são necessários
/// para construir um item de classe *n*, o qual variar entre 1 e 10.
/// Regras do jogo:
/// - Um item de classe 1 requer 1 item.
/// - Um item de classe n (n > 1) requer 2 itens da classe (n - 1).
/// Se *n* for menor que 1, ou maior que 10, a função retorna 0.
pub fn quantidade_itens(n: Int) -> Int {
  case n {
    _ if n <= 0 || n > 10 -> 0
    1 -> 1
    _ -> 2 * quantidade_itens(n - 1)
  }
}

pub fn quantidade_itens_examples() {
  check.eq(quantidade_itens(-1), 0)
  check.eq(quantidade_itens(0), 0)
  check.eq(quantidade_itens(1), 1)
  check.eq(quantidade_itens(2), 2)
  check.eq(quantidade_itens(3), 4)
  check.eq(quantidade_itens(4), 8)
  check.eq(quantidade_itens(5), 16)
  check.eq(quantidade_itens(6), 32)
  check.eq(quantidade_itens(7), 64)
  check.eq(quantidade_itens(8), 128)
  check.eq(quantidade_itens(9), 256)
  check.eq(quantidade_itens(10), 512)
  check.eq(quantidade_itens(12), 0)
}

/// Devolve True se *lsta* é prefixo de *lstb*, isto é, os elementos de *lsta*
/// aparecem no início de *lstb*. Devolve False, caso contrário.
pub fn prefixo(lsta: List(a), lstb: List(a)) -> Bool {
  case lsta, lstb {
    [], _ -> True
    _, [] -> False
    [a, ..restoa], [b, ..restob] -> a == b && prefixo(restoa, restob)
  }
}

pub fn prefixo_examples() {
  check.eq(prefixo([], []), True)
  check.eq(prefixo([], [3, 4]), True)
  check.eq(prefixo([3, 4], []), False)
  check.eq(prefixo([3, 4], [3, 4]), True)
  check.eq(prefixo([3, 4], [3, 4, 6, 8]), True)
  check.eq(prefixo([3, 4], [3, 5]), False)
  check.eq(prefixo([3, 4, 5], [3, 4]), False)
}
