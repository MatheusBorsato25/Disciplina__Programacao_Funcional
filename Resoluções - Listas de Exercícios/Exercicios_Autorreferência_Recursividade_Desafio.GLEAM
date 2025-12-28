import gleam/io
import gleam/list
import sgleam/check

/// Representa uma entrada em um sistema de arquivos.
/// Cada entrada pode ser:
/// - Arq(nome): um arquivo com seu nome.
/// - Dir(nome, entradas): um diretório identificado por um nome e contendo uma lista de outras entradas.
pub type Entrada {
  Arq(nome: String)
  Dir(nome: String, entradas: List(Entrada))
}

/// Gera a representação hierárquica de *ent*, uma entrada em um sistema de arquivos.
pub fn mostra_representacao(ent: Entrada) -> List(String) {
  case ent {
    Arq(nome) -> ["+- " <> nome]
    Dir(nome, entradas) -> [
      "+- " <> nome <> "/",
      ..adiciona_prefixo(mostra_representacao_lista(entradas))
    ]
  }
}

pub fn mostra_representacao_examples() {
  let ent =
    Dir("disciplinas", [
      Dir("12026", [
        Arq("alunos.txt"),
        Dir("trabs", [
          Arq("trab1.md"),
          Dir("correcoes", [Arq("rascunho.txt"), Arq("final.txt")]),
          Arq("trab2.md"),
        ]),
      ]),
      Dir("6879", []),
      Dir("6884", []),
      Arq("anotacoes.txt"),
    ])
  check.eq(mostra_representacao(ent), [
    "+- disciplinas/", "|  +- 12026/", "|  |  +- alunos.txt", "|  |  +- trabs/",
    "|  |  |  +- trab1.md", "|  |  |  +- correcoes/",
    "|  |  |  |  +- rascunho.txt", "|  |  |  |  +- final.txt",
    "|  |  |  +- trab2.md", "|  +- 6879/", "|  +- 6884/", "|  +- anotacoes.txt",
  ])
  check.eq(mostra_representacao(Arq("dados.txt")), ["+- dados.txt"])
  check.eq(mostra_representacao(Dir("pasta", [])), ["+- pasta/"])
  check.eq(mostra_representacao(Dir("pasta", [Arq("dados.txt")])), [
    "+- pasta/", "|  +- dados.txt",
  ])
}

/// Gera uma lista, concatenando a representação de todas as entradas em *lst*.
pub fn mostra_representacao_lista(lst: List(Entrada)) -> List(String) {
  case lst {
    [] -> []
    [primeiro, ..resto] ->
      list.append(
        mostra_representacao(primeiro),
        mostra_representacao_lista(resto),
      )
  }
}

pub fn mostra_representacao_lista_examples() {
  check.eq(mostra_representacao_lista([]), [])
  check.eq(mostra_representacao_lista([Arq("a.txt"), Arq("b.txt")]), [
    "+- a.txt", "+- b.txt",
  ])
  let entradas = [
    Arq("a.txt"),
    Dir("docs", [Arq("readme.md"), Arq("info.txt")]),
    Arq("b.txt"),
  ]
  check.eq(mostra_representacao_lista(entradas), [
    "+- a.txt", "+- docs/", "|  +- readme.md", "|  +- info.txt", "+- b.txt",
  ])
}

/// Adiciona o prefixo "|  " em todos os elementos de *lst*.
pub fn adiciona_prefixo(lst: List(String)) -> List(String) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> ["|  " <> primeiro, ..adiciona_prefixo(resto)]
  }
}

pub fn adiciona_prefixo_examples() {
  check.eq(adiciona_prefixo([]), [])
  check.eq(adiciona_prefixo(["+- a.txt", "+- b.txt"]), [
    "|  +- a.txt", "|  +- b.txt",
  ])
}

/// Concatena todos os elementos de *lst* em uma única string,
/// separando-os por *separador*.
pub fn converte_string(lst: List(String), separador: String) -> String {
  case lst {
    [] -> ""
    [primeiro] -> primeiro
    [primeiro, ..resto] ->
      primeiro <> separador <> converte_string(resto, separador)
  }
}

pub fn converte_string_examples() {
  check.eq(converte_string([], "."), "")
  check.eq(converte_string(["Maringá"], ","), "Maringá")
  check.eq(converte_string(["oi", "tchau"], "\n"), "oi\ntchau")
  check.eq(converte_string(["a", "b", "c"], ", "), "a, b, c")
}

/// Cria uma representação textual de *ent* e imprime ela completa na tela.
pub fn main() {
  let ent =
    Dir("disciplinas", [
      Dir("12026", [
        Arq("alunos.txt"),
        Dir("trabs", [
          Arq("trab1.md"),
          Dir("correcoes", [Arq("rascunho.txt"), Arq("final.txt")]),
          Arq("trab2.md"),
        ]),
      ]),
      Dir("6879", []),
      Dir("6884", []),
      Dir("12027", [
        Dir("provas", [
          Dir("primeiro_semestre", [
            Arq("p1.docx"),
            Arq("p2.docx"),
            Arq("p3.docx"),
          ]),
          Arq("resultados.xlsx"),
          Arq("analise.txt"),
        ]),
        Dir("trabs", [Arq("especificacao.txt")]),
        Arq("teste.txt"),
        Dir("seminarios", []),
      ]),
      Arq("anotacoes.txt"),
    ])
  let lista_strings: List(String) = mostra_representacao(ent)
  let string_unica: String = converte_string(lista_strings, "\n")
  io.println(string_unica)
}
