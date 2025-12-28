import gleam/int
import sgleam/fill
import sgleam/image
import sgleam/stroke
import sgleam/style
import sgleam/world
import sgleam/xplace
import sgleam/yplace

const cont_inicial = 0
const largura_contador = 300
const altura_contador = 100

pub type Contador {
  Contador(numero: Int, cor: Cor)
}

pub type Cor {
  Vermelho
  Amarelo
  Verde
}

pub fn desenha_contador(cont: Contador) -> image.Image {
  let texto_numero: image.Image =
    image.text(
      int.to_string(cont.numero),
      80,
      style.join([stroke.black, stroke.width(3), fill.gray]),
    )

  let fundo = case cont.cor {
    Vermelho -> fill.red
    Amarelo -> fill.yellow
    Verde -> fill.green
  }

  texto_numero
  |> image.overlay_align(
    xplace.Center,
    yplace.Middle,
    image.rectangle(
      largura_contador,
      altura_contador,
      style.join([stroke.black, fundo, fill.opacityf(0.25)]),
    ),
  )
}

pub fn muda_contador(cont: Contador, tecla: world.Key) -> Contador {
  case tecla {
    world.Char("+") -> Contador(..cont, numero: cont.numero + 1)
    world.Char("-") -> Contador(..cont, numero: cont.numero - 1)
    _ -> cont
  }
}

pub fn muda_cor(cont: Contador) -> Contador {
  let cor = case cont.numero > 0 {
    True -> Verde
    False ->
      case cont.numero < 0 {
        True -> Vermelho
        False -> Amarelo
      }
  }
  Contador(..cont, cor: cor)
}

pub fn main() {
  world.create(Contador(cont_inicial, Amarelo), desenha_contador)
  |> world.on_key_down(muda_contador)
  |> world.on_tick(muda_cor)
  |> world.run()
}
