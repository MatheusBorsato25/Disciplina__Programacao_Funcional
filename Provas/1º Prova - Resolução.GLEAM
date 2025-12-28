import gleam/int
import gleam/string
import sgleam/check

/// Exercício 1:
/// Constantes para os valores das taxas:
const taxa_atleta_equipe_masculina: Float = 50.0

const taxa_atleta_equipe_feminina: Float = 40.0

const taxa_atleta_masculino_equipe_mista: Float = 35.0

const taxa_atleta_feminino_equipe_mista: Float = 30.0

/// Representa uma inscrição para um evento esportivo.
pub type Inscricao {
  // Inscrição de uma equipe masculina com a sua *quantidade_atletas*, que deve ser positiva.
  Masculina(quantidade_atletas: Int)
  // Inscrição de uma equipe feminina com a sua *quantidade_atletas*, que deve ser positiva.
  Feminina(quantidade_atletas: Int)
  // Inscrição de uma equipe mista com a sua *quantidade_atletas_masculino* e *quantidade_atletas_feminino*,
  // que devem ser positivas.
  Mista(quantidade_atletas_masculino: Int, quantidade_atletas_feminino: Int)
}

/// Calcula o custo de *inscricao* de uma equipe.
/// Se *inscricao* for Masculina, ou seja, de uma equipe masculina,
/// a taxa é de R$ 50 por atleta da equipe.
/// Se *inscricao* for Feminina, ou seja, de uma equipe feminina,
/// a taxa é de R$ 40 por atleta da equipe.
/// Se *inscricao* for Mista, ou seja, de uma equipe mista,
/// a taxa é de R$ 35 por atleta masculino e R$ 30 por atleta feminino.
pub fn custo_inscricao(inscricao: Inscricao) -> Float {
  case inscricao {
    Masculina(quantidade_atletas) ->
      int.to_float(quantidade_atletas) *. taxa_atleta_equipe_masculina
    Feminina(quantidade_atletas) ->
      int.to_float(quantidade_atletas) *. taxa_atleta_equipe_feminina
    Mista(quantidade_atletas_masculino, quantidade_atletas_feminino) ->
      int.to_float(quantidade_atletas_masculino)
      *. taxa_atleta_masculino_equipe_mista
      +. int.to_float(quantidade_atletas_feminino)
      *. taxa_atleta_feminino_equipe_mista
  }
}

pub fn custo_inscricao_examples() {
  check.eq(custo_inscricao(Masculina(5)), 250.0)
  check.eq(custo_inscricao(Masculina(9)), 450.0)
  check.eq(custo_inscricao(Feminina(8)), 320.0)
  check.eq(custo_inscricao(Feminina(3)), 120.0)
  check.eq(custo_inscricao(Mista(6, 2)), 270.0)
  check.eq(custo_inscricao(Mista(3, 7)), 315.0)
}

/// Exercício 2:
/// Devolve o caracter do meio (posição central) de *palavra*.
/// Se *palavra* não tiver um caracter na posição do meio, devolve Error(Nil).
pub fn caracter_meio(palavra: String) -> Result(String, Nil) {
  let tamanho = string.length(palavra)
  case tamanho % 2 == 0 {
    True -> Error(Nil)
    False -> Ok(string.slice(palavra, tamanho / 2, 1))
  }
}

pub fn caracter_meio_examples() {
  check.eq(caracter_meio(""), Error(Nil))
  check.eq(caracter_meio("Oi"), Error(Nil))
  check.eq(caracter_meio("Hoje"), Error(Nil))
  check.eq(caracter_meio("Prova"), Ok("o"))
  check.eq(caracter_meio("Funcional"), Ok("i"))
  check.eq(caracter_meio("Bom-dia"), Ok("-"))
}

/// Conta a quantidade de strings de *lst* com o caracter
/// "-" na posição do meio.
pub fn conta_caracter(lst: List(String)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] ->
      case caracter_meio(primeiro) {
        Ok(caracter) if caracter == "-" -> 1 + conta_caracter(resto)
        _ -> conta_caracter(resto)
      }
  }
}

pub fn conta_caracter_examples() {
  check.eq(conta_caracter([]), 0)
  check.eq(conta_caracter([""]), 0)
  check.eq(conta_caracter(["Hoje"]), 0)
  check.eq(conta_caracter(["Boa-tarde"]), 0)
  check.eq(conta_caracter(["Bom-dia", "Boa-tarde"]), 1)
  check.eq(conta_caracter(["Boa-tarde", "Bom-dia"]), 1)
  check.eq(conta_caracter(["Paradigma-Funcional", "Oi oi", "Nuvem-cinza"]), 2)
  check.eq(
    conta_caracter([
      "Oi-oi", "Ola-oi", "Mouse-mouse", "A-caixa", "Esconde-esconde",
    ]),
    3,
  )
}

/// Exercício 3:
/// Remove as repetições de elementos iguais consecutivos de *lst*,
/// que é uma lista com valores de qualquer tipo.
pub fn remove_repeticoes_consecutivas(lst: List(a)) -> List(a) {
  case lst {
    [] -> []
    [primeiro] -> [primeiro]
    [primeiro, segundo, ..resto] if primeiro != segundo -> [
      primeiro,
      ..remove_repeticoes_consecutivas([segundo, ..resto])
    ]
    [_, ..resto] -> remove_repeticoes_consecutivas(resto)
  }
}

pub fn remove_repeticoes_consecutivas_examples() {
  check.eq(remove_repeticoes_consecutivas([]), [])
  check.eq(remove_repeticoes_consecutivas([1]), [1])
  check.eq(remove_repeticoes_consecutivas([1, 2]), [1, 2])
  check.eq(remove_repeticoes_consecutivas([3, 3]), [3])
  check.eq(remove_repeticoes_consecutivas([3, 3, 1]), [3, 1])
  check.eq(remove_repeticoes_consecutivas([3, 1, 1]), [3, 1])
  check.eq(remove_repeticoes_consecutivas([1, 2, 2, 1, 4, 4, 4]), [1, 2, 1, 4])
  check.eq(remove_repeticoes_consecutivas([5, 5, 5, 5, 5, 5, 5]), [5])
  check.eq(remove_repeticoes_consecutivas([1, 2, 3, 4, 5, 6, 7]), [
    1, 2, 3, 4, 5, 6, 7,
  ])
  check.eq(
    remove_repeticoes_consecutivas(["oi", "oi", "bom", "dia", "dia", "oi"]),
    ["oi", "bom", "dia", "oi"],
  )
  check.eq(remove_repeticoes_consecutivas([True, True, False, False, True]), [
    True,
    False,
    True,
  ])
}
