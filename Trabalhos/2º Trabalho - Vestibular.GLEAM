// Alunos: Guilherme Jucoski da Silva - ra138642
//         Matheus Henrique Borsato - ra138246

import gleam/int
import gleam/list
import sgleam/check

/// Representa o valor máximo de uma questão.
const total_questao: Float = 6.0

/// Representa uma prova de um participante do vestibular da UEM.
pub type Prova {
  // O código do participante, sua nota da redação e sua lista de respostas são os elementos da prova.
  // A nota de redação deve ser um inteiro entre 0 e 120.
  // As respostas devem estar entre 0 e 31.
  Prova(codigo: Int, redacao: Int, respostas: List(Int))
}

/// Representa o desempenho de um participante no vestibular da UEM.
pub type Desempenho {
  // O código do participante e sua nota final são os elementos do desempenho.
  Desempenho(codigo: Int, nota: Float)
}

/// Representa o gabarito de uma prova do vestibular da UEM.
/// As respostas devem estar entre 0 e 31.
pub type Gabarito =
  List(Int)

/// Retorna a maior potência de 2 menor ou igual a *n*,
/// iniciando a busca a partir de *pot*.
/// Requer que *n* seja um número positivo e que *pot* seja uma
/// potência positiva de 2 e menor ou igual a *n*.
pub fn maior_potencia(n: Int, pot: Int) -> Int {
  case pot * 2 > n {
    True -> pot
    False -> maior_potencia(n, pot * 2)
  }
}

pub fn maior_potencia_examples() {
  check.eq(maior_potencia(1, 1), 1)
  check.eq(maior_potencia(26, 1), 16)
  check.eq(maior_potencia(63, 1), 32)
  check.eq(maior_potencia(64, 1), 64)
  check.eq(maior_potencia(5, 2), 4)
  check.eq(maior_potencia(26, 4), 16)
  check.eq(maior_potencia(20, 8), 16)
  check.eq(maior_potencia(16, 16), 16)
}

/// Devolve uma lista em ordem decrescente com as potências positivas de 2
/// que formam *n*, sendo este um número não negativo.
/// Devolve lista vazia se *n* for não positivo.
pub fn alternativas(n: Int) -> List(Int) {
  case n <= 0 {
    True -> []
    False -> {
      let p = maior_potencia(n, 1)
      [p, ..alternativas(n - p)]
    }
  }
}

pub fn alternativas_examples() {
  check.eq(alternativas(-1), [])
  check.eq(alternativas(0), [])
  check.eq(alternativas(1), [1])
  check.eq(alternativas(2), [2])
  check.eq(alternativas(3), [2, 1])
  check.eq(alternativas(7), [4, 2, 1])
  check.eq(alternativas(12), [8, 4])
  check.eq(alternativas(31), [16, 8, 4, 2, 1])
  check.eq(alternativas(32), [32])
  check.eq(alternativas(45), [32, 8, 4, 1])
}

/// Seleciona os elementos de *lst*, cujo valor de *lst.redacao*
/// seja diferente de 0.
pub fn desclassifica_redacao(lst: List(Prova)) -> List(Prova) {
  list.filter(lst, fn(a: Prova) -> Bool { a.redacao != 0 })
}

pub fn desclassificar_redacao_examples() {
  let p1 = Prova(1023, 87, [5, 12, 31, 0, 7])
  let p2 = Prova(4581, 120, [31, 2, 2, 15, 8])
  let p3 = Prova(7740, 0, [1, 4, 16, 3, 17])
  let p4 = Prova(3309, 45, [7, 9, 30, 25, 20])
  let p5 = Prova(9991, 113, [26, 31, 4, 1, 0])
  let p6 = Prova(2048, 0, [1, 2, 3, 4, 5])
  let p7 = Prova(5502, 0, [22, 8, 8, 16, 1])
  let p8 = Prova(6174, 99, [3, 2, 31, 16, 8])

  check.eq(desclassifica_redacao([]), [])
  check.eq(desclassifica_redacao([p1]), [p1])
  check.eq(desclassifica_redacao([p3]), [])
  check.eq(desclassifica_redacao([p1, p4, p8]), [p1, p4, p8])
  check.eq(desclassifica_redacao([p6, p7]), [])
  check.eq(desclassifica_redacao([p1, p2, p3, p4, p5, p6, p7, p8]), [
    p1,
    p2,
    p4,
    p5,
    p8,
  ])
}

/// Conta a quantidade de elementos de *lst*.
pub fn conta_elementos(lst: List(a)) -> Int {
  list.fold_right(lst, 0, fn(acc: Int, _: a) -> Int { acc + 1 })
}

pub fn conta_elementos_examples() {
  check.eq(conta_elementos([]), 0)
  check.eq(conta_elementos([10]), 1)
  check.eq(conta_elementos(["a", "b", "c"]), 3)
  check.eq(conta_elementos([1, 2, 3, 4]), 4)
}

/// Calcula a nota total de *respostas* em relação a *gabarito*, comparando
/// os pares correspondentes das duas listas.
/// O processo é feito apenas enquanto houver pares correspondentes e, portanto,
/// se as listas tiverem tamanhos diferentes, os elementos excedentes são ignorados.
pub fn calcula_nota_questoes(respostas: List(Int), gabarito: Gabarito) -> Float {
  case respostas, gabarito {
    [], [] -> 0.0
    [pa, ..restoa], [pb, ..restob] ->
      nota_questao(pa, pb) +. calcula_nota_questoes(restoa, restob)
    // Caso impossível
    _, _ -> 0.0
  }
}

pub fn calcula_nota_questoes_examples() {
  check.eq(calcula_nota_questoes([], []), 0.0)
  check.eq(calcula_nota_questoes([0], [0]), 6.0)
  check.eq(calcula_nota_questoes([1], [0]), 0.0)
  check.eq(calcula_nota_questoes([2], [3]), 3.0)
  check.eq(calcula_nota_questoes([1, 2], [1, 3]), 9.0)
  check.eq(calcula_nota_questoes([1, 2, 3], [1, 3]), 9.0)
  check.eq(calcula_nota_questoes([1, 2], [1, 3, 7]), 9.0)
  check.eq(calcula_nota_questoes([9, 14, 12], [25, 31, 8]), 7.6)
  check.eq(
    calcula_nota_questoes([4, 5, 10, 8, 10, 11, 2, 1, 5], [
      4, 4, 10, 12, 9, 11, 11, 15, 31,
    ]),
    26.9,
  )
}

/// Calcula a nota que deve ser atribuída a *resposta* de uma
/// questão, com base em *resposta_correta*.
/// Cada *resposta* e *resposta_correta* representam um conjunto de alternativas selecionadas,
/// todas potências de 2, codificadas como um número inteiro.
///
/// Casos:
/// 1. Gabarito zero (*resposta_correta* == 0):
///    - Se *resposta* == 0, a nota atribuída é 6.0.
///    - Caso contrário, a nota é 0.0.
///
/// 2. Gabarito diferente de zero (*resposta_correta* != 0):
///    - Se todas as alternativas obtidas de *resposta* estão contidas nas alternativas
///    obtidas de *resposta_correta*, a nota é proporcional ao número de alternativas marcadas,
///    usando a fórmula:
///        nota = (quantidade de alternativas marcadas / quantidade de alternativas corretas) * total_questao
///      onde *total_questao* é a pontuação máxima da questão.
///    - Caso contrário, se *resposta* contém alternativas que não estão nas alternativas de
///    *resposta_correta*, a nota é 0.0.
pub fn nota_questao(resposta: Int, resposta_correta: Int) -> Float {
  case resposta_correta == 0 {
    True ->
      case resposta == 0 {
        True -> 6.0
        False -> 0.0
      }
    False -> {
      let marcadas: List(Int) = alternativas(resposta)
      let corretas: List(Int) = alternativas(resposta_correta)
      case esta_contida(marcadas, corretas) {
        True -> {
          let quantidade_marcadas: Int = conta_elementos(marcadas)
          let quantidade_corretas: Int = conta_elementos(corretas)
          int.to_float(quantidade_marcadas)
          *. total_questao
          /. int.to_float(quantidade_corretas)
        }
        False -> 0.0
      }
    }
  }
}

pub fn nota_questao_examples() {
  // Casos em que *resposta_correta* == 0:
  check.eq(nota_questao(0, 0), 6.0)
  check.eq(nota_questao(13, 0), 0.0)
  // Casos em que *resposta_correta* representa uma única alternativa válida:
  check.eq(nota_questao(8, 8), 6.0)
  check.eq(nota_questao(0, 8), 0.0)
  // Casos em que *resposta_correta* representa duas alternativas válidas:
  check.eq(nota_questao(12, 12), 6.0)
  check.eq(nota_questao(8, 12), 3.0)
  check.eq(nota_questao(13, 12), 0.0)
  // Casos em que *resposta_correta* representa três alternativas válidas:
  check.eq(nota_questao(13, 13), 6.0)
  check.eq(nota_questao(5, 13), 4.0)
  check.eq(nota_questao(4, 13), 2.0)
  check.eq(nota_questao(10, 13), 0.0)
  // Casos em que *resposta_correta* representa quatro alternativas válidas:
  check.eq(nota_questao(23, 23), 6.0)
  check.eq(nota_questao(22, 23), 4.5)
  check.eq(nota_questao(20, 23), 3.0)
  check.eq(nota_questao(16, 23), 1.5)
  check.eq(nota_questao(24, 23), 0.0)
  // Casos em que *resposta_correta* representa todas as alternativas válidas:
  check.eq(nota_questao(31, 31), 6.0)
  check.eq(nota_questao(15, 31), 4.8)
  check.eq(nota_questao(7, 31), 3.6)
  check.eq(nota_questao(3, 31), 2.4)
  check.eq(nota_questao(1, 31), 1.2)
  check.eq(nota_questao(0, 31), 0.0)
}

/// Verifica se todos os elementos de *lsta* estão em *lstb*, considerando
/// que *lsta* e *lstb* estão ambas em ordem crescente ou decrescente.
/// Devolve True, caso *lsta* esteja contida em *lstb* e False, caso contrário.
pub fn esta_contida(lsta: List(a), lstb: List(a)) -> Bool {
  case lsta, lstb {
    [], _ -> True
    [_, ..], [] -> False
    [primeiroa, ..restoa], [primeirob, ..restob] if primeiroa == primeirob ->
      esta_contida(restoa, restob)
    [primeiroa, ..restoa], [_, ..restob] ->
      esta_contida([primeiroa, ..restoa], restob)
  }
}

pub fn esta_contida_examples() {
  check.eq(esta_contida([], []), True)
  check.eq(esta_contida([], [2]), True)
  check.eq(esta_contida([0], []), False)
  check.eq(esta_contida([1], [1]), True)
  check.eq(esta_contida([1, 3], [0, 1, 2, 3]), True)
  check.eq(esta_contida([1, 3], [1, 3, 5, 7]), True)
  check.eq(esta_contida([1, 3], [0, 1, 2, 4]), False)
  check.eq(esta_contida([1, 3], [0, 2, 3, 4]), False)
  check.eq(esta_contida([3, 1], [4, 3, 2, 1]), True)
  check.eq(esta_contida([3, 1], [3, 2, 1, 0]), True)
  check.eq(esta_contida([3, 1], [4, 2, 1, 0]), False)
  check.eq(esta_contida([3, 1], [3, 2, 0, -1]), False)
}

/// Calcula a nota total de cada prova presente em *lst*, utilizando o
/// *gabarito* para determinar a pontuação das questões, mantendo-se
/// o código de cada prova como identificador da nota.
/// A nota é calculada, somando-se a nota da redação com a nota das questões.
pub fn calcula_notas_totais(
  lst: List(Prova),
  gabarito: Gabarito,
) -> List(Desempenho) {
  list.map(lst, fn(p: Prova) -> Desempenho {
    Desempenho(
      p.codigo,
      int.to_float(p.redacao) +. calcula_nota_questoes(p.respostas, gabarito),
    )
  })
}

pub fn calcula_notas_totais_examples() {
  let gabarito: Gabarito = [3, 5, 21]

  let p1 = Prova(1000, 80, [3, 1, 7])
  let p2 = Prova(2000, 50, [1, 4, 21])
  let p3 = Prova(3000, 120, [6, 5, 20])

  check.eq(calcula_notas_totais([], gabarito), [])
  check.eq(calcula_notas_totais([p1], gabarito), [Desempenho(1000, 89.0)])
  check.eq(calcula_notas_totais([p1, p2, p3], gabarito), [
    Desempenho(1000, 89.0),
    Desempenho(2000, 62.0),
    Desempenho(3000, 130.0),
  ])
}

/// Cria uma lista com os elementos de *lst*, uma lista com o
/// desempenho de participantes de um vestibular, em ordem não crescente.
pub fn ordena(lst: List(Desempenho)) -> List(Desempenho) {
  list.fold_right(lst, [], insere_ordenado)
}

pub fn ordena_examples() {
  let d1 = Desempenho(1000, 140.5)
  let d2 = Desempenho(2000, 140.5)
  let d3 = Desempenho(3000, 160.0)
  let d4 = Desempenho(4000, 152.4)
  let d5 = Desempenho(5000, 100.0)
  check.eq(ordena([]), [])
  check.eq(ordena([d1]), [d1])
  check.eq(ordena([d2, d1, d3]), [d3, d1, d2])
  check.eq(ordena([d1, d2, d3, d4, d5]), [d3, d4, d1, d2, d5])
}

/// Devolve uma nova lst com os mesmos elementos de *lst*, uma lista com o
/// desempenho de participantes de um vestibular, junto com *d*, um novo desempenho, em
/// ordem não crescente.
///
/// Caso haja empate nas notas, o desempenho de menor código deve ser colocado primeiro.
/// Requer que *lst* esteja em ordem não crescente.
pub fn insere_ordenado(lst: List(Desempenho), d: Desempenho) -> List(Desempenho) {
  case lst {
    [] -> [d]
    [primeiro, ..] if d.nota >. primeiro.nota -> [d, ..lst]
    [primeiro, ..] if d.nota == primeiro.nota && d.codigo < primeiro.codigo -> [
      d,
      ..lst
    ]
    [primeiro, ..resto] -> [primeiro, ..insere_ordenado(resto, d)]
  }
}

pub fn insere_ordenado_examples() {
  let d1 = Desempenho(1000, 140.5)
  let d2 = Desempenho(2000, 140.5)
  let d3 = Desempenho(3000, 160.0)
  let d4 = Desempenho(4000, 152.4)
  let d5 = Desempenho(5000, 100.0)

  check.eq(insere_ordenado([], d1), [d1])
  check.eq(insere_ordenado([d3], d1), [d3, d1])
  check.eq(insere_ordenado([d1], d3), [d3, d1])
  check.eq(insere_ordenado([d2], d1), [d1, d2])
  check.eq(insere_ordenado([d1], d2), [d1, d2])
  check.eq(insere_ordenado([d1, d2], d3), [d3, d1, d2])
  check.eq(insere_ordenado([d3, d1, d2], d4), [d3, d4, d1, d2])
  check.eq(insere_ordenado([d4, d1, d2, d5], d3), [d3, d4, d1, d2, d5])
  check.eq(insere_ordenado([d3, d4, d2, d5], d1), [d3, d4, d1, d2, d5])
  check.eq(insere_ordenado([d3, d4, d1, d2], d5), [d3, d4, d1, d2, d5])
}

/// Verifica se todas as provas de *lst* são válidas. Devolve True, caso sejam
/// e False, caso contrário.
/// Para uma prova ser válida:
/// 1. A nota da redação deve estar entre 0 e 120;
/// 2. Cada questão deve ter a sua resposta entre 0 e 31;
/// 3. O número de questões assinaladas deve ser igual ao número de respostas de *gabarito*.
pub fn provas_validas(lst: List(Prova), gabarito: Gabarito) -> Bool {
  list.fold_right(lst, True, fn(valido: Bool, p: Prova) -> Bool {
    valido && prova_valida(p, gabarito)
  })
}

pub fn provas_validas_examples() {
  let p1 = Prova(1000, 80, [3, 1, 7])
  let p2 = Prova(2000, 50, [1, 4, 21])
  let p3 = Prova(3000, 120, [6, 5, 20])
  // Redações inválidas:
  let p4 = Prova(4000, 130, [6, 1, 20])
  let p5 = Prova(5000, -10, [6, 4, 31])
  // Respostas inválidas:
  let p6 = Prova(6000, 100, [-1, 8, 21])
  let p7 = Prova(7000, 80, [11, 25, 32])
  // Quantidade de respostas inválida:
  let p8 = Prova(8000, 100, [15, 8])
  let p9 = Prova(9000, 1100, [15, 8, 2, 5])
  let gabarito = [6, 5, 20]

  check.eq(provas_validas([], gabarito), True)
  check.eq(provas_validas([p1], gabarito), True)
  check.eq(provas_validas([p1, p2, p3], gabarito), True)
  check.eq(provas_validas([p1, p2, p3, p4], gabarito), False)
  check.eq(provas_validas([p1, p2, p3, p5], gabarito), False)
  check.eq(provas_validas([p1, p2, p3, p6], gabarito), False)
  check.eq(provas_validas([p1, p2, p3, p7], gabarito), False)
  check.eq(provas_validas([p1, p2, p3, p8], gabarito), False)
  check.eq(provas_validas([p1, p2, p3, p9], gabarito), False)
  check.eq(
    provas_validas([p1, p2, p3, p4, p5, p6, p7, p8, p9], gabarito),
    False,
  )
}

/// Verifica se *p* é uma prova valida. Devolve True, caso seja
/// e False, caso contrário.
/// Para uma prova ser válida:
/// 1. A nota da redação deve estar entre 0 e 120;
/// 2. Cada questão deve ter a sua resposta entre 0 e 31;
/// 3. O número de questões assinaladas deve ser igual ao número de respostas de *gabarito*.
pub fn prova_valida(p: Prova, gabarito: Gabarito) -> Bool {
  list.fold_right(p.respostas, True, fn(valido: Bool, resposta: Int) -> Bool {
    valido && resposta >= 0 && resposta <= 31
  })
  && p.redacao >= 0
  && p.redacao <= 120
  && conta_elementos(p.respostas) == conta_elementos(gabarito)
}

pub fn prova_valida_examples() {
  let p1 = Prova(1000, 80, [3, 1, 7])
  let p2 = Prova(2000, 50, [1, 4, 21])
  let p3 = Prova(3000, 120, [6, 5, 20])
  // Redações inválidas:
  let p4 = Prova(4000, 130, [6, 1, 20])
  let p5 = Prova(5000, -10, [6, 4, 31])
  // Respostas inválidas:
  let p6 = Prova(6000, 100, [-1, 8, 21])
  let p7 = Prova(7000, 80, [11, 25, 32])
  // Quantidade de respostas inválida:
  let p8 = Prova(8000, 100, [15, 8])
  let p9 = Prova(9000, 1100, [15, 8, 2, 5])
  let gabarito = [6, 5, 20]

  check.eq(prova_valida(p1, gabarito), True)
  check.eq(prova_valida(p2, gabarito), True)
  check.eq(prova_valida(p3, gabarito), True)
  check.eq(prova_valida(p4, gabarito), False)
  check.eq(prova_valida(p5, gabarito), False)
  check.eq(prova_valida(p6, gabarito), False)
  check.eq(prova_valida(p7, gabarito), False)
  check.eq(prova_valida(p8, gabarito), False)
  check.eq(prova_valida(p9, gabarito), False)
}

/// Verifica se *gabarito* é válido. Devolve True, caso seja
/// e False, caso contrário.
/// Para o gabarito ser válido:
/// Todas as suas respostas devem estar entre 0 e 31.
pub fn gabarito_valido(gabarito: Gabarito) -> Bool {
  list.fold_right(gabarito, True, fn(valido: Bool, g: Int) -> Bool {
    valido && g >= 0 && g <= 31
  })
}

pub fn gabarito_valido_examples() {
  check.eq(gabarito_valido([]), True)
  check.eq(gabarito_valido([1]), True)
  check.eq(gabarito_valido([31]), True)
  check.eq(gabarito_valido([1, 2, 29, 30, 31]), True)
  check.eq(gabarito_valido([-1]), False)
  check.eq(gabarito_valido([32]), False)
  check.eq(gabarito_valido([-1, 1, 2, 29, 30, 31]), False)
  check.eq(gabarito_valido([1, 2, 29, 30, 31, 32]), False)
}

/// Gera o resultado geral do vestibular a partir de *lst*, uma lista de provas.
///
/// Caso alguma prova seja inválida ou o gabarito for inválido, retorna Error(Nil).
/// Caso esteja tudo válido, calcula a nota de todas as provas de *lst*, desclassificando
/// aquelas com nota da redação igual a 0, devolvendo os desempenhos em ordem não crescente.
pub fn resultado_geral(
  lst: List(Prova),
  gabarito: Gabarito,
) -> Result(List(Desempenho), Nil) {
  let validade: Bool =
    provas_validas(lst, gabarito) && gabarito_valido(gabarito)
  case validade {
    True -> {
      let classificados: List(Prova) = desclassifica_redacao(lst)
      let desempenhos: List(Desempenho) =
        calcula_notas_totais(classificados, gabarito)
      Ok(ordena(desempenhos))
    }
    False -> Error(Nil)
  }
}

pub fn resultado_geral_examples() {
  let p1 = Prova(1000, 80, [3, 1, 7])
  let p2 = Prova(2000, 50, [1, 4, 21])
  let p3 = Prova(3000, 120, [6, 5, 20])
  let p4 = Prova(4000, 130, [6, 1, 20])
  let p5 = Prova(5000, -10, [6, 4, 31])
  let p6 = Prova(6000, 100, [-1, 8, 21])
  let p7 = Prova(7000, 80, [11, 25, 32])
  let p8 = Prova(8000, 100, [15, 8])
  let p9 = Prova(9000, 1100, [15, 8, 2, 5])
  let gabarito = [6, 5, 20]

  check.eq(resultado_geral([], []), Ok([]))
  check.eq(resultado_geral([p1], gabarito), Ok([Desempenho(1000, 83.0)]))
  check.eq(
    resultado_geral([p1, p2, p3], gabarito),
    Ok([Desempenho(3000, 138.0), Desempenho(1000, 83.0), Desempenho(2000, 53.0)]),
  )

  // Gabarito inválido:
  check.eq(resultado_geral([p1, p2, p3], [-1, 5, 20]), Error(Nil))
  check.eq(resultado_geral([p1, p2, p3], [6, 5, 32]), Error(Nil))
  // Uma prova inválida:
  check.eq(resultado_geral([p1, p2, p3, p4], gabarito), Error(Nil))
  check.eq(resultado_geral([p1, p2, p3, p5], gabarito), Error(Nil))
  check.eq(resultado_geral([p1, p2, p3, p6], gabarito), Error(Nil))
  check.eq(resultado_geral([p1, p2, p3, p7], gabarito), Error(Nil))
  check.eq(resultado_geral([p1, p2, p3, p8], gabarito), Error(Nil))
  check.eq(resultado_geral([p1, p2, p3, p9], gabarito), Error(Nil))
  // Todas as provas inválidas:
  check.eq(resultado_geral([p4, p5, p6, p7, p8, p9], gabarito), Error(Nil))

  // Exemplo da Especificação:

  let gabarito_exemplo = [21, 10, 8, 16, 15]

  let prova1 = Prova(3211, 80, [4, 10, 4, 16, 10])
  let prova2 = Prova(7102, 0, [1, 2, 3, 4, 5])
  let prova3 = Prova(1234, 90, [21, 8, 8, 8, 14])
  let prova4 = Prova(5812, 32, [20, 0, 8, 16, 1])
  let prova5 = Prova(9123, 0, [5, 4, 3, 2, 1])

  check.eq(
    resultado_geral([prova1, prova2, prova3, prova4, prova5], gabarito_exemplo),
    Ok([Desempenho(1234, 109.5), Desempenho(3211, 97.0), Desempenho(5812, 49.5)]),
  )
}
