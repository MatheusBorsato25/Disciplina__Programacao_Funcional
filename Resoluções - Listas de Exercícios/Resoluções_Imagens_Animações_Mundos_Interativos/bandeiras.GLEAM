import sgleam/fill
import sgleam/image
import sgleam/stroke
import sgleam/style
import sgleam/xplace
import sgleam/yplace

pub fn desenha_bandeira_japao() -> image.Image {
  let bandeira =
    image.circle(20, fill.red)
    |> image.overlay(image.rectangle(
      100,
      60,
      style.join([stroke.black, fill.white]),
    ))
  image.empty_scene(100, 60) |> image.overlay(bandeira)
}

pub fn desenha_bandeira_italia() -> image.Image {
  let bandeira =
    image.rectangle(33, 60, fill.green)
    |> image.beside(image.rectangle(33, 60, fill.white))
    |> image.beside(image.rectangle(33, 60, fill.red))

  image.empty_scene(100, 60) |> image.overlay(bandeira)
}

pub fn desenha_bandeira_alemanha() -> image.Image {
  let bandeira =
    image.rectangle(100, 20, fill.black)
    |> image.above(image.rectangle(100, 20, fill.red))
    |> image.above(image.rectangle(100, 20, fill.yellow))

  image.empty_scene(100, 60) |> image.overlay(bandeira)
}

pub fn desenha_bandeira_chile() -> image.Image {
  let bandeira =
    image.rectangle(100, 30, fill.white)
    |> image.place_image(15, 15, image.square(30, fill.blue))
    |> image.place_image(15, 15, image.star(10, fill.white))
    |> image.above(image.rectangle(100, 30, fill.red))

  image.empty_scene(100, 60) |> image.overlay(bandeira)
}

pub fn desenha_bandeira_dinamarca() -> image.Image {
  let primeira_tira =
    image.rectangle(100, 60, fill.crimson)
    |> image.place_image(35, 30, image.rectangle(10, 60, fill.white))
  let bandeira =
    image.place_image(
      primeira_tira,
      50,
      30,
      image.rectangle(100, 10, fill.white),
    )

  image.empty_scene(100, 60) |> image.overlay(bandeira)
}

pub fn desenha_bandeira_brasil() -> image.Image {
  let bandeira =
    image.text("ORDEM E PROGRESSO", 7, fill.blue)
    |> image.overlay_align(
      xplace.Center,
      yplace.Middle,
      image.rectangle(80, 10, fill.white),
    )
    |> image.overlay_align(
      xplace.Center,
      yplace.Middle,
      image.circle(40, fill.blue),
    )
    |> image.overlay_align(
      xplace.Center,
      yplace.Middle,
      image.rhombus(110, 120, fill.yellow),
    )
    |> image.overlay_align(
      xplace.Center,
      yplace.Middle,
      image.rectangle(200, 120, fill.forestgreen),
    )
  image.empty_scene(200, 120) |> image.overlay(bandeira)
}

pub fn desenha_bandeiras() -> image.Image {
  let bandeira_japao = desenha_bandeira_japao()
  let bandeira_italia = desenha_bandeira_italia()
  let bandeira_alemanha = desenha_bandeira_alemanha()
  let bandeira_chile = desenha_bandeira_chile()
  let bandeira_dinamarca = desenha_bandeira_dinamarca()
  let bandeira_brasil = desenha_bandeira_brasil()

  bandeira_japao
  |> image.above(bandeira_italia)
  |> image.above(bandeira_alemanha)
  |> image.above(bandeira_chile)
  |> image.above(bandeira_dinamarca)
  |> image.above(bandeira_brasil)
}

pub fn main() {
  desenha_bandeiras()
}
