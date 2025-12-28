import gleam/list
import sgleam/check

/// Verifica se todos os elementos de *lsta* estão presentes em *lstb*.
/// Devolve True, caso estejam e False, caso contrário.
pub fn verifica_lista(lsta: List(a), lstb: List(a)) -> Bool {
  case lsta {
    [] -> True
    [primeiro, ..resto] -> contem(lstb, primeiro) && verifica_lista(resto, lstb)
  }
}

pub fn verifica_lista_examples() {
  check.eq(verifica_lista([], []), True)
  check.eq(verifica_lista([], [3]), True)
  check.eq(verifica_lista([3], []), False)
  check.eq(verifica_lista([5], [5]), True)
  check.eq(verifica_lista([4, 4, 4, 4, 4], [4]), True)
  check.eq(verifica_lista([3], [1, 2, 3, 4]), True)
  check.eq(verifica_lista([2, 3], [5, 3, 9, 2]), True)
  check.eq(verifica_lista([2, 3], [5, 2, 4, 9]), False)
  check.eq(verifica_lista([6, 3], [5, 2, 4, 9]), False)
  check.eq(verifica_lista([3, 1, 4, 2], [1, 2, 3, 4]), True)
  check.eq(verifica_lista([3, 1, 5, 4, 2], [1, 2, 3, 4]), False)
  check.eq(verifica_lista([3, 1, 4, 2, 5], [1, 2, 3, 4]), False)
}

/// Verifica se *elemento* está presente em *lst*.
pub fn contem(lst: List(a), elemento: a) -> Bool {
  case lst {
    [] -> False
    [primeiro, ..resto] -> primeiro == elemento || contem(resto, elemento)
  }
}

pub fn contem_examples() {
  check.eq(contem([], 2), False)
  check.eq(contem([1, 2], 3), False)
  check.eq(contem([1, 3], 3), True)
  check.eq(contem([3, 1], 3), True)
}

/// Devolve todos os pares possíveis de serem formados entre
/// os elementos de *lsta* e *lstb*.
pub fn cria_pares(lsta: List(a), lstb: List(a)) -> List(List(a)) {
  case lsta {
    [] -> [[]]
    [primeiro] -> pares(primeiro, lstb)
    [primeiro, ..resto] ->
      list.append(pares(primeiro, lstb), cria_pares(resto, lstb))
  }
}

pub fn cria_pares_examples() {
  check.eq(cria_pares([], []), [[]])
  check.eq(cria_pares([3], []), [[]])
  check.eq(cria_pares([], [3]), [[]])
  check.eq(cria_pares([3], [3]), [[3, 3]])
  check.eq(cria_pares([3, 2], [5]), [[3, 5], [2, 5]])
  check.eq(cria_pares([3, 2], [5, 8]), [[3, 5], [3, 8], [2, 5], [2, 8]])
  check.eq(cria_pares([3, 1, 8], [7, 4]), [
    [3, 7],
    [3, 4],
    [1, 7],
    [1, 4],
    [8, 7],
    [8, 4],
  ])
}

/// Devolve todos os pares formados entre *elemento*
/// e os valores de *lst*.
pub fn pares(elemento: a, lst: List(a)) -> List(List(a)) {
  case lst {
    [] -> [[]]
    [primeiro] -> [[elemento, primeiro]]
    [primeiro, ..resto] -> [[elemento, primeiro], ..pares(elemento, resto)]
  }
}

pub fn pares_examples() {
  check.eq(pares(2, []), [[]])
  check.eq(pares(2, [2]), [[2, 2]])
  check.eq(pares(6, [3, 2, 5]), [[6, 3], [6, 2], [6, 5]])
}

/// Cria uma lista com os elementos de *lsta* que possuem na respectiva posição
/// de *lstb*, o valor True. Devolve Error(Nil), caso *lsta* e *lstb* possuam
/// quantidades diferentes de elementos.
pub fn seleciona_nomes(
  lsta: List(String),
  lstb: List(Bool),
) -> Result(List(String), Nil) {
  case lsta, lstb {
    [], [] -> Ok([])
    [primeiroa, ..restoa], [primeirob, ..restob] ->
      case seleciona_nomes(restoa, restob) {
        Ok(lista) if primeirob == True -> Ok([primeiroa, ..lista])
        Ok(lista) -> Ok(lista)
        _ -> Error(Nil)
      }
    _, _ -> Error(Nil)
  }
}

pub fn seleciona_nomes_examples() {
  check.eq(seleciona_nomes([], []), Ok([]))
  check.eq(seleciona_nomes(["Matheus"], []), Error(Nil))
  check.eq(seleciona_nomes(["Matheus"], [False, True]), Error(Nil))
  check.eq(seleciona_nomes(["Matheus"], [True]), Ok(["Matheus"]))
  check.eq(seleciona_nomes(["Matheus"], [False]), Ok([]))
  check.eq(
    seleciona_nomes(["Matheus", "Pedro", "Gabriel", "Rafael"], [
      True,
      False,
      True,
      False,
    ]),
    Ok(["Matheus", "Gabriel"]),
  )
  check.eq(
    seleciona_nomes(["Matheus", "Pedro", "Gabriel", "Rafael"], [
      False,
      True,
      False,
      True,
    ]),
    Ok(["Pedro", "Rafael"]),
  )
  check.eq(
    seleciona_nomes(["Matheus", "Pedro", "Gabriel", "Rafael"], [
      False,
      False,
      False,
      False,
    ]),
    Ok([]),
  )
}

/// Verifica se *lsta* e *lstb* são iguais. Devolve True, caso sejam
/// e False, caso contrário.
pub fn compara_listas(lsta: List(a), lstb: List(a)) -> Bool {
  case lsta, lstb {
    [], [] -> True
    [primeiroa, ..restoa], [primeirob, ..restob] ->
      primeiroa == primeirob && compara_listas(restoa, restob)
    _, _ -> False
  }
}

pub fn compara_listas_examples() {
  check.eq(compara_listas([], []), True)
  check.eq(compara_listas([5], []), False)
  check.eq(compara_listas(["Matheus"], ["Matheus"]), True)
  check.eq(compara_listas(["Matheus", "Pedro"], ["Matheus"]), False)
  check.eq(compara_listas(["Matheus"], ["Matheus", "Pedro"]), False)
  check.eq(compara_listas([3, 5, 7, 8, 9], [5, 3, 7, 8, 9]), False)
  check.eq(compara_listas([3, 5, 7, 8, 9], [3, 5, 7, 8, 9]), True)
}

/// Verifica se *lsta* possui mais elementos que *lstb*.
/// Devolve False, caso *lstb* tenha quantidade igual ou superior de elementos que *lsta*.
/// Devolve True, caso contrário.
pub fn compara_tamanho_listas(lsta: List(a), lstb: List(a)) -> Bool {
  case lsta, lstb {
    [], _ -> False
    [_, ..], [] -> True
    [_, ..restoa], [_, ..restob] -> compara_tamanho_listas(restoa, restob)
  }
}

pub fn compara_tamanho_listas_examples() {
  check.eq(compara_tamanho_listas([], []), False)
  check.eq(compara_tamanho_listas([5], []), True)
  check.eq(compara_tamanho_listas([], ["Oi"]), False)
  check.eq(compara_tamanho_listas([5], [8]), False)
  check.eq(compara_tamanho_listas([5, 6], [8]), True)
  check.eq(compara_tamanho_listas([5, 6], [8, 1]), False)
  check.eq(compara_tamanho_listas([5, 6, 2, 9], [8]), True)
}

/// Cria uma lista com os *n* primeiros elementos de *lst*.
/// Se *n* for maior que a quantidade de elementos de *lst*, devolve *lst*.
/// Se *n* for zero, devolve uma lista vazia.
/// Se *n* for negativo, devolve Error(Nil).
pub fn mantem(lst: List(a), n: Int) -> Result(List(a), Nil) {
  case lst, n {
    [], _ if n >= 0 -> Ok([])
    [_, ..], 0 -> Ok([])
    [primeiro, ..resto], _ if n > 0 ->
      case mantem(resto, n - 1) {
        Ok(lista_anterior) -> Ok([primeiro, ..lista_anterior])
        _ -> Error(Nil)
      }
    _, _ -> Error(Nil)
  }
}

pub fn mantem_examples() {
  check.eq(mantem([], 0), Ok([]))
  check.eq(mantem([], 3), Ok([]))
  check.eq(mantem([5, 2], 0), Ok([]))
  check.eq(mantem([5, 2], 10), Ok([5, 2]))
  check.eq(mantem([4, 8, 6, 1, 9], 2), Ok([4, 8]))
  check.eq(mantem([4, 8, 6, 1, 9], 4), Ok([4, 8, 6, 1]))
  check.eq(mantem([4, 8, 6, 1, 9], 10), Ok([4, 8, 6, 1, 9]))
  check.eq(mantem([], -5), Error(Nil))
  check.eq(mantem([4, 8, 6, 1, 9], -1), Error(Nil))
}

/// Cria uma nova lista, descartando os *n* primeiros elementos de *lst*.
/// Se *n* for maior ou igual que a quantidade de elementos de *lst*, devolve lista vazia.
/// Se *n* for zero, devolve *lst*.
/// Se *n* for negativo, devolve Error(Nil).
pub fn descarta(lst: List(a), n: Int) -> Result(List(a), Nil) {
  case lst, n {
    [], _ if n >= 0 -> Ok([])
    [primeiro, ..resto], 0 -> Ok([primeiro, ..resto])
    [_, ..resto], _ if n > 0 ->
      case descarta(resto, n - 1) {
        Ok(lista_anterior) -> Ok(lista_anterior)
        _ -> Error(Nil)
      }
    _, _ -> Error(Nil)
  }
}

pub fn descarta_examples() {
  check.eq(descarta([], 0), Ok([]))
  check.eq(descarta([], 3), Ok([]))
  check.eq(descarta([1], 0), Ok([1]))
  check.eq(descarta([4, 5], 1), Ok([5]))
  check.eq(descarta([4, 5], 2), Ok([]))
  check.eq(descarta([4, 5], 3), Ok([]))
  check.eq(descarta([10, 40, 70, 20, 3], 2), Ok([70, 20, 3]))
  check.eq(descarta([10, 40, 70, 20, 3], 3), Ok([20, 3]))
  check.eq(descarta([], -2), Error(Nil))
  check.eq(descarta([10, 40, 70, 20, 3], -1), Error(Nil))
}

/// Remove o elemento de posição *n* em *lst* e devolve a lista atualizada.
/// Se *n* não for uma posição válida, devolve Error(Nil).
/// Em *lst*, o primeiro elemento tem posição igual a zero.
pub fn remove_em(lst: List(a), n: Int) -> Result(List(a), Nil) {
  case lst, n {
    [], _ if n >= 0 -> Error(Nil)
    [_, ..resto], 0 -> Ok(resto)
    [primeiro, ..resto], _ if n > 0 ->
      case remove_em(resto, n - 1) {
        Ok(lista_anterior) -> Ok([primeiro, ..lista_anterior])
        Error(Nil) -> Error(Nil)
      }
    _, _ -> Error(Nil)
  }
}

pub fn remove_em_examples() {
  check.eq(remove_em([], 0), Error(Nil))
  check.eq(remove_em([], 2), Error(Nil))
  check.eq(remove_em([1], 0), Ok([]))
  check.eq(remove_em([1], 1), Error(Nil))
  check.eq(remove_em([1], -1), Error(Nil))
  check.eq(remove_em([1, 5], 1), Ok([1]))
  check.eq(remove_em([1, 4, 8, 9, 6], 3), Ok([1, 4, 8, 6]))
  check.eq(remove_em([1, 4, 8, 9, 6], 1), Ok([1, 8, 9, 6]))
  check.eq(remove_em([1, 4, 8, 9, 6], 5), Error(Nil))
}

/// Insere *v* na posição *n* em *lst* e devolve a lista atualizada.
/// Se *n* não for uma posição válida, devolve Error(Nil).
/// Em *lst*, o primeiro elemento tem posição igual a zero.
pub fn insere_em(lst: List(a), v: a, n: Int) -> Result(List(a), Nil) {
  case lst, n {
    [], 0 -> Ok([v])
    [primeiro, ..resto], 0 -> Ok([v, primeiro, ..resto])
    [primeiro, ..resto], _ if n > 0 ->
      case insere_em(resto, v, n - 1) {
        Ok(anterior) -> Ok([primeiro, ..anterior])
        _ -> Error(Nil)
      }
    _, _ -> Error(Nil)
  }
}

pub fn insere_em_examples() {
  check.eq(insere_em([], 5, 0), Ok([5]))
  check.eq(insere_em([], 5, 2), Error(Nil))
  check.eq(insere_em([], 5, -3), Error(Nil))
  check.eq(insere_em([5], 2, 0), Ok([2, 5]))
  check.eq(insere_em([5], 2, 1), Ok([5, 2]))
  check.eq(insere_em([5], 2, 2), Error(Nil))
  check.eq(insere_em([4, 8, 7, 2], 1, 0), Ok([1, 4, 8, 7, 2]))
  check.eq(insere_em([4, 8, 7, 2], 1, 1), Ok([4, 1, 8, 7, 2]))
  check.eq(insere_em([4, 8, 7, 2], 1, 2), Ok([4, 8, 1, 7, 2]))
  check.eq(insere_em([4, 8, 7, 2], 1, 3), Ok([4, 8, 7, 1, 2]))
  check.eq(insere_em([4, 8, 7, 2], 1, 4), Ok([4, 8, 7, 2, 1]))
  check.eq(insere_em([4, 8, 7, 2], 1, 5), Error(Nil))
  check.eq(insere_em([4, 8, 7, 2], 1, -2), Error(Nil))
}

/// Representa um livro com um nome, um código de identificação, um autor e a editora responsável.
pub type Livro {
  Livro(nome: String, codigo: Int, autor: String, editora: String)
}

/// Devolve a quantidade de livros pertencentes a *lsta* e *lstb*.
pub fn conta_livros_iguais(lsta: List(Livro), lstb: List(Livro)) -> Int {
  case lsta {
    [] -> 0
    [primeiro, ..resto] ->
      case contem(lstb, primeiro) {
        True -> 1 + conta_livros_iguais(resto, lstb)
        False -> conta_livros_iguais(resto, lstb)
      }
  }
}

pub fn conta_livros_iguais_examples() {
  let livro1 =
    Livro("O Pequeno Príncipe", 1, "Antoine de Saint-Exupéry", "Agir")
  let livro2 = Livro("Dom Casmurro", 2, "Machado de Assis", "Principis")
  let livro3 = Livro("Clean Code", 3, "Robert C. Martin", "Prentice Hall")
  let livro4 =
    Livro("Harry Potter e a Pedra Filosofal", 4, "J.K. Rowling", "Rocco")
  let livro5 =
    Livro("A Revolução dos Bichos", 5, "George Orwell", "Companhia das Letras")
  let livro6 = Livro("O Hobbit", 6, "J.R.R. Tolkien", "HarperCollins")

  check.eq(conta_livros_iguais([], []), 0)
  check.eq(conta_livros_iguais([livro1], []), 0)
  check.eq(conta_livros_iguais([], [livro2]), 0)
  check.eq(conta_livros_iguais([livro3], [livro3]), 1)
  check.eq(conta_livros_iguais([livro1], [livro4]), 0)
  check.eq(
    conta_livros_iguais([livro1, livro2, livro3], [livro1, livro2, livro3]),
    3,
  )
  check.eq(
    conta_livros_iguais([livro3, livro1, livro2], [livro2, livro1, livro3]),
    3,
  )
  check.eq(
    conta_livros_iguais([livro1, livro4, livro5, livro6], [
      livro2,
      livro5,
      livro6,
    ]),
    2,
  )
  check.eq(conta_livros_iguais([livro3, livro4], [livro1, livro2, livro5]), 0)
  check.eq(
    conta_livros_iguais([livro1, livro5, livro2], [livro4, livro1, livro5]),
    2,
  )
  check.eq(
    conta_livros_iguais([livro6, livro2, livro5, livro3, livro1], [
      livro3,
      livro5,
      livro2,
      livro1,
      livro6,
    ]),
    5,
  )
}

/// Representa as possibilidades de resposta de uma questão de múltipla escolha com 5 opções cada.
pub type Resposta {
  Opcao1
  Opcao2
  Opcao3
  Opcao4
  Opcao5
}

/// Determina a quantidade de acertos de *respostas* com base em *gabarito*, considerando que
/// posições equivalentes em *respostas* e *gabarito* correspondem a mesma questão.
/// Devolve Error(Nil), caso *respostas* e *gabarito* possuam quantidades diferentes de elementos. 
pub fn compara_gabarito(
  respostas: List(Resposta),
  gabarito: List(Resposta),
) -> Result(Int, Nil) {
  case respostas, gabarito {
    [], [] -> Ok(0)
    [primeira_resposta, ..resto_respostas],
      [primeira_gabarito, ..resto_gabarito]
    ->
      case compara_gabarito(resto_respostas, resto_gabarito) {
        Ok(total) if primeira_resposta == primeira_gabarito -> Ok(total + 1)
        Ok(total) -> Ok(total)
        _ -> Error(Nil)
      }
    _, _ -> Error(Nil)
  }
}

pub fn compara_gabarito_examples() {
  check.eq(compara_gabarito([], []), Ok(0))
  check.eq(compara_gabarito([], [Opcao1, Opcao2, Opcao3]), Error(Nil))
  check.eq(compara_gabarito([Opcao1, Opcao2, Opcao3], []), Error(Nil))
  check.eq(compara_gabarito([Opcao5], [Opcao5]), Ok(1))
  check.eq(compara_gabarito([Opcao4], [Opcao3]), Ok(0))
  check.eq(compara_gabarito([Opcao5, Opcao2], [Opcao2, Opcao5]), Ok(0))
  check.eq(
    compara_gabarito([Opcao1, Opcao1, Opcao1, Opcao1, Opcao1], [
      Opcao1,
      Opcao2,
      Opcao3,
      Opcao4,
      Opcao5,
    ]),
    Ok(1),
  )
  check.eq(
    compara_gabarito([Opcao5, Opcao4, Opcao3, Opcao2, Opcao1], [
      Opcao1,
      Opcao2,
      Opcao3,
      Opcao4,
      Opcao5,
    ]),
    Ok(1),
  )
  check.eq(
    compara_gabarito([Opcao2, Opcao2, Opcao3, Opcao4, Opcao5], [
      Opcao1,
      Opcao2,
      Opcao3,
      Opcao4,
      Opcao5,
    ]),
    Ok(4),
  )
  check.eq(
    compara_gabarito([Opcao4, Opcao3, Opcao1, Opcao2, Opcao5], [
      Opcao4,
      Opcao5,
      Opcao1,
      Opcao3,
      Opcao2,
    ]),
    Ok(2),
  )
  check.eq(
    compara_gabarito([Opcao3, Opcao1, Opcao2, Opcao5], [
      Opcao4,
      Opcao5,
      Opcao1,
      Opcao3,
      Opcao2,
    ]),
    Error(Nil),
  )
  check.eq(
    compara_gabarito([Opcao4, Opcao3, Opcao1, Opcao2, Opcao5], [
      Opcao5,
      Opcao1,
      Opcao3,
      Opcao2,
    ]),
    Error(Nil),
  )
}

pub type Tarefa {
  Tarefa(descricao: String, prioridade: Int)
}

/// Junta as tarefas de *lsta* e *lstb*. O resultado é uma lista em ordem não
/// decrescente de prioridades com os elementos de *lsta* e *lstb*.
/// Requer que *lsta* e *lstb* estejam em ordem não decrescente, caso contrário
/// o resultado é indefinido.
pub fn junta_tarefas(lsta: List(Tarefa), lstb: List(Tarefa)) -> List(Tarefa) {
  case lsta, lstb {
    [], _ -> lstb
    _, [] -> lsta
    [primeiroa, ..restoa], [primeirob, ..]
      if primeiroa.prioridade >= primeirob.prioridade
    -> [primeiroa, ..junta_tarefas(restoa, lstb)]
    _, [primeirob, ..restob] -> [primeirob, ..junta_tarefas(lsta, restob)]
  }
}

pub fn junta_tarefas_examples() {
  let lsta = [
    Tarefa("Comprar comida", 10),
    Tarefa("Limpar a casa", 3),
    Tarefa("Jogar Haxball", -2),
  ]

  let lstb = [
    Tarefa("Trabalho de PF", 8),
    Tarefa("Revisar IHC", 4),
    Tarefa("Caixa de emails", 4),
    Tarefa("Comprar tiquetes", 0),
  ]

  let lstc = [
    Tarefa("Trabalho de BDI", 11),
    Tarefa("Carregar o celular", 5),
    Tarefa("Jogar futebol", 3),
    Tarefa("Ler livro", 0),
    Tarefa("Ir no curso", -5),
  ]

  check.eq(junta_tarefas([], []), [])
  check.eq(junta_tarefas([], lstb), lstb)
  check.eq(junta_tarefas(lsta, []), lsta)
  check.eq(junta_tarefas(lsta, lstb), [
    Tarefa("Comprar comida", 10),
    Tarefa("Trabalho de PF", 8),
    Tarefa("Revisar IHC", 4),
    Tarefa("Caixa de emails", 4),
    Tarefa("Limpar a casa", 3),
    Tarefa("Comprar tiquetes", 0),
    Tarefa("Jogar Haxball", -2),
  ])
  check.eq(junta_tarefas(lstb, lsta), [
    Tarefa("Comprar comida", 10),
    Tarefa("Trabalho de PF", 8),
    Tarefa("Revisar IHC", 4),
    Tarefa("Caixa de emails", 4),
    Tarefa("Limpar a casa", 3),
    Tarefa("Comprar tiquetes", 0),
    Tarefa("Jogar Haxball", -2),
  ])
  check.eq(junta_tarefas(lsta, lstc), [
    Tarefa("Trabalho de BDI", 11),
    Tarefa("Comprar comida", 10),
    Tarefa("Carregar o celular", 5),
    Tarefa("Limpar a casa", 3),
    Tarefa("Jogar futebol", 3),
    Tarefa("Ler livro", 0),
    Tarefa("Jogar Haxball", -2),
    Tarefa("Ir no curso", -5),
  ])
}
