import gleam/int
import sgleam/fill
import sgleam/image
import sgleam/world
import sgleam/xplace
import sgleam/yplace

const largura2 = 300
const altura2 = 300
const diametro_inicial = 20

pub fn cena_circulo(tick: Int) -> image.Image {
  let novo_tick = { tick % { { altura2 - diametro_inicial } * 2 } } + 1
  let diametro = case novo_tick < { altura2 - diametro_inicial } {
    True -> novo_tick + diametro_inicial
    False -> altura2 - { novo_tick - { altura2 - diametro_inicial } }
  }

  let diametro_float: Float = int.to_float(diametro)

  let circulo =
    image.empty_scene(largura2, altura2)
    |> image.place_image(
      largura2 / 2,
      altura2 / 2,
      image.circlef(diametro_float /. 2.0, fill.blue),
    )

  image.starf(diametro_float /. 2.0, fill.red)
  |> image.overlay_align(xplace.Center, yplace.Middle, circulo)
}

pub fn main() {
  world.animate(cena_circulo)
}
