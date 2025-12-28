import gleam/int
import sgleam/fill
import sgleam/image
import sgleam/stroke
import sgleam/world

const lado_quadrado2 = 150
const tamanho_estrela = 20

pub fn cena_estrela(tick: Int) -> image.Image {
  let posicao: Int = tick % { lado_quadrado2 * 4 }
  let fase: Int = posicao / lado_quadrado2
  let deslocamento: Int = posicao % lado_quadrado2

  let coordenada_x: Int = case fase {
    0 -> deslocamento
    1 -> lado_quadrado2
    2 -> lado_quadrado2 - deslocamento
    3 | _ -> 0
  }

  let coordenada_y: Int = case fase {
    0 -> 0
    1 -> deslocamento
    2 -> lado_quadrado2
    3 | _ -> lado_quadrado2 - deslocamento
  }

  let minimo: Int = tamanho_estrela
  let maximo: Int = lado_quadrado2 - tamanho_estrela
  let x: Int = int.clamp(coordenada_x, minimo, maximo)
  let y: Int = int.clamp(coordenada_y, minimo, maximo)

  image.square(lado_quadrado2, stroke.black)
  |> image.place_image(x, y, image.star(tamanho_estrela, fill.red))
}

pub fn main() {
  world.animate(cena_estrela)
}
