import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import sgleam/check

/// Concatena todos os elementos de *lst*.
/// Se *lst* for vazia, retorna uma string vazia.
pub fn concatena(lst: List(String)) -> String {
  list.fold_right(lst, "", fn(acc: String, s: String) { string.append(s, acc) })
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
  list.fold_right(lst, 0, fn(acc: Int, _: Int) { acc + 1 })
}

pub fn quantidade_numeros_examples() {
  check.eq(quantidade_numeros([]), 0)
  check.eq(quantidade_numeros([5]), 1)
  check.eq(quantidade_numeros([1, 2, 3, 4, 4, 3, 2, 1]), 8)
}

/// Converte *lst* para uma lista de strings.
pub fn ints_para_strings(lst: List(Int)) -> List(String) {
  list.map(lst, int.to_string)
}

pub fn ints_para_strings_examples() {
  check.eq(ints_para_strings([]), [])
  check.eq(ints_para_strings([2]), ["2"])
  check.eq(ints_para_strings([2, 4, 6, 8]), ["2", "4", "6", "8"])
}

/// Remove as strings vazias de *lst*.
pub fn remove_vazias(lst: List(String)) -> List(String) {
  list.filter(lst, fn(elemento: String) { elemento != "" })
}

pub fn remove_vazias_examples() {
  check.eq(remove_vazias([]), [])
  check.eq(remove_vazias([""]), [])
  check.eq(remove_vazias(["Corinthians"]), ["Corinthians"])
  check.eq(remove_vazias(["", "Hoje", "Bom", "", "Oi", "", "Tarde"]), [
    "Hoje", "Bom", "Oi", "Tarde",
  ])
}

/// Devolve *lst* com os seus elementos em ordem contrária.
pub fn ordem_contraria(lst: List(Int)) -> List(Int) {
  list.fold_right(lst, [], fn(acc: List(Int), elemento: Int) {
    list.append(acc, [elemento])
  })
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
  list.fold_right(lst, Error(Nil), fn(acc: Result(Int, Nil), elemento: Int) {
    case acc {
      Ok(maximo) -> Ok(int.max(maximo, elemento))
      _ -> Ok(elemento)
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
  result.all(list.map(lst, int.parse))
}

pub fn strings_para_ints_examples() {
  check.eq(strings_para_ints([]), Ok([]))
  check.eq(strings_para_ints(["1"]), Ok([1]))
  check.eq(strings_para_ints(["a"]), Error(Nil))
  check.eq(strings_para_ints(["1", "2", "15", "-8"]), Ok([1, 2, 15, -8]))
  check.eq(strings_para_ints(["1", "a", "2"]), Error(Nil))
  check.eq(strings_para_ints(["2", "3", "9", "m"]), Error(Nil))
}

/// Calcula a amplitude dos valores de *lst*, isto é, a diferença
/// entre o valor máximo e mínimo de *lst*. 
/// Devolve Error(Nil) caso *lst* seja vazia.
pub fn amplitude(lst: List(Int)) -> Result(Int, Nil) {
  case lst {
    [] -> Error(Nil)
    [primeiro, ..resto] -> {
      let maximo = list.fold_right(resto, primeiro, int.max)
      let minimo = list.fold_right(resto, primeiro, int.min)
      Ok(maximo - minimo)
    }
  }
}

pub fn amplitude_examples() {
  check.eq(amplitude([]), Error(Nil))
  check.eq(amplitude([5]), Ok(0))
  check.eq(amplitude([4, 3, 8]), Ok(5))
  check.eq(amplitude([9, 2, 5]), Ok(7))
  check.eq(amplitude([-2, -5, 0, 4, 6]), Ok(11))
}

/// Conta quantos elementos de *lst* satisfazem o predicado *f*.
pub fn conta(lst: List(a), f: fn(a) -> Bool) -> Int {
  lst
  |> list.filter(f)
  |> list.fold_right(0, fn(acc: Int, _: a) -> Int { acc + 1 })
}

pub fn conta_examples() {
  check.eq(conta([3, 1, 4, 5, 7], int.is_odd), 4)
  check.eq(conta([3, 1, 4, 5, 7], int.is_even), 1)
  check.eq(conta(["", "Matheus", "UEM", ""], string.is_empty), 2)
  check.eq(conta([False, False, False, True], bool.negate), 3)
  check.eq(conta([True, True, True, False], bool.negate), 1)
}

/// Devolve uma função que aplica *f* ao argumento e *f* a esse resultado.
pub fn duas_vezes(f: fn(a) -> a) -> fn(a) -> a {
  fn(x) { f(f(x)) }
}

pub fn duas_vezes_examples() {
  check.eq(duas_vezes(fn(n) { n + 4 })(3), 11)
  check.eq(duas_vezes(fn(n) { n * 2 })(3), 12)
  check.eq(duas_vezes(duas_vezes)(fn(n) { n + 2 })(5), 13)
}

/// Combina os respectivos elementos de *lsta* e *lstb* em uma única lista 
/// usando *f*, uma função de entrada fornecida.
/// Se *lsta* e *lstb* possuírem tamanhos diferentes, os elementos extras
/// da lista maior são ignorados.
pub fn map2(lsta: List(a), lstb: List(b), f: fn(a, b) -> c) -> List(c) {
  case lsta, lstb {
    [primeiroa, ..restoa], [primeirob, ..restob] -> [
      f(primeiroa, primeirob),
      ..map2(restoa, restob, f)
    ]
    _, _ -> []
  }
}

pub fn map2_examples() {
  check.eq(map2([], [], int.add), [])
  check.eq(map2([7], [], int.add), [])
  check.eq(map2([], [7], int.add), [])
  check.eq(map2([-8.0], [4.0], float.multiply), [-32.0])
  check.eq(map2([1, 2, 3], [4, 5, 6], int.add), [5, 7, 9])
  check.eq(map2(["11010", "20", "25", "25"], [2, 8, 10, 16], int.base_parse), [
    Ok(26),
    Ok(16),
    Ok(25),
    Ok(37),
  ])
  // XOR:
  check.eq(
    map2(
      [False, False, True, True],
      [False, True, False, True],
      bool.exclusive_or,
    ),
    [False, True, True, False],
  )
  check.eq(map2([1, 2], ["a", "b", "c"], fn(a, b) { #(a, b) }), [
    #(1, "a"),
    #(2, "b"),
  ])
  check.eq(map2([8, 2, 30, 1, 10], [4, 0, 6, 4], int.divide), [
    Ok(2),
    Error(Nil),
    Ok(5),
    Ok(0),
  ])
  check.eq(map2([8, -2, 5, 10], [4, 0, 6, 4, 10], int.max), [8, 0, 6, 10])
}

/// Devolve uma nova lista contendo os valores obtidos aplicando 
/// *f* aos elementos de *lst*, mas apenas os elementos para os quais
/// *f* devolve Ok(_) são mantidos, descartando-se os resultados Error(_).
pub fn filter_map(lst: List(a), f: fn(a) -> Result(b, e)) -> List(b) {
  case lst {
    [] -> []
    [primeiro, ..resto] ->
      case f(primeiro) {
        Ok(resultado) -> [resultado, ..filter_map(resto, f)]
        Error(_) -> filter_map(resto, f)
      }
  }
}

pub fn filter_map_examples() {
  check.eq(filter_map([], int.parse), [])
  check.eq(filter_map(["a"], int.parse), [])
  check.eq(filter_map(["3"], int.parse), [3])
  check.eq(filter_map(["3", "a", "True", "25", "b", "12"], int.parse), [
    3, 25, 12,
  ])
  check.eq(filter_map(["a", "3", "25", "True", "12", "b"], int.parse), [
    3, 25, 12,
  ])
  check.eq(filter_map(["a", "3", "25", "True", "12", "b"], int.parse), [
    3, 25, 12,
  ])
  check.eq(filter_map([2, 4, 6, 1], fn(x) { Ok(x + 1) }), [3, 5, 7, 2])
  check.eq(filter_map([0, 4, 8, 0, 2], fn(x) { int.divide(16, x) }), [4, 2, 8])
}

/// Representa a continuação ou a paralisação de um processamento.
pub type ContinueOrStop(a) {
  Continue(a)
  Stop(a)
}

/// Devolve o resultado do processamento dos elementos de *lst*,
/// iniciando com o acumulador *acc* e aplicando a função *f*
/// sequencialmente a cada elemento e com base no resultado acumulado.
///
/// O processamento pode ser interrompido antes do fim da lista,
/// conforme o resultado devolvido por *f*. Caso contrário, o valor
/// final do acumulador é devolvido.
pub fn fold_until(lst: List(a), acc: b, f: fn(b, a) -> ContinueOrStop(b)) -> b {
  case lst {
    [] -> acc
    [primeiro, ..resto] ->
      case f(acc, primeiro) {
        Continue(novo_acc) -> fold_until(resto, novo_acc, f)
        Stop(novo_acc) -> novo_acc
      }
  }
}

pub fn fold_until_examples() {
  // Soma todos os elementos.
  let soma: fn(Int, Int) -> ContinueOrStop(Int) = fn(acc: Int, x: Int) {
    Continue(acc + x)
  }

  check.eq(fold_until([], 0, soma), 0)
  check.eq(fold_until([], 5, soma), 5)
  check.eq(fold_until([2, 5], 2, soma), 9)
  check.eq(fold_until([2, 5, 8], 0, soma), 15)

  // Soma elementos e para quando o valor acumulado ultrapassar 20.
  let soma_ate_20: fn(Int, Int) -> ContinueOrStop(Int) = fn(acc: Int, x: Int) {
    case acc > 20 {
      True -> Stop(acc)
      False -> {
        let total = acc + x
        case total <= 20 {
          True -> Continue(total)
          False -> Stop(total)
        }
      }
    }
  }

  check.eq(fold_until([], 0, soma_ate_20), 0)
  check.eq(fold_until([4], 5, soma_ate_20), 9)
  check.eq(fold_until([1], 20, soma_ate_20), 21)
  check.eq(fold_until([1], 21, soma_ate_20), 21)
  check.eq(fold_until([2, 3, 5, 1, 2], 4, soma_ate_20), 17)
  check.eq(fold_until([10, -3, 5, 7, 1, 2], 4, soma_ate_20), 23)
  check.eq(fold_until([9, 5, 2, 8, 7, 5, 2], 4, soma_ate_20), 28)
  check.eq(fold_until([9, 5, 3, 8, 7, 5, 2], 4, soma_ate_20), 21)

  // Concatena strings até encontrar uma string vazia.
  let concatena_ate_vazio: fn(String, String) -> ContinueOrStop(String) = fn(
    acc: String,
    s: String,
  ) {
    case s != "" {
      True -> Continue(acc <> s)
      False -> Stop(acc)
    }
  }

  check.eq(fold_until([], "", concatena_ate_vazio), "")
  check.eq(fold_until([], "hoje", concatena_ate_vazio), "hoje")
  check.eq(fold_until([""], "hoje", concatena_ate_vazio), "hoje")
  check.eq(fold_until([" é"], "hoje", concatena_ate_vazio), "hoje é")
  check.eq(fold_until(["", " é"], "hoje", concatena_ate_vazio), "hoje")
  check.eq(fold_until([" é", ""], "hoje", concatena_ate_vazio), "hoje é")
  check.eq(
    fold_until([" é ", "um ", "belo ", "dia."], "hoje", concatena_ate_vazio),
    "hoje é um belo dia.",
  )
  check.eq(
    fold_until([" é ", "um", "", "belo ", "dia."], "hoje", concatena_ate_vazio),
    "hoje é um",
  )
  check.eq(
    fold_until([" é ", "um ", "belo ", "dia.", ""], "hoje", concatena_ate_vazio),
    "hoje é um belo dia.",
  )

  // Conta o tamanho total das strings até encontrar uma string vazia.
  let soma_tamanhos: fn(Int, String) -> ContinueOrStop(Int) = fn(
    acc: Int,
    s: String,
  ) {
    case s != "" {
      True -> Continue(acc + string.length(s))
      False -> Stop(acc)
    }
  }

  check.eq(fold_until([], 0, soma_tamanhos), 0)
  check.eq(fold_until([""], 0, soma_tamanhos), 0)
  check.eq(fold_until(["hoje"], 0, soma_tamanhos), 4)
  check.eq(fold_until(["", "hoje"], 0, soma_tamanhos), 0)
  check.eq(fold_until(["hoje", ""], 0, soma_tamanhos), 4)
  check.eq(
    fold_until(["hoje", "é", "um", "belo", "dia."], 0, soma_tamanhos),
    15,
  )
  check.eq(
    fold_until(["hoje", "é", "um", "", "belo", "dia."], 0, soma_tamanhos),
    7,
  )
  check.eq(
    fold_until(["hoje", "é", "um", "belo", "dia.", ""], 0, soma_tamanhos),
    15,
  )

  // Procura o primeiro elemento maior que 10. Se não existir, devolve -1.
  let maior_que_10: fn(Int, Int) -> ContinueOrStop(Int) = fn(_: Int, x: Int) {
    case x <= 10 {
      True -> Continue(-1)
      False -> Stop(x)
    }
  }

  check.eq(fold_until([], 5, maior_que_10), 5)
  check.eq(fold_until([2, 5, 8], 5, maior_que_10), -1)
  check.eq(fold_until([2, 5, 10, 8], 5, maior_que_10), -1)
  check.eq(fold_until([12, 2, 5, 8], 5, maior_que_10), 12)
  check.eq(fold_until([3, 2, 15, 5, 8], 5, maior_que_10), 15)
  check.eq(fold_until([3, 2, -5, 5, 8, 25], 5, maior_que_10), 25)
  check.eq(
    fold_until([3, 2, -5, 5, 8, -8, 9, 10, 0, -10, -50], 5, maior_que_10),
    -1,
  )
}

/// Devolve o valor obtido pela aplicação de *f* sobre os inteiros de *n* 
/// até 1, juntamente ao valor acumulado, iniciando com o acumulador *acc*.
/// Se *n* ≤ 0, devolve *acc*.
pub fn num_reduz(n: Int, acc: b, f: fn(b, Int) -> b) -> b {
  case n <= 0 {
    True -> acc
    False -> num_reduz(n - 1, f(acc, n), f)
  }
}

pub fn num_reduz_examples() {
  check.eq(num_reduz(0, 0, int.add), 0)
  check.eq(num_reduz(-1, 0, int.add), 0)
  check.eq(num_reduz(-1, 5, int.add), 5)
  check.eq(num_reduz(8, 0, int.add), 36)
  check.eq(num_reduz(8, 10, int.add), 46)
  check.eq(num_reduz(5, 1, int.multiply), 120)
  check.eq(
    num_reduz(6, [10, 8], fn(acc: List(Int), n: Int) -> List(Int) {
      [n * 2, ..acc]
    }),
    [2, 4, 6, 8, 10, 12, 10, 8],
  )
}

/// Devolve uma lista com *n* repetições de *v*.
pub fn numero_repeticoes(n: Int, v: Int) -> List(Int) {
  num_reduz(n, [], fn(acc: List(Int), _: Int) -> List(Int) { [v, ..acc] })
}

pub fn numero_repeticoes_examples() {
  check.eq(numero_repeticoes(-1, 6), [])
  check.eq(numero_repeticoes(0, 6), [])
  check.eq(numero_repeticoes(1, 5), [5])
  check.eq(numero_repeticoes(3, -9), [-9, -9, -9])
  check.eq(numero_repeticoes(8, 2), [2, 2, 2, 2, 2, 2, 2, 2])
}

/// Calcula o valor de *a* elevado a *n*. Se *a* e *n* forem zeros 
/// ou se *n* for negativo, devolve 1.0.
pub fn exponencial(a: Float, n: Int) -> Float {
  num_reduz(n, 1.0, fn(acc: Float, _: Int) -> Float { a *. acc })
}

pub fn exponencial_examples() {
  check.eq(exponencial(0.0, -2), 1.0)
  check.eq(exponencial(0.0, 0), 1.0)
  check.eq(exponencial(0.0, 2), 0.0)
  check.eq(exponencial(3.0, -2), 1.0)
  check.eq(exponencial(3.0, 0), 1.0)
  check.eq(exponencial(3.0, 2), 9.0)
  check.eq(exponencial(-6.0, 2), 36.0)
  check.eq(exponencial(6.0, 3), 216.0)
  check.eq(exponencial(-6.0, 3), -216.0)
}

/// Devolve o produto dos números 1, 2, ..., *n*.
/// Se *n* for menor que 1, devolve o próprio 1.
pub fn produto_antecessores(n: Int) -> Int {
  num_reduz(n, 1, int.multiply)
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
  let valor_absoluto: Int = int.absolute_value(n)
  num_reduz(valor_absoluto, True, fn(acc: Bool, _: Int) -> Bool {
    bool.negate(acc)
  })
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

/// Verifica se *n* é ímpar. Devolve True, caso seja
/// e False, caso contrário.
pub fn eh_impar(n: Int) -> Bool {
  let valor_absoluto: Int = int.absolute_value(n)
  num_reduz(valor_absoluto, False, fn(acc: Bool, _: Int) -> Bool {
    bool.negate(acc)
  })
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

/// Produz uma nova lista ajustando os elementos de *lst* para que eles fiquem
/// com o mesmo número de caracteres. As strings com o maior tamanho
/// permanecem inalteradas, enquanto nas demais, são adicionados espaços em 
/// branco no final.
pub fn ajusta_painel(lst: List(String)) -> List(String) {
  let tamanho_maior_nome: Int =
    list.fold_right(lst, 0, fn(acc: Int, s: String) {
      int.max(acc, string.length(s))
    })
  list.map(lst, fn(s: String) {
    s <> string.repeat(" ", tamanho_maior_nome - string.length(s))
  })
}

pub fn ajusta_tamanho_examples() {
  check.eq(ajusta_painel([]), [])
  check.eq(ajusta_painel(["Maringá"]), ["Maringá"])
  check.eq(ajusta_painel(["Maringá", "Lapa"]), ["Maringá", "Lapa   "])
  check.eq(ajusta_painel(["São Paulo", "Maringá", "Londrina"]), [
    "São Paulo", "Maringá  ", "Londrina ",
  ])
  check.eq(
    ajusta_painel([
      "Lugar", "Carregador", "Carteira", "Alegria", "Olá", "", "Computador",
    ]),
    [
      "Lugar     ", "Carregador", "Carteira  ", "Alegria   ", "Olá       ",
      "          ", "Computador",
    ],
  )
}

/// Representa um aluno com seu nome e sua nota.
pub type Aluno {
  Aluno(nome: String, nota: Float)
}

/// Devolve uma lista com os nomes dos alunos de *lst*,
/// cujas notas estão acima da média geral de notas de 
/// todos os alunos em *lst*.
/// Em caso de *lst* vazia, retorna uma lista vazia.
pub fn acima_media(lst: List(Aluno)) -> List(String) {
  case calcula_media(lst) {
    Ok(media) -> {
      let acima_media: List(Aluno) =
        list.filter(lst, fn(a: Aluno) -> Bool { a.nota >. media })
      list.map(acima_media, fn(a: Aluno) -> String { a.nome })
    }
    Error(Nil) -> []
  }
}

pub fn acima_media_examples() {
  let aluno1: Aluno = Aluno("Matheus", 9.5)
  let aluno2: Aluno = Aluno("Pedro", 8.0)
  let aluno3: Aluno = Aluno("Rafael", 8.0)
  let aluno4: Aluno = Aluno("Ana", 6.7)
  let aluno5: Aluno = Aluno("Isabela", 4.0)
  let aluno6: Aluno = Aluno("Gabriel", 1.5)
  let aluno7: Aluno = Aluno("Yuri", 9.2)

  check.eq(acima_media([]), [])
  check.eq(acima_media([aluno1]), [])
  check.eq(acima_media([aluno1, aluno2]), ["Matheus"])
  check.eq(acima_media([aluno2, aluno1, aluno3]), ["Matheus"])
  check.eq(acima_media([aluno1, aluno2, aluno3, aluno4, aluno5, aluno6]), [
    "Matheus", "Pedro", "Rafael", "Ana",
  ])
  check.eq(
    acima_media([aluno1, aluno2, aluno3, aluno4, aluno5, aluno6, aluno7]),
    ["Matheus", "Pedro", "Rafael", "Yuri"],
  )
  check.eq(acima_media([aluno2, aluno3, aluno4, aluno5, aluno6, aluno7]), [
    "Pedro", "Rafael", "Ana", "Yuri",
  ])
}

/// Calcula a média das notas dos alunos presentes em *lst*.
/// Devolve Error(Nil) em caso de *lst* vazia.
pub fn calcula_media(lst: List(Aluno)) -> Result(Float, Nil) {
  case lst {
    [] -> Error(Nil)
    _ -> {
      let soma_notas: Float =
        list.fold_right(lst, 0.0, fn(acc: Float, a: Aluno) -> Float {
          acc +. a.nota
        })
      let quantidade_alunos: Int =
        list.fold_right(lst, 0, fn(acc: Int, _: Aluno) -> Int { acc + 1 })
      Ok(soma_notas /. int.to_float(quantidade_alunos))
    }
  }
}

pub fn calcula_media_examples() {
  let aluno1: Aluno = Aluno("Matheus", 9.5)
  let aluno2: Aluno = Aluno("Pedro", 8.0)
  let aluno3: Aluno = Aluno("Ana", 6.7)
  let aluno4: Aluno = Aluno("Isabela", 4.0)
  let aluno5: Aluno = Aluno("Gabriel", 0.5)

  check.eq(calcula_media([]), Error(Nil))
  check.eq(calcula_media([aluno2]), Ok(8.0))
  check.eq(calcula_media([aluno1, aluno2]), Ok(8.75))
  check.eq(calcula_media([aluno1, aluno2, aluno5]), Ok(6.0))
  check.eq(calcula_media([aluno1, aluno2, aluno3, aluno4, aluno5]), Ok(5.74))
}

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
  check.eq(mais_repetem(["Hoje"]), ["Hoje"])
  check.eq(mais_repetem(["Hoje", "Lugar"]), ["Hoje", "Lugar"])
  check.eq(mais_repetem(["Hoje", "Lugar", "Bom", "Hoje"]), ["Hoje"])
  check.eq(mais_repetem(["Casa", "Onde", "Talvez", "Casa", "Nada", "Onde"]), [
    "Casa", "Onde",
  ])
  check.eq(
    mais_repetem([
      "Casa", "Onde", "Talvez", "Onde", "Talvez", "Casa", "Nada", "Onde",
    ]),
    ["Onde"],
  )
}

/// Devolve o maior valor dentre os campos *repeticoes* dos 
/// elementos de *lst*. Se *lst* for vazia, devolve 0.
pub fn maior_repeticao(lst: List(Par)) -> Int {
  list.fold_right(lst, 0, fn(acc: Int, p: Par) -> Int {
    int.max(acc, p.repeticoes)
  })
}

pub fn maior_repeticao_examples() {
  let p1 = Par("hoje", 2)
  let p2 = Par("Oi", 1)
  let p3 = Par("Garrafa", 1)
  let p4 = Par("Dia", 4)
  let p5 = Par("Óculos", 3)
  let p6 = Par("Bom", 2)

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
pub fn converte_pares(lst: List(String)) -> List(Par) {
  list.fold(lst, [], fn(acc: List(Par), palavra: String) {
    insere_par(acc, palavra)
  })
}

pub fn converte_pares_examples() {
  check.eq(converte_pares([]), [])
  check.eq(converte_pares(["Casa"]), [Par("Casa", 1)])
  check.eq(converte_pares(["Casa", "Hoje", "Dia", "Hoje", "Dia", "Bem"]), [
    Par("Casa", 1),
    Par("Hoje", 2),
    Par("Dia", 2),
    Par("Bem", 1),
  ])
  check.eq(
    converte_pares([
      "Casa", "Hoje", "Dia", "Hoje", "Dia", "Bem", "Casa", "Casa", "Dia",
      "Celular",
    ]),
    [
      Par("Casa", 3),
      Par("Hoje", 2),
      Par("Dia", 3),
      Par("Bem", 1),
      Par("Celular", 1),
    ],
  )
}

/// Insere *palavra* em *acc*. Caso *palavra* não exista em *acc*, insere um novo elemento
/// em *acc* com número de repetições igual a 1. Caso *palavra* já exista em *acc*,
/// incrementa a sua quantidade de repetições.
pub fn insere_par(acc: List(Par), palavra: String) -> List(Par) {
  case acc {
    [] -> [Par(palavra, 1)]
    [primeiro, ..resto] if primeiro.palavra == palavra -> [
      Par(..primeiro, repeticoes: primeiro.repeticoes + 1),
      ..resto
    ]
    [primeiro, ..resto] -> [primeiro, ..insere_par(resto, palavra)]
  }
}

pub fn insere_par_examples() {
  check.eq(insere_par([], "Hoje"), [Par("Hoje", 1)])
  check.eq(insere_par([Par("Oi", 1), Par("Hoje", 2), Par("Gol", 1)], "Hoje"), [
    Par("Oi", 1),
    Par("Hoje", 3),
    Par("Gol", 1),
  ])
  check.eq(insere_par([Par("Oi", 1), Par("Hoje", 2), Par("Gol", 1)], "Oi"), [
    Par("Oi", 2),
    Par("Hoje", 2),
    Par("Gol", 1),
  ])
  check.eq(insere_par([Par("Oi", 1), Par("Hoje", 2)], "Gol"), [
    Par("Oi", 1),
    Par("Hoje", 2),
    Par("Gol", 1),
  ])
}
