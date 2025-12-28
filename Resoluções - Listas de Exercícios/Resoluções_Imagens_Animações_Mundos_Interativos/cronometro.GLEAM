import gleam/int
import sgleam/fill
import sgleam/image
import sgleam/stroke
import sgleam/style
import sgleam/world
import sgleam/xplace
import sgleam/yplace

const tempo_inicial = 0
const largura_cronometro = 500
const altura_cronometro = 100

pub type Cronometro {
  Cronometro(tempo: Int, estado: Estado)
}

pub type Estado {
  Normal
  Pausado
  Zerado
  Reiniciado
}

pub fn converte_dois_digitos(n: Int) -> String {
  case n < 10 {
    True -> "0" <> int.to_string(n)
    False -> int.to_string(n)
  }
}

pub fn desenha_cronometro(c: Cronometro) -> image.Image {
  let horas = c.tempo / 3600
  let resto = c.tempo % 3600
  let minutos = resto / 60
  let segundos = resto % 60

  let texto =
    converte_dois_digitos(horas)
    <> ":"
    <> converte_dois_digitos(minutos)
    <> ":"
    <> converte_dois_digitos(segundos)

  let imagem_texto =
    image.text(
      texto,
      60,
      style.join([stroke.black, stroke.width(3), fill.blue]),
    )

  imagem_texto
  |> image.overlay_align(
    xplace.Center,
    yplace.Middle,
    image.rectangle(largura_cronometro, altura_cronometro, stroke.black),
  )
}

pub fn muda_cronometro(c: Cronometro, tecla: world.Key) -> Cronometro {
  case tecla {
    world.Char(" ") ->
      case c.estado {
        Normal -> Cronometro(..c, estado: Pausado)
        Pausado -> Cronometro(..c, estado: Normal)
        _ -> c
      }
    world.Char("0") -> Cronometro(0, estado: Zerado)
    world.Enter -> Cronometro(0, estado: Reiniciado)
    _ -> c
  }
}

pub fn muda_tempo(c: Cronometro) -> Cronometro {
  case c.estado {
    Normal -> Cronometro(..c, tempo: c.tempo + 1)
    Pausado -> c
    Zerado -> c
    Reiniciado -> Cronometro(tempo: c.tempo + 1, estado: Normal)
  }
}

pub fn main() {
  world.create(Cronometro(tempo_inicial, Normal), desenha_cronometro)
  |> world.on_key_down(muda_cronometro)
  |> world.on_tick(muda_tempo)
  |> world.tick_rate(2)
  |> world.run()
}
