import gleam/int
import sgleam/fill
import sgleam/image
import sgleam/stroke
import sgleam/style
import sgleam/world

const largura = 300
const altura = 100
const lado_quadrado = 30

pub fn cena_quadrado(tick: Int) -> image.Image {
  let novo_tick = tick % { 2 * largura }
  let posicao_x = case novo_tick < largura {
    True -> novo_tick
    False -> 2 * largura - novo_tick
  }
  image.empty_scene(largura, altura)
  |> image.place_image(
    int.min(int.max(posicao_x, lado_quadrado / 2), largura - lado_quadrado / 2),
    altura / 2,
    image.square(
      lado_quadrado,
      style.join([fill.red, stroke.black, fill.opacityf(0.75)]),
    ),
  )
}

pub fn main() {
  world.animate(cena_quadrado)
}
