// Alunos: Guilherme Jucoski da Silva - ra138642
//         Matheus Henrique Borsato - ra138246

import gleam/int
import gleam/option.{type Option, None, Some}
import sgleam/check
import sgleam/fill
import sgleam/font
import sgleam/image
import sgleam/stroke
import sgleam/style
import sgleam/world
import sgleam/xplace
import sgleam/yplace

/// Definição das constantes:
const estado_inicial: Estado = Abertura

const posicao_inicial_faminto: Posicao = Posicao(5, 5)

const tamanho_tabuleiro: Int = 11

const largura_tabuleiro: Int = 550

const altura_cronometro: Int = 60

const lado_quadrado: Int = 50

const tamanho_frutas: Int = 30

const tamanho_faminto: Int = 40

const tiques_segundo: Int = 60

const cinza1: style.Style = fill.lightslategray

const cinza2: style.Style = fill.ivory

const opacidade_abertura: Float = 0.3

const opacidade_corrida: Float = 1.0

const opacidade_resultado: Float = 0.6

/// Definição dos tipos de dados:
/// Representa as 3 frutas que serão utilizadas no jogo.
pub type Frutas {
  // Representam as posições das 3 frutas dentro do tabuleiro.
  // Elas podem ter ou não uma posição.
  Frutas(pos1: Option(Posicao), pos2: Option(Posicao), pos3: Option(Posicao))
}

/// Representa o personagem do jogo.
pub type Faminto {
  // O personagem associado a sua posição no tabuleiro.
  Faminto(pos: Posicao)
}

/// Representa os estados do jogo.
pub type Estado {
  // Estado inicial do jogo.
  Abertura
  // Estado em que o jogo ocorre, com *frutas* e *faminto* posicionados no tabuleiro
  // e o avanço do *tick* durante o processo.
  Corrida(frutas: Frutas, faminto: Faminto, tick: Int)
  // Estado final do jogo, com o tempo final dado por *tick*. 
  Resultado(tick: Int)
}

/// Represena uma posição dentro do tabuleiro.
pub type Posicao {
  // A posição deve variar entre a quantidade de quadrados do tabuleiro, 
  // começando por 0, tanto na linha, quanto na coluna.
  Posicao(linha: Int, coluna: Int)
}

/// Representa as direções possíveis de movimentação.
pub type Direcao {
  Cima
  Esquerda
  Baixo
  Direita
}

/// Cria uma imagem representando o cenário atual do jogo.
/// Dependendo de *estado*, uma tela diferente é desenhada pela função.
/// Se *estado* for Abertura, desenha a tela inicial do jogo.
/// Se *estado* for Corrida, desenha os elementos do jogo dentro de *tabuleiro*.
/// Se *estado* for Resultado, desenha a tela final do jogo.
pub fn desenha(estado: Estado, tabuleiro: image.Image) -> image.Image {
  let centro: Int = largura_tabuleiro / 2
  case estado {
    Abertura -> {
      let tabuleiro_abertura: image.Image =
        desenha_tabuleiro(
          tamanho_tabuleiro * tamanho_tabuleiro,
          opacidade_abertura,
        )
      let conteudo_abertura: image.Image =
        image.text_font(
          "🍎 SPEED FRUIT 🍇",
          font.Font(size: 50.0, family: "monospace"),
          style.join([fill.maroon, stroke.red]),
        )
        |> image.above(image.text("", 30, fill.white))
        |> image.above(image.text_font(
          "Aperte Enter para começar",
          font.Font(size: 30.0, family: "monospace"),
          style.join([fill.black, stroke.red]),
        ))
      image.place_image(tabuleiro_abertura, centro, centro, conteudo_abertura)
    }

    Corrida(frutas, faminto, tick) -> {
      let base_fruta: image.Image =
        desenha_fruta(tabuleiro, "🍎", frutas.pos1)
        |> desenha_fruta("🍒", frutas.pos2)
        |> desenha_fruta("🍍", frutas.pos3)

      desenha_cronometro(tick)
      |> image.above(
        base_fruta
        |> image.place_image(
          faminto.pos.coluna * lado_quadrado + lado_quadrado / 2,
          faminto.pos.linha * lado_quadrado + lado_quadrado / 2,
          image.text("😀", tamanho_faminto, fill.red),
        ),
      )
    }

    Resultado(tick) -> {
      let tabuleiro_resultado: image.Image =
        desenha_tabuleiro(
          tamanho_tabuleiro * tamanho_tabuleiro,
          opacidade_resultado,
        )

      let conteudo_resultado: image.Image =
        desenha_cronometro_final(tick)
        |> image.above(image.text("", 30, fill.white))
        |> image.above(image.text_font(
          "Aperte Enter para reiniciar",
          font.Font(size: 30.0, family: "monospace"),
          style.join([fill.black, stroke.red]),
        ))

      tabuleiro_resultado
      |> image.place_image(centro, centro, conteudo_resultado)
    }
  }
}

/// Altera *imagem_base*, desenhando *emoji* na posição indicada em *fruta*.
/// Se *fruta* indicar uma posição, o desenho do *emoji* é realizado e a imagem atualizada é devolvida.
/// Se *fruta* não indicar uma posição, *imagem_base* não é alterada.
pub fn desenha_fruta(
  imagem_base: image.Image,
  emoji: String,
  fruta: Option(Posicao),
) -> image.Image {
  case fruta {
    None -> imagem_base
    Some(posicao) ->
      imagem_base
      |> image.place_image(
        posicao.coluna * lado_quadrado + lado_quadrado / 2,
        posicao.linha * lado_quadrado + lado_quadrado / 2,
        image.text(emoji, tamanho_frutas, fill.black),
      )
  }
}

/// Converte um número positivo *n* em uma string com, no mínimo, dois digitos.
/// Se *n* tiver dois ou mais digitos, ele é devolvido como string.
/// Se *n* tiver um digito, é adicionado "0" à sua esquerda.
pub fn converte_dois_digitos(n: Int) -> String {
  case n < 10 {
    True -> "0" <> int.to_string(n)
    False -> int.to_string(n)
  }
}

pub fn converte_dois_digitos_examples() {
  check.eq(converte_dois_digitos(0), "00")
  check.eq(converte_dois_digitos(9), "09")
  check.eq(converte_dois_digitos(10), "10")
  check.eq(converte_dois_digitos(100), "100")
}

/// Desenha a imagem do cronômetro com o tempo final quando o jogo se encerra,
/// convertendo *tiques* para segundos e milissegundos.
pub fn desenha_cronometro_final(tiques: Int) -> image.Image {
  let segundos: Int = tiques / 60
  let milissegundos: Int = { tiques % 60 } * 1000 / 60

  let texto: String =
    "⏳  TEMPO: "
    <> int.to_string(segundos)
    <> "s "
    <> int.to_string(milissegundos)
    <> "ms"

  image.text_font(
    texto,
    font.Font(size: 40.0, family: "monospace"),
    style.join([fill.blue, stroke.darkblue]),
  )
}

/// Desenha a imagem de um cronômetro que será ilustrado durante o jogo, 
/// convertendo *tiques* para minutos, segundos e centésimos de segundo.
pub fn desenha_cronometro(tiques: Int) -> image.Image {
  let minutos: Int = tiques / 3600
  let resto: Int = tiques % 3600
  let segundos: Int = resto / 60
  let centesimos: Int = { resto % 60 } * 100 / 60

  let texto: String =
    "⏳   "
    <> converte_dois_digitos(minutos)
    <> ":"
    <> converte_dois_digitos(segundos)
    <> ":"
    <> converte_dois_digitos(centesimos)

  let imagem_texto: image.Image =
    image.text(
      texto,
      50,
      style.join([stroke.black, stroke.width(3), fill.blue]),
    )

  imagem_texto
  |> image.overlay_align(
    xplace.Center,
    yplace.Middle,
    image.rectangle(
      largura_tabuleiro,
      altura_cronometro,
      style.join([stroke.black, stroke.width(5)]),
    ),
  )
}

/// Gera uma imagem de um tabuleiro quadrado com opacidade *op* dentro de uma imagem vazia, 
/// com *i* quadrados intercalados em duas cores.
/// O tabuleiro é desenhado de cima para baixo, da esquerda para a direita.
pub fn desenha_tabuleiro(i: Int, op: Float) -> image.Image {
  let linha: Int = { i - 1 } / tamanho_tabuleiro
  let coluna: Int = { i - 1 } % tamanho_tabuleiro
  let x: Int = { coluna * lado_quadrado } + lado_quadrado / 2
  let y: Int = { linha * lado_quadrado } + lado_quadrado / 2

  let cor: style.Style = case { linha + coluna } % 2 == 0 {
    True -> cinza1
    False -> cinza2
  }

  case i {
    1 ->
      image.empty_scene(largura_tabuleiro, largura_tabuleiro)
      |> image.place_image(
        x,
        y,
        image.square(lado_quadrado, style.join([cor, fill.opacityf(op)])),
      )
    _ ->
      desenha_tabuleiro(i - 1, op)
      |> image.place_image(
        x,
        y,
        image.square(lado_quadrado, style.join([cor, fill.opacityf(op)])),
      )
  }
}

/// Gera a posição de uma das frutas aleatoriamente para ser posicionada dentro das dimensões do tabuleiro.
/// A posição gerada não pode ser a central, onde o personagem do jogo é posicionado no começo.
pub fn gera_posicao() -> Posicao {
  let linha: Int = int.random(tamanho_tabuleiro)
  let coluna: Int = int.random(tamanho_tabuleiro)
  case linha == 5 && coluna == 5 {
    True -> gera_posicao()
    False -> Posicao(linha, coluna)
  }
}

/// Verifica se as posições *pos1*, *pos2* e *pos3* são diferentes.
/// Caso haja posições iguais, faz o sorteio novamente para uma delas e verifica todas novamente.
/// Caso todas sejam diferentes, retorna as frutas com suas respectivas posições.
pub fn verifica_posicoes(pos1: Posicao, pos2: Posicao, pos3: Posicao) -> Frutas {
  case pos1 == pos2 {
    True -> verifica_posicoes(pos1, gera_posicao(), pos3)
    False ->
      case pos1 == pos3 {
        True -> verifica_posicoes(pos1, pos2, gera_posicao())
        False ->
          case pos2 == pos3 {
            True -> verifica_posicoes(pos1, pos2, gera_posicao())
            False -> Frutas(Some(pos1), Some(pos2), Some(pos3))
          }
      }
  }
}

/// Atualiza *pos* com base em *dir*.
/// Dependendo de *dir*, uma atualização diferente é feita.
/// Se *dir* for Cima, a linha é decrementada em uma unidade.
/// Se estiver na primeira linha, vai para a última linha.
/// Se *dir* for Baixo, a linha é incrementada em uma unidade.
/// Se estiver na última linha, volta para a primeira.
/// Se *dir* for Direita, a coluna é incrementada em uma unidade.
/// Se estiver na última coluna, volta para a primeira.
/// Se *dir* for Esquerda, a coluna é decrementada em uma unidade.
/// Se estiver na primeira coluna, vai para a última coluna.
pub fn posicao_faminto(pos: Posicao, dir: Direcao) -> Posicao {
  case dir {
    Cima ->
      case pos.linha - 1 < 0 {
        True -> Posicao(tamanho_tabuleiro - 1, pos.coluna)
        False -> Posicao(pos.linha - 1, pos.coluna)
      }
    Baixo -> Posicao({ pos.linha + 1 } % tamanho_tabuleiro, pos.coluna)
    Direita -> Posicao(pos.linha, { pos.coluna + 1 } % tamanho_tabuleiro)
    Esquerda ->
      case { pos.coluna - 1 } < 0 {
        True -> Posicao(pos.linha, tamanho_tabuleiro - 1)
        False -> Posicao(pos.linha, pos.coluna - 1)
      }
  }
}

pub fn posicao_faminto_examples() {
  check.eq(posicao_faminto(Posicao(9, 9), Cima), Posicao(8, 9))
  check.eq(posicao_faminto(Posicao(9, 9), Esquerda), Posicao(9, 8))
  check.eq(posicao_faminto(Posicao(9, 9), Baixo), Posicao(10, 9))
  check.eq(posicao_faminto(Posicao(9, 9), Direita), Posicao(9, 10))
  check.eq(posicao_faminto(Posicao(0, 9), Cima), Posicao(10, 9))
  check.eq(posicao_faminto(Posicao(9, 0), Esquerda), Posicao(9, 10))
  check.eq(posicao_faminto(Posicao(10, 9), Baixo), Posicao(0, 9))
  check.eq(posicao_faminto(Posicao(9, 10), Direita), Posicao(9, 0))
}

/// Gera o estado inicial da fase de Corrida, com as frutas posicionadas aleatoriamente,
/// o faminto no centro do tabuleiro e o tick zerado.
pub fn gera_corrida_inicial() -> Estado {
  Corrida(
    verifica_posicoes(gera_posicao(), gera_posicao(), gera_posicao()),
    Faminto(posicao_inicial_faminto),
    0,
  )
}

/// Altera *estado* do personagem, baseado na *tecla* pressionada.
/// Se *estado* for Abertura:
/// - Se *tecla* for Enter`, transiciona o estado para Corrida com:
///   - Três frutas geradas aleatoriamente;
///   - O personagem na posição inicial;
///   - O contador de tick zerado.
/// - Qualquer outra tecla mantém *estado*.
///
/// Se *estado* for Corrida:
/// - Se *tecla* for uma seta direcional:
///   - Move o personagem na direção correspondente:
///     - `ArrowLeft` → esquerda;
///     - `ArrowRight` → direita;
///     - `ArrowUp` → cima;
///     - `ArrowDown` → baixo.
/// - Qualquer outra tecla mantém *estado*.
///
/// Se *estado* for Resultado:`
/// - Se a tecla for `Enter`, reinicia o jogo com:
///   - Novas frutas geradas aleatoriamente;
///   - O personagem na posição inicial;
///   - O contador de tick zerado.
/// - Qualquer outra tecla mantém *estado*.
pub fn move(estado: Estado, tecla: world.Key) -> Estado {
  case estado {
    Abertura ->
      case tecla {
        world.Enter -> gera_corrida_inicial()
        _ -> estado
      }

    Corrida(_, faminto, _) -> {
      let novo_estado: Estado = case tecla {
        world.ArrowLeft ->
          Corrida(
            ..estado,
            faminto: Faminto(posicao_faminto(faminto.pos, Esquerda)),
          )
        world.ArrowRight ->
          Corrida(
            ..estado,
            faminto: Faminto(posicao_faminto(faminto.pos, Direita)),
          )
        world.ArrowUp ->
          Corrida(
            ..estado,
            faminto: Faminto(posicao_faminto(faminto.pos, Cima)),
          )
        world.ArrowDown ->
          Corrida(
            ..estado,
            faminto: Faminto(posicao_faminto(faminto.pos, Baixo)),
          )
        _ -> estado
      }
      atualiza_corrida(novo_estado)
    }
    Resultado(_) ->
      case tecla {
        world.Enter -> gera_corrida_inicial()
        _ -> estado
      }
  }
}

pub fn move_examples() {
  let corrida =
    Corrida(
      Frutas(Some(Posicao(10, 10)), None, None),
      Faminto(Posicao(9, 10)),
      0,
    )
  let corrida2 =
    Corrida(
      Frutas(Some(Posicao(4, 7)), Some(Posicao(1, 6)), None),
      Faminto(Posicao(1, 7)),
      15,
    )
  check.eq(move(Abertura, world.ArrowUp), Abertura)
  check.eq(move(corrida, world.Enter), corrida)
  check.eq(
    move(corrida, world.ArrowLeft),
    Corrida(..corrida, faminto: Faminto(Posicao(9, 9))),
  )
  check.eq(
    move(corrida, world.ArrowUp),
    Corrida(..corrida, faminto: Faminto(Posicao(8, 10))),
  )
  check.eq(move(corrida, world.ArrowDown), Resultado(0))
  check.eq(
    move(corrida, world.ArrowRight),
    Corrida(..corrida, faminto: Faminto(Posicao(9, 0))),
  )
  check.eq(move(corrida2, world.Backspace), corrida2)
  check.eq(
    move(corrida2, world.ArrowLeft),
    Corrida(
      ..corrida2,
      frutas: Frutas(Some(Posicao(4, 7)), None, None),
      faminto: Faminto(Posicao(1, 6)),
    ),
  )
  check.eq(
    move(corrida2, world.ArrowUp),
    Corrida(..corrida2, faminto: Faminto(Posicao(0, 7))),
  )
  check.eq(
    move(corrida2, world.ArrowDown),
    Corrida(..corrida2, faminto: Faminto(Posicao(2, 7))),
  )
  check.eq(
    move(corrida2, world.ArrowRight),
    Corrida(..corrida2, faminto: Faminto(Posicao(1, 8))),
  )
  check.eq(move(Resultado(10), world.ArrowUp), Resultado(10))
}

/// Atualiza *estado*, considerando a possibilidade de remoção de frutas e, na sequência, 
/// a possibilidade de encerramento do jogo.
/// Se as três frutas forem removidas, devolve o estado Resultado. Caso contrário, devolve
/// o novo estado de Corrida.
/// Se *estado* não for Corrida, devolve *estado*.
pub fn atualiza_corrida(estado: Estado) -> Estado {
  case estado {
    Corrida(frutas, faminto, tick) -> {
      let novas_frutas: Frutas = remove_frutas(faminto.pos, frutas)

      case verifica_fim(novas_frutas) {
        True -> Resultado(tick)
        False -> Corrida(novas_frutas, faminto, tick)
      }
    }
    _ -> estado
  }
}

pub fn atualiza_corrida_examples() {
  check.eq(atualiza_corrida(Abertura), Abertura)

  let corrida_exemplo =
    Corrida(
      Frutas(Some(Posicao(10, 10)), Some(Posicao(3, 4)), Some(Posicao(0, 5))),
      Faminto(Posicao(5, 5)),
      0,
    )
  check.eq(atualiza_corrida(corrida_exemplo), corrida_exemplo)

  let corrida_exemplo1 =
    Corrida(
      Frutas(Some(Posicao(10, 10)), Some(Posicao(3, 4)), Some(Posicao(0, 5))),
      Faminto(Posicao(10, 10)),
      0,
    )
  check.eq(
    atualiza_corrida(corrida_exemplo1),
    Corrida(
      ..corrida_exemplo1,
      frutas: Frutas(None, Some(Posicao(3, 4)), Some(Posicao(0, 5))),
    ),
  )

  let corrida_exemplo2 =
    Corrida(
      Frutas(None, Some(Posicao(3, 4)), Some(Posicao(0, 5))),
      Faminto(Posicao(3, 4)),
      0,
    )
  check.eq(
    atualiza_corrida(corrida_exemplo2),
    Corrida(..corrida_exemplo2, frutas: Frutas(None, None, Some(Posicao(0, 5)))),
  )

  let corrida_exemplo3 =
    Corrida(Frutas(None, None, Some(Posicao(0, 5))), Faminto(Posicao(3, 4)), 0)
  check.eq(
    atualiza_corrida(corrida_exemplo3),
    Corrida(..corrida_exemplo3, frutas: Frutas(None, None, Some(Posicao(0, 5)))),
  )

  let corrida_exemplo4 =
    Corrida(
      Frutas(None, None, Some(Posicao(0, 5))),
      Faminto(Posicao(0, 5)),
      450,
    )
  check.eq(atualiza_corrida(corrida_exemplo4), Resultado(450))

  check.eq(atualiza_corrida(Resultado(10)), Resultado(10))
}

/// Verifica se *frutas* apresenta todas as posições nulas. 
/// Devolve True, caso sejam todas nulas.
/// Caso contrário, devolve False.
pub fn verifica_fim(frutas: Frutas) -> Bool {
  frutas.pos1 == None && frutas.pos2 == None && frutas.pos3 == None
}

pub fn verifica_fim_examples() {
  check.eq(
    verifica_fim(Frutas(
      Some(Posicao(10, 10)),
      Some(Posicao(10, 9)),
      Some(Posicao(5, 10)),
    )),
    False,
  )
  check.eq(
    verifica_fim(Frutas(None, Some(Posicao(10, 10)), Some(Posicao(9, 10)))),
    False,
  )
  check.eq(
    verifica_fim(Frutas(Some(Posicao(10, 10)), None, Some(Posicao(10, 5)))),
    False,
  )
  check.eq(
    verifica_fim(Frutas(Some(Posicao(10, 10)), Some(Posicao(10, 10)), None)),
    False,
  )
  check.eq(verifica_fim(Frutas(Some(Posicao(7, 2)), None, None)), False)
  check.eq(verifica_fim(Frutas(None, Some(Posicao(7, 2)), None)), False)
  check.eq(verifica_fim(Frutas(None, None, Some(Posicao(7, 2)))), False)
  check.eq(verifica_fim(Frutas(None, None, None)), True)
}

/// Verifica se alguma das posições de *frutas* é igual a *posicao_faminto*.
/// Caso uma das posições seja igual, anula essa posição.
/// As posições já anuladas ou diferentes de *posicao_faminto* são mantidas.
/// O novo estado das frutas é devolvido.
pub fn remove_frutas(posicao_faminto: Posicao, frutas: Frutas) -> Frutas {
  let posicao_fruta1: Option(Posicao) = case frutas.pos1 {
    Some(pos1) if posicao_faminto == pos1 -> None
    _ -> frutas.pos1
  }

  let posicao_fruta2: Option(Posicao) = case frutas.pos2 {
    Some(pos2) if posicao_faminto == pos2 -> None
    _ -> frutas.pos2
  }

  let posicao_fruta3: Option(Posicao) = case frutas.pos3 {
    Some(pos3) if posicao_faminto == pos3 -> None
    _ -> frutas.pos3
  }

  Frutas(posicao_fruta1, posicao_fruta2, posicao_fruta3)
}

pub fn remove_frutas_examples() {
  let frutas =
    Frutas(Some(Posicao(10, 10)), Some(Posicao(9, 9)), Some(Posicao(8, 8)))
  check.eq(remove_frutas(Posicao(7, 7), frutas), frutas)
  check.eq(
    remove_frutas(Posicao(10, 10), frutas),
    Frutas(None, Some(Posicao(9, 9)), Some(Posicao(8, 8))),
  )
  check.eq(
    remove_frutas(Posicao(9, 9), frutas),
    Frutas(Some(Posicao(10, 10)), None, Some(Posicao(8, 8))),
  )
  check.eq(
    remove_frutas(Posicao(8, 8), frutas),
    Frutas(Some(Posicao(10, 10)), Some(Posicao(9, 9)), None),
  )
  let frutas2 = Frutas(Some(Posicao(10, 10)), Some(Posicao(9, 9)), None)
  check.eq(
    remove_frutas(Posicao(10, 10), frutas2),
    Frutas(None, Some(Posicao(9, 9)), None),
  )
  check.eq(
    remove_frutas(Posicao(9, 9), Frutas(None, Some(Posicao(9, 9)), None)),
    Frutas(None, None, None),
  )
}

/// Atualiza *estado* com base no tempo decorrido.
/// Se *estado* for Abertura ou Resultado, nenhuma alteração é realizada.
/// Se *estado* for Corrida, a quantidade de ticks é incrementada em uma unidade.
pub fn muda_tempo(estado: Estado) -> Estado {
  case estado {
    Corrida(_, _, _) -> Corrida(..estado, tick: estado.tick + 1)
    _ -> estado
  }
}

pub fn muda_tempo_examples() {
  check.eq(muda_tempo(Abertura), Abertura)
  let corrida =
    Corrida(
      Frutas(Some(Posicao(10, 10)), None, None),
      Faminto(Posicao(9, 9)),
      0,
    )
  check.eq(muda_tempo(corrida), Corrida(..corrida, tick: 1))
  let segunda_corrida =
    Corrida(
      Frutas(Some(Posicao(9, 2)), Some(Posicao(5, 4)), Some(Posicao(0, 6))),
      Faminto(Posicao(5, 5)),
      35,
    )
  check.eq(muda_tempo(segunda_corrida), Corrida(..segunda_corrida, tick: 36))
  check.eq(muda_tempo(Resultado(5)), Resultado(5))
}

pub fn main() {
  // Desenha o tabuleiro do jogo durante a fase de Corrida.
  let tabuleiro =
    desenha_tabuleiro(tamanho_tabuleiro * tamanho_tabuleiro, opacidade_corrida)
  world.create(estado_inicial, desenha(_, tabuleiro))
  |> world.on_key_down(move)
  |> world.on_tick(muda_tempo)
  |> world.tick_rate(tiques_segundo)
  |> world.run()
}
