import gleam/float
import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/string
import sgleam/check

// Os tipos de direções
pub type Direcao {
  Norte
  Sul
  Oeste
  Leste
}

// Devolve a direção oposta de *direcao*. 
pub fn direcao_oposta(direcao: Direcao) -> Direcao {
  case direcao {
    Norte -> Sul
    Sul -> Norte
    Oeste -> Leste
    Leste -> Oeste
  }
}

pub fn direcao_oposta_examples() {
  check.eq(direcao_oposta(Norte), Sul)
  check.eq(direcao_oposta(Sul), Norte)
  check.eq(direcao_oposta(Oeste), Leste)
  check.eq(direcao_oposta(Leste), Oeste)
}

// Devolve a direção que está a 90 graus no sentido horário de *direcao*.
pub fn direcao_noventa_horario(direcao: Direcao) -> Direcao {
  case direcao {
    Norte -> Leste
    Sul -> Oeste
    Oeste -> Norte
    Leste -> Sul
  }
}

pub fn direcao_noventa_horario_examples() {
  check.eq(direcao_noventa_horario(Norte), Leste)
  check.eq(direcao_noventa_horario(Sul), Oeste)
  check.eq(direcao_noventa_horario(Oeste), Norte)
  check.eq(direcao_noventa_horario(Leste), Sul)
}

// Devolve a direção que está a 90 graus no sentido anti-horário de *direcao*.
pub fn direcao_noventa_anti_horario(direcao: Direcao) -> Direcao {
  direcao_noventa_horario(
    direcao_noventa_horario(direcao_noventa_horario(direcao)),
  )
}

pub fn direcao_noventa_anti_horario_examples() {
  check.eq(direcao_noventa_anti_horario(Norte), Oeste)
  check.eq(direcao_noventa_anti_horario(Sul), Leste)
  check.eq(direcao_noventa_anti_horario(Oeste), Sul)
  check.eq(direcao_noventa_anti_horario(Leste), Norte)
}

// Calcula a distância em graus de um movimento, no sentido horário,
// de *direcao_atual* para *direcao_desejada*.
pub fn angulo(direcao_atual: Direcao, direcao_desejada: Direcao) -> Int {
  case direcao_desejada == direcao_oposta(direcao_atual) {
    True -> 180
    False ->
      case direcao_desejada == direcao_noventa_horario(direcao_atual) {
        True -> 90
        False ->
          case direcao_desejada == direcao_noventa_anti_horario(direcao_atual) {
            True -> 270
            False -> 0
          }
      }
  }
}

pub fn angulo_examples() {
  check.eq(angulo(Norte, Norte), 0)
  check.eq(angulo(Norte, Leste), 90)
  check.eq(angulo(Norte, Sul), 180)
  check.eq(angulo(Norte, Oeste), 270)
  check.eq(angulo(Sul, Leste), 270)
  check.eq(angulo(Leste, Oeste), 180)
  check.eq(angulo(Oeste, Norte), 90)
}

/// Possibilidades de situações de um elevador.
pub type SituacaoElevador {
  Parado
  Subindo
  Descendo
}

/// Representa os andares de um elevador.
type Andar =
  Int

/// Devolve a situação atual do elevador, com base no seu *andar_atual* 
/// e o *andar_solicitado* a partir da última solicitação.
pub fn situacao_atual_elevador(
  andar_atual: Andar,
  andar_solicitado: Andar,
) -> SituacaoElevador {
  case andar_atual == andar_solicitado {
    True -> Parado
    False ->
      case andar_atual < andar_solicitado {
        True -> Subindo
        False -> Descendo
      }
  }
}

pub fn situacao_atual_elevador_examples() {
  check.eq(situacao_atual_elevador(3, 3), Parado)
  check.eq(situacao_atual_elevador(2, 8), Subindo)
  check.eq(situacao_atual_elevador(7, 5), Descendo)
}

/// Devolve True se um elevador pode passar diretamente de *situacao_atual* para 
/// *situacao_futura*. O elevador só pode começar a se movimentar se estiver parado.
/// Devolve False, caso contrário.
/// Possibilidades:
///  Atual/Futura |  Parado  |  Subindo  |  Descendo 
///    Parado     |   True   |   True    |    True
///    Subindo    |   True   |   True    |    False
///   Descendo    |   True   |   False   |    True
pub fn mudanca_possivel(
  situacao_atual: SituacaoElevador,
  situacao_futura: SituacaoElevador,
) -> Bool {
  case situacao_atual, situacao_futura {
    Subindo, Descendo -> False
    Descendo, Subindo -> False
    _, _ -> True
  }
}

pub fn mudanca_possivel_examples() {
  check.eq(mudanca_possivel(Parado, Parado), True)
  check.eq(mudanca_possivel(Parado, Subindo), True)
  check.eq(mudanca_possivel(Parado, Descendo), True)
  check.eq(mudanca_possivel(Subindo, Parado), True)
  check.eq(mudanca_possivel(Subindo, Subindo), True)
  check.eq(mudanca_possivel(Subindo, Descendo), False)
  check.eq(mudanca_possivel(Descendo, Parado), True)
  check.eq(mudanca_possivel(Descendo, Subindo), False)
  check.eq(mudanca_possivel(Descendo, Descendo), True)
}

/// Aspectos de uma resolução (razão entre largura e altura)
pub type Aspecto {
  QuatroPorTres
  DezesseisPorNove
  Outro
}

/// A resolução de uma tela ou uma imagem.
pub type Resolucao {
  // As dimensões da resolução de uma tela ou imagem.
  Resolucao(largura: Float, altura: Float)
}

/// Calcula a quantidade de megapixels de uma imagem com resolução *resolucao*.
pub fn resolucao_megapixels(resolucao: Resolucao) -> Float {
  resolucao.altura *. resolucao.largura /. 1_000_000.0
}

pub fn resolucao_megapixels_examples() {
  check.eq(resolucao_megapixels(Resolucao(1200.0, 1500.0)), 1.8)
  check.eq(resolucao_megapixels(Resolucao(2000.0, 2400.0)), 4.8)
}

/// Devolve o aspecto (razão entre largura e altura) de *resolucao*.
pub fn verifica_aspecto(resolucao: Resolucao) -> Aspecto {
  case resolucao.largura *. 3.0 == resolucao.altura *. 4.0 {
    True -> QuatroPorTres
    False ->
      case resolucao.largura *. 9.0 == resolucao.altura *. 16.0 {
        True -> DezesseisPorNove
        False -> Outro
      }
  }
}

pub fn verifica_aspecto_examples() {
  check.eq(verifica_aspecto(Resolucao(1024.0, 768.0)), QuatroPorTres)
  check.eq(verifica_aspecto(Resolucao(1920.0, 1080.0)), DezesseisPorNove)
  check.eq(verifica_aspecto(Resolucao(600.0, 600.0)), Outro)
}

/// Produz True se a imagem com a resolução *i* pode ser exibida na tela com a 
/// resolução *j*, sem a necessidade de rotação ou redução de tamanho.
/// Devolve False, caso contrário.
pub fn imagem_cabe_tela(i: Resolucao, j: Resolucao) -> Bool {
  i.altura <=. j.altura && i.largura <=. j.largura
}

pub fn imagem_cabe_na_tela_examples() {
  check.eq(
    imagem_cabe_tela(Resolucao(300.0, 400.0), Resolucao(330.0, 450.0)),
    True,
  )
  check.eq(
    imagem_cabe_tela(Resolucao(330.0, 450.0), Resolucao(330.0, 450.0)),
    True,
  )
  check.eq(
    imagem_cabe_tela(Resolucao(350.0, 400.0), Resolucao(330.0, 450.0)),
    False,
  )
  check.eq(
    imagem_cabe_tela(Resolucao(330.0, 500.0), Resolucao(330.0, 450.0)),
    False,
  )
}

pub type Figura {
  Retangulo(largura: Float, altura: Float)
  Circulo(raio: Float)
}

/// Calcula a área de *figura* com base nas suas dimensões.
pub fn calcula_area(figura: Figura) -> Float {
  case figura {
    Retangulo(largura, altura) -> largura *. altura
    Circulo(raio) -> raio *. raio *. 3.14
  }
}

pub fn calcula_area_examples() {
  check.eq(calcula_area(Retangulo(20.0, 10.0)), 200.0)
  check.eq(calcula_area(Retangulo(16.0, 7.0)), 112.0)
  check.eq(calcula_area(Circulo(5.0)), 78.5)
  check.eq(calcula_area(Circulo(3.5)), 38.465)
}

/// Produz True se a figura *a* cabe dentro da figura *b*, False caso contrário.
///
/// A seguinte tabela mostra as condições para que a figura *a* caiba dentro da
/// figura *b*. Se *a* é um retângulo, então *da* é a sua diagonal; senão, *da* é o seu
/// diâmetro.
/// 
/// fig a \ fig b     |   Retangulo(lb, ab)      | Circulo(rb)
/// ------------------|--------------------------|---------------
/// Retangulo(la, aa) |  la <= lb e aa <= ab     |  da <= 2 * rb
/// Circulo(ra)       |  da <= lb e da <= ab     |  ra <= rb
/// 
pub fn cabe(a: Figura, b: Figura) -> Bool {
  case a, b {
    Retangulo(la, aa), Retangulo(lb, ab) -> la <=. lb && aa <=. ab
    Retangulo(la, aa), Circulo(rb) -> {
      let assert Ok(resultado) = float.square_root(la *. la +. aa *. aa)
      resultado <=. 2.0 *. rb
    }
    Circulo(ra), Retangulo(lb, ab) -> 2.0 *. ra <=. lb && 2.0 *. ra <=. ab
    Circulo(ra), Circulo(rb) -> ra <=. rb
  }
}

pub fn cabe_examples() {
  check.eq(cabe(Retangulo(5.0, 18.0), Retangulo(10.0, 20.0)), True)
  check.eq(cabe(Retangulo(10.0, 20.0), Retangulo(10.0, 20.0)), True)
  check.eq(cabe(Retangulo(11.0, 20.0), Retangulo(10.0, 20.0)), False)
  check.eq(cabe(Retangulo(10.0, 21.0), Retangulo(10.0, 20.0)), False)
  check.eq(cabe(Retangulo(3.0, 4.0), Circulo(3.0)), True)
  check.eq(cabe(Retangulo(3.0, 4.0), Circulo(2.5)), True)
  check.eq(cabe(Retangulo(3.0, 4.0), Circulo(2.4)), False)
  check.eq(cabe(Circulo(2.0), Retangulo(4.0, 4.0)), True)
  check.eq(cabe(Circulo(2.0), Retangulo(3.0, 4.0)), False)
  check.eq(cabe(Circulo(2.0), Retangulo(4.0, 3.0)), False)
  check.eq(cabe(Circulo(2.0), Circulo(3.0)), True)
  check.eq(cabe(Circulo(3.0), Circulo(3.0)), True)
  check.eq(cabe(Circulo(4.0), Circulo(3.0)), False)
}

pub type Espectador {
  Crianca
  Jovem(codigo_carteirinha: Option(Int))
  Adulto
  Idoso
}

/// Retorna o número da carteirinha de *e*, caso ele seja um estudante
/// e tenha o código.
pub fn numero_carteirinha(e: Espectador) -> Option(Int) {
  case e {
    Jovem(codigo_carteirinha) -> codigo_carteirinha
    _ -> None
  }
}

/// Devolve True caso *e* tenha direito a desconto e False, caso contrário.
/// Um espectador tem direito a desconto se for criança, idoso ou um jovem 
/// com carteirinha de estudante.
pub fn tem_desconto(e: Espectador) -> Bool {
  case e {
    Jovem(None) | Adulto -> False
    _ -> True
  }
}

pub fn numero_carteirinha_examples() {
  check.eq(numero_carteirinha(Crianca), None)
  check.eq(numero_carteirinha(Jovem(None)), None)
  check.eq(numero_carteirinha(Jovem(Some(12))), Some(12))
  check.eq(numero_carteirinha(Adulto), None)
  check.eq(numero_carteirinha(Idoso), None)
}

pub fn tem_desconto_examples() {
  check.eq(tem_desconto(Crianca), True)
  check.eq(tem_desconto(Jovem(None)), False)
  check.eq(tem_desconto(Jovem(Some(12))), True)
  check.eq(tem_desconto(Adulto), False)
  check.eq(tem_desconto(Idoso), True)
}

/// Representa uma data, com dia, mês e ano.
pub opaque type Data {
  Data(dia: Int, mes: Int, ano: Int)
}

/// Devolve o dia de *data*.
pub fn dia_data(data: Data) -> Int {
  data.dia
}

/// Devolve o mês de *data*.
pub fn mes_data(data: Data) -> Int {
  data.mes
}

/// Devolve o ano de *data*.
pub fn ano_data(data: Data) -> Int {
  data.ano
}

/// Verifica se *ano* é bissexto. Devolve True, caso seja
/// e False, caso contrário.
pub fn bissexto(ano: Int) -> Bool {
  { ano % 400 == 0 } || { { ano % 4 == 0 } && { ano % 100 != 0 } }
}

/// Devolve a quantidade de dias de *mes* em determinado *ano*.
pub fn quantidade_dias(mes: Int, ano: Int) -> Int {
  let eh_bissexto: Bool = bissexto(ano)
  case mes {
    1 | 3 | 5 | 7 | 8 | 10 | 12 -> 31
    4 | 6 | 9 | 11 -> 30
    2 ->
      case eh_bissexto {
        True -> 29
        False -> 28
      }
    _ -> 0
  }
}

/// Converte *data* que está no formato "dd/mm/aaaa" para uma estrutura,
/// realizando toda a validação necessária.
///
/// Devolve um erro em caso de data inválida.
pub fn converte_data(data: String) -> Result(Data, Nil) {
  let dia = string.slice(data, 0, 2)
  let mes = string.slice(data, 3, 2)
  let ano = string.slice(data, 6, 4)
  case int.parse(dia), int.parse(mes), int.parse(ano) {
    Ok(dia), Ok(mes), Ok(ano) ->
      case mes >= 1 && mes <= 12 {
        True ->
          case ano >= 0 && ano <= 2025 {
            True ->
              case dia > 0 && dia <= quantidade_dias(mes, ano) {
                True -> Ok(Data(dia, mes, ano))
                False -> Error(Nil)
              }
            False -> Error(Nil)
          }
        False -> Error(Nil)
      }
    _, _, _ -> Error(Nil)
  }
}

/// Devolve True se *data* corresponde ao último dia de um ano.
/// Devolve False, caso contrário.
pub fn ultimo_dia_ano(data: Data) -> Bool {
  dia_data(data) == 31 && mes_data(data) == 12
}

/// Devolve True se *data1* ocorre antes de *data2*.
/// Devolve False, caso contrário.
pub fn data_antes(data1: Data, data2: Data) -> Bool {
  ano_data(data1) < ano_data(data2)
  || { ano_data(data1) == ano_data(data2) && mes_data(data1) < mes_data(data2) }
  || {
    ano_data(data1) == ano_data(data2)
    && mes_data(data1) == mes_data(data2)
    && dia_data(data1) < dia_data(data2)
  }
}

pub fn data_antes_examples() {
  let assert Ok(data1) = converte_data("25/05/2006")
  let assert Ok(data2) = converte_data("25/05/2007")
  let assert Ok(data3) = converte_data("25/05/2005")
  let assert Ok(data4) = converte_data("25/06/2006")
  let assert Ok(data5) = converte_data("25/04/2006")
  let assert Ok(data6) = converte_data("24/05/2006")
  let assert Ok(data7) = converte_data("26/05/2006")
  let assert Ok(data8) = converte_data("25/05/2006")

  check.eq(data_antes(data1, data2), True)
  check.eq(data_antes(data1, data3), False)
  check.eq(data_antes(data1, data4), True)
  check.eq(data_antes(data1, data5), False)
  check.eq(data_antes(data1, data6), False)
  check.eq(data_antes(data1, data7), True)
  check.eq(data_antes(data1, data8), False)
}

pub fn ultimo_dia_ano_examples() {
  let assert Ok(data1) = converte_data("31/12/2023")
  check.eq(ultimo_dia_ano(data1), True)
  let assert Ok(data2) = converte_data("31/12/2025")
  check.eq(ultimo_dia_ano(data2), True)
  let assert Ok(data3) = converte_data("30/12/2023")
  check.eq(ultimo_dia_ano(data3), False)
  let assert Ok(data4) = converte_data("01/01/2023")
  check.eq(ultimo_dia_ano(data4), False)
}

pub fn bissexto_examples() {
  check.eq(bissexto(1600), True)
  check.eq(bissexto(2000), True)
  check.eq(bissexto(2024), True)
  check.eq(bissexto(1996), True)
  check.eq(bissexto(1800), False)
  check.eq(bissexto(2023), False)
  check.eq(bissexto(2100), False)
}

pub fn quantidade_dias_examples() {
  check.eq(quantidade_dias(1, 2023), 31)
  check.eq(quantidade_dias(3, 2023), 31)
  check.eq(quantidade_dias(5, 2023), 31)
  check.eq(quantidade_dias(7, 2023), 31)
  check.eq(quantidade_dias(8, 2023), 31)
  check.eq(quantidade_dias(10, 2023), 31)
  check.eq(quantidade_dias(12, 2023), 31)
  check.eq(quantidade_dias(4, 2023), 30)
  check.eq(quantidade_dias(6, 2023), 30)
  check.eq(quantidade_dias(9, 2023), 30)
  check.eq(quantidade_dias(11, 2023), 30)
  check.eq(quantidade_dias(2, 2023), 28)
  check.eq(quantidade_dias(2, 2024), 29)
}

pub fn converte_data_examples() {
  check.eq(converte_data("01/01/2020"), Ok(Data(1, 1, 2020)))
  check.eq(converte_data("31/01/2025"), Ok(Data(31, 1, 2025)))
  check.eq(converte_data("30/04/2023"), Ok(Data(30, 4, 2023)))
  check.eq(converte_data("28/02/2023"), Ok(Data(28, 2, 2023)))
  check.eq(converte_data("29/02/2024"), Ok(Data(29, 2, 2024)))
  check.eq(converte_data("32/01/2020"), Error(Nil))
  check.eq(converte_data("31/04/2022"), Error(Nil))
  check.eq(converte_data("29/02/2023"), Error(Nil))
  check.eq(converte_data("00/01/2020"), Error(Nil))
  check.eq(converte_data("15/00/2020"), Error(Nil))
  check.eq(converte_data("15/13/2020"), Error(Nil))
  check.eq(converte_data("15/08/-1"), Error(Nil))
  check.eq(converte_data("aa/bb/cccc"), Error(Nil))
  check.eq(converte_data("1a/08/2020"), Error(Nil))
  check.eq(converte_data("15/0b/2020"), Error(Nil))
}

pub fn dia_data_examples() {
  let assert Ok(d1) = converte_data("31/12/2024")
  let assert Ok(d2) = converte_data("01/01/2025")
  check.eq(dia_data(d1), 31)
  check.eq(dia_data(d2), 1)
}

pub fn mes_data_examples() {
  let assert Ok(d1) = converte_data("31/12/2024")
  let assert Ok(d2) = converte_data("01/01/2025")
  check.eq(mes_data(d1), 12)
  check.eq(mes_data(d2), 1)
}

pub fn ano_data_examples() {
  let assert Ok(d1) = converte_data("31/12/2024")
  let assert Ok(d2) = converte_data("01/01/2025")
  check.eq(ano_data(d1), 2024)
  check.eq(ano_data(d2), 2025)
}

/// Representa as possíveis situações de um estudante.
pub type Situacao {
  Aprovado
  Reprovado
  Exame
}

/// Calcula a média simples entre as quatro notas de um estudante (*n1*,*n2*,*n3*,
/// *n4*) e retorna a situação do discente.
pub fn calcula_media(n1: Float, n2: Float, n3: Float, n4: Float) -> Situacao {
  let media = { n1 +. n2 +. n3 +. n4 } /. 4.0
  case media >=. 7.0 {
    True -> Aprovado
    False ->
      case media >=. 4.0 {
        True -> Exame
        False -> Reprovado
      }
  }
}

pub fn calcula_media_examples() {
  check.eq(calcula_media(8.0, 10.0, 8.5, 9.5), Aprovado)
  // média = 7.0
  check.eq(calcula_media(6.0, 5.0, 8.0, 9.0), Aprovado)
  check.eq(calcula_media(4.0, 5.0, 3.0, 9.0), Exame)
  // média = 4.0
  check.eq(calcula_media(6.0, 5.0, 4.0, 1.0), Exame)
  check.eq(calcula_media(3.0, 1.0, 4.0, 2.0), Reprovado)
}

/// Representa as bandeiras tarifárias existentes.
pub type BandeiraTarifaria {
  Verde
  Amarela
  Vermelha1
  Vermelha2
}

/// Calcula o valor final de uma conta de luz, com base no *consumo* e 
/// na *tarifa*, que é alterada dependendo de *bandeira*.
pub fn calcula_valor_conta(
  consumo: Float,
  tarifa: Float,
  bandeira: BandeiraTarifaria,
) -> Float {
  let resultado: Float = case bandeira {
    Verde -> consumo *. tarifa
    Amarela -> consumo *. { tarifa +. 0.01874 }
    Vermelha1 -> consumo *. { tarifa +. 0.03971 }
    Vermelha2 -> consumo *. { tarifa +. 0.09492 }
  }
  float.to_precision(resultado, 3)
}

pub fn calcula_valor_conta_examples() {
  check.eq(calcula_valor_conta(100.0, 1.0, Verde), 100.0)
  check.eq(calcula_valor_conta(100.0, 1.0, Amarela), 101.874)
  check.eq(calcula_valor_conta(100.0, 1.0, Vermelha1), 103.971)
  check.eq(calcula_valor_conta(100.0, 1.0, Vermelha2), 109.492)
}

/// O símbolo feito com a mão em uma jogada.
pub type Mao {
  Pedra
  Papel
  Tesoura
}

/// Representação da jogada.
pub type Jogada {
  Jogada(jogador: String, mao: Mao)
}

/// Determina o nome do jogador, entre o jogador que fez a jogada *a* e o
/// jogador que fez a jogada *b*, que ganhou a rodada do Jokenpô. Se houve
/// empate, devolve None.
///
/// Para determinar o vencedor, as seguintes regras são utilizadas:
/// - Jogadas iguais resultam em empate
/// - Pedra ganha de tesoura
/// - Tesoura ganha de papel
/// - Papel ganha da pedra
///
/// a / b   | pedra | papel | tesoura
/// --------+-------+-------+--------
/// pedra   |   -   |   b   |  a
/// papel   |   a   |   -   |  b
/// tesoura |   b   |   a   |  -
pub fn ganhador(a: Jogada, b: Jogada) -> Option(String) {
  case a.mao, b.mao {
    Pedra, Pedra | Papel, Papel | Tesoura, Tesoura -> None
    Pedra, Tesoura | Papel, Pedra | Tesoura, Papel -> Some(a.jogador)
    _, _ -> Some(b.jogador)
  }
}

pub fn ganhador_examples() {
  check.eq(ganhador(Jogada("Pedro", Pedra), Jogada("Paula", Pedra)), None)
  check.eq(
    ganhador(Jogada("Pedro", Pedra), Jogada("Paula", Papel)),
    Some("Paula"),
  )
  check.eq(
    ganhador(Jogada("Pedro", Pedra), Jogada("Paula", Tesoura)),
    Some("Pedro"),
  )
  check.eq(
    ganhador(Jogada("Pedro", Papel), Jogada("Paula", Pedra)),
    Some("Pedro"),
  )
  check.eq(ganhador(Jogada("Pedro", Papel), Jogada("Paula", Papel)), None)
  check.eq(
    ganhador(Jogada("Pedro", Papel), Jogada("Paula", Tesoura)),
    Some("Paula"),
  )
  check.eq(
    ganhador(Jogada("Pedro", Tesoura), Jogada("Paula", Pedra)),
    Some("Paula"),
  )
  check.eq(
    ganhador(Jogada("Pedro", Tesoura), Jogada("Paula", Papel)),
    Some("Pedro"),
  )
  check.eq(ganhador(Jogada("Pedro", Tesoura), Jogada("Paula", Tesoura)), None)
}

/// Representa o resultado de um jogo de uma equipe.
pub type ResultadoEquipe {
  ResultadoEquipe(gols_marcados: Int, gols_sofridos: Int)
}

/// Representa o desempenho de uma equipe.
pub type Desempenho {
  Desempenho(pontos: Int, vitorias: Int, saldo: Int)
}

pub fn atualiza_desempenho(
  ultimo_jogo: ResultadoEquipe,
  desempenho: Desempenho,
) -> Desempenho {
  let diferenca = ultimo_jogo.gols_marcados - ultimo_jogo.gols_sofridos
  case diferenca > 0 {
    True ->
      Desempenho(
        pontos: desempenho.pontos + 3,
        vitorias: desempenho.vitorias + 1,
        saldo: desempenho.saldo + diferenca,
      )
    False ->
      case diferenca == 0 {
        True -> Desempenho(..desempenho, pontos: desempenho.pontos + 1)
        False -> Desempenho(..desempenho, saldo: desempenho.saldo + diferenca)
      }
  }
}

pub fn atualiza_desempenho_examples() {
  check.eq(
    atualiza_desempenho(ResultadoEquipe(2, 0), Desempenho(7, 2, 3)),
    Desempenho(10, 3, 5),
  )
  check.eq(
    atualiza_desempenho(ResultadoEquipe(1, 1), Desempenho(7, 2, 3)),
    Desempenho(8, 2, 3),
  )
  check.eq(
    atualiza_desempenho(ResultadoEquipe(0, 2), Desempenho(7, 2, 3)),
    Desempenho(7, 2, 1),
  )
}

/// Representa um intervalo de tempo, com horas, minutos e segundos.
pub type Duracao {
  Duracao(horas: Int, minutos: Int, segundos: Int)
}

/// Converte uma quantidade de segundos *total_segundos* para
/// o valor equivalente em horas, minutos e segundos.
pub fn segundos_para_hms(total_segundos: Int) -> Duracao {
  let horas = total_segundos / 3600
  let resto_apos_horas = total_segundos % 3600

  let minutos = resto_apos_horas / 60
  let segundos = resto_apos_horas % 60

  Duracao(horas, minutos, segundos)
}

/// Devolve uma string informando as horas, os minutos e os segundos
/// conectados a *duracao*.
pub fn informa_duracao(duracao: Duracao) -> Option(String) {
  case duracao.horas != 0, duracao.minutos != 0, duracao.segundos != 0 {
    True, True, True ->
      Some(
        "Duração - Horas: "
        <> int.to_string(duracao.horas)
        <> ", Minutos: "
        <> int.to_string(duracao.minutos)
        <> ", Segundos: "
        <> int.to_string(duracao.segundos),
      )
    True, True, False ->
      Some(
        "Duração - Horas: "
        <> int.to_string(duracao.horas)
        <> ", Minutos: "
        <> int.to_string(duracao.minutos),
      )
    True, False, True ->
      Some(
        "Duração - Horas: "
        <> int.to_string(duracao.horas)
        <> ", Segundos: "
        <> int.to_string(duracao.segundos),
      )
    False, True, True ->
      Some(
        "Duração - Minutos: "
        <> int.to_string(duracao.minutos)
        <> ", Segundos: "
        <> int.to_string(duracao.segundos),
      )
    True, False, False ->
      Some("Duração - Horas: " <> int.to_string(duracao.horas))
    False, True, False ->
      Some("Duração - Minutos: " <> int.to_string(duracao.minutos))
    False, False, True ->
      Some("Duração - Segundos: " <> int.to_string(duracao.segundos))
    False, False, False -> None
  }
}

pub fn segundos_para_hms_examples() {
  check.eq(segundos_para_hms(14_678), Duracao(4, 4, 38))
  check.eq(segundos_para_hms(10_000), Duracao(2, 46, 40))
  check.eq(segundos_para_hms(3600), Duracao(1, 0, 0))
  check.eq(segundos_para_hms(3661), Duracao(1, 1, 1))
  check.eq(segundos_para_hms(59), Duracao(0, 0, 59))
  check.eq(segundos_para_hms(0), Duracao(0, 0, 0))
}

pub fn informa_duracao_examples() {
  check.eq(
    informa_duracao(Duracao(1, 2, 3)),
    Some("Duração - Horas: 1, Minutos: 2, Segundos: 3"),
  )
  check.eq(
    informa_duracao(Duracao(1, 2, 0)),
    Some("Duração - Horas: 1, Minutos: 2"),
  )
  check.eq(
    informa_duracao(Duracao(1, 0, 3)),
    Some("Duração - Horas: 1, Segundos: 3"),
  )
  check.eq(
    informa_duracao(Duracao(0, 2, 3)),
    Some("Duração - Minutos: 2, Segundos: 3"),
  )
  check.eq(informa_duracao(Duracao(1, 0, 0)), Some("Duração - Horas: 1"))
  check.eq(informa_duracao(Duracao(0, 2, 0)), Some("Duração - Minutos: 2"))
  check.eq(informa_duracao(Duracao(0, 0, 3)), Some("Duração - Segundos: 3"))
  check.eq(informa_duracao(Duracao(0, 0, 0)), None)
}

/// A posição e direção que um personagem se encontra no tabuleiro.
pub type Personagem {
  /// A linha deve estar entre 1 e 10.
  /// A coluna deve estar entre 1 e 10.
  Personagem(lin: Int, col: Int, dir: Direcao)
}

/// Determina o número máximo de casas que o personagem *p* pode avançar
/// considerando a sua posição atual e a direção que ele está virado.
pub fn maximo_casas(p: Personagem) -> Int {
  case p.dir {
    Norte -> 10 - p.lin
    Sul -> p.lin - 1
    Leste -> 10 - p.col
    Oeste -> p.col - 1
  }
}

pub fn maximo_casas_examples() {
  check.eq(maximo_casas(Personagem(4, 2, Norte)), 6)
  check.eq(maximo_casas(Personagem(10, 2, Norte)), 0)
  check.eq(maximo_casas(Personagem(4, 2, Sul)), 3)
  check.eq(maximo_casas(Personagem(1, 2, Sul)), 0)
  check.eq(maximo_casas(Personagem(4, 2, Leste)), 8)
  check.eq(maximo_casas(Personagem(4, 10, Leste)), 0)
  check.eq(maximo_casas(Personagem(4, 5, Oeste)), 4)
  check.eq(maximo_casas(Personagem(4, 1, Oeste)), 0)
}

/// O espaço que uma janela ocupa em um ambiente gráfico.
pub type Janela {
  Janela(
    // coordenada x do canto superior esquerdo
    x: Int,
    // coordenada y do canto superior esquerdo
    y: Int,
    // quantidade de pixels à direita de (x, y)
    largura: Int,
    // quantidade de pixels abaixo de (x, y)
    altura: Int,
  )
}

// A posição de um clique no ambiente gráfico.
pub type Clique {
  Clique(
    // deve ser maior que 0 e menor que a largura do ambiente
    x: Int,
    // deve ser maior que 0 e menor que a altura do ambiente
    y: Int,
  )
}

// Devolve True se o clique *c* está dentro do espaço da janela *j*, False caso contrário.
pub fn dentro_janela(j: Janela, c: Clique) -> Bool {
  j.x <= c.x
  && c.x < { j.x + j.largura }
  && j.y <= c.y
  && c.y < { j.y + j.altura }
}

pub fn dentro_janela_examples() {
  let jj = Janela(x: 100, y: 100, largura: 300, altura: 200)
  check.eq(dentro_janela(jj, Clique(x: 150, y: 150)), True)
  check.eq(dentro_janela(jj, Clique(x: 600, y: 150)), False)
  check.eq(dentro_janela(jj, Clique(x: 150, y: 300)), False)
  check.eq(dentro_janela(jj, Clique(x: 150, y: 50)), False)
  check.eq(dentro_janela(jj, Clique(x: 50, y: 150)), False)
  check.eq(dentro_janela(jj, Clique(x: 100, y: 100)), True)
  check.eq(dentro_janela(jj, Clique(x: 399, y: 100)), True)
  check.eq(dentro_janela(jj, Clique(x: 400, y: 100)), False)
  check.eq(dentro_janela(jj, Clique(x: 399, y: 299)), True)
  check.eq(dentro_janela(jj, Clique(x: 400, y: 299)), False)
  check.eq(dentro_janela(jj, Clique(x: 399, y: 300)), False)
  check.eq(dentro_janela(jj, Clique(x: 400, y: 300)), False)
  check.eq(dentro_janela(jj, Clique(x: 100, y: 299)), True)
  check.eq(dentro_janela(jj, Clique(x: 100, y: 300)), False)
}

/// Produz True se o espaço das janelas *a* e *b* se sobrepõem, False caso contrário.
pub fn janelas_sobrepoem(a: Janela, b: Janela) -> Bool {
  a.x < { b.x + b.largura }
  && b.x < { a.x + a.largura }
  && a.y < { b.y + b.altura }
  && b.y < { a.y + a.altura }
}

pub fn janelas_sobrepoem_examples() {
  check.eq(
    janelas_sobrepoem(
      Janela(x: 10, y: 20, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 210, y: 20, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 310, y: 20, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 410, y: 20, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 10, y: 250, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 210, y: 250, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    True,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 310, y: 250, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    True,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 410, y: 250, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 10, y: 450, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 210, y: 450, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    True,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 310, y: 450, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    True,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 410, y: 450, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 10, y: 550, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 210, y: 550, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 310, y: 550, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
  check.eq(
    janelas_sobrepoem(
      Janela(x: 410, y: 550, largura: 100, altura: 200),
      Janela(x: 300, y: 400, largura: 50, altura: 100),
    ),
    False,
  )
}

/// Representa um comando a ser feito pelo personagem.
pub type Comando {
  VirarDireita
  VirarEsquerda
  Avancar(casas: Int)
}

/// Devolve o novo estado de um personagem, com base em *personagem*, seu estado atual e
/// *comando*, uma atividade que ele deve realizar.
///
/// Se o comando for "VirarDireita", o personagem deve mudar sua posição no sentido horário em 90°.
/// Se o comando for "VirarEsquerda", o personagem deve mudar sua posição no sentido anti-horário em 90°.
/// Se o comando for "Avançar", o personagem deve avançar *casas*, na direção em que ele está virado.
/// Se o avanço ultrapassar o limite, o personagem não avança e fica na posição de limite.
pub fn muda_personagem(personagem: Personagem, comando: Comando) -> Personagem {
  case comando {
    VirarDireita ->
      Personagem(..personagem, dir: direcao_noventa_horario(personagem.dir))
    VirarEsquerda ->
      Personagem(
        ..personagem,
        dir: direcao_noventa_anti_horario(personagem.dir),
      )
    Avancar(casas) ->
      case personagem.dir {
        Norte ->
          Personagem(..personagem, lin: int.min(10, personagem.lin + casas))
        Sul -> Personagem(..personagem, lin: int.max(1, personagem.lin - casas))
        Leste ->
          Personagem(..personagem, col: int.min(10, personagem.col + casas))
        Oeste ->
          Personagem(..personagem, col: int.max(1, personagem.col - casas))
      }
  }
}

pub fn muda_personagem_examples() {
  // ---- Virar Direita ----
  check.eq(
    muda_personagem(Personagem(5, 5, Norte), VirarDireita),
    Personagem(5, 5, Leste),
  )
  check.eq(
    muda_personagem(Personagem(5, 5, Leste), VirarDireita),
    Personagem(5, 5, Sul),
  )
  check.eq(
    muda_personagem(Personagem(5, 5, Sul), VirarDireita),
    Personagem(5, 5, Oeste),
  )
  check.eq(
    muda_personagem(Personagem(5, 5, Oeste), VirarDireita),
    Personagem(5, 5, Norte),
  )

  // ---- Virar Esquerda ----
  check.eq(
    muda_personagem(Personagem(5, 5, Norte), VirarEsquerda),
    Personagem(5, 5, Oeste),
  )
  check.eq(
    muda_personagem(Personagem(5, 5, Oeste), VirarEsquerda),
    Personagem(5, 5, Sul),
  )
  check.eq(
    muda_personagem(Personagem(5, 5, Sul), VirarEsquerda),
    Personagem(5, 5, Leste),
  )
  check.eq(
    muda_personagem(Personagem(5, 5, Leste), VirarEsquerda),
    Personagem(5, 5, Norte),
  )

  // ---- Avançar
  check.eq(
    muda_personagem(Personagem(5, 5, Norte), Avancar(3)),
    Personagem(8, 5, Norte),
  )
  check.eq(
    muda_personagem(Personagem(5, 5, Sul), Avancar(2)),
    Personagem(3, 5, Sul),
  )
  check.eq(
    muda_personagem(Personagem(5, 5, Leste), Avancar(4)),
    Personagem(5, 9, Leste),
  )
  check.eq(
    muda_personagem(Personagem(5, 5, Oeste), Avancar(3)),
    Personagem(5, 2, Oeste),
  )
  check.eq(
    muda_personagem(Personagem(9, 5, Norte), Avancar(5)),
    Personagem(10, 5, Norte),
  )
  check.eq(
    muda_personagem(Personagem(2, 5, Sul), Avancar(5)),
    Personagem(1, 5, Sul),
  )
  check.eq(
    muda_personagem(Personagem(5, 8, Leste), Avancar(10)),
    Personagem(5, 10, Leste),
  )
  check.eq(
    muda_personagem(Personagem(5, 2, Oeste), Avancar(5)),
    Personagem(5, 1, Oeste),
  )
}

/// Representa as possibilidades de realização de um pagamento.
pub type FormaPagamento {
  PIX
  Dinheiro
  Boleto
  CartaoCredito(parcelas: Int)
}

/// Calcula o valor final da compra de valor *valor_compra*, considerando a forma-pagamento
/// da seguinte maneira:
/// - Dinheiro ou PIX, 10% de desconto;
/// - Boleto, 8% de desconto;
/// - Cartão em até 3 vezes, sem desconto;
/// - Cartão em mais de 3 vezes, acréscimo de 12%;
pub fn valor_final_compra(valor_compra: Float, forma: FormaPagamento) -> Float {
  case forma {
    PIX | Dinheiro -> valor_compra *. 0.9
    Boleto -> valor_compra *. 0.92
    CartaoCredito(parcelas) ->
      case parcelas <= 3 {
        True -> valor_compra
        False -> valor_compra *. 1.12
      }
  }
}

pub fn valor_final_compra_examples() {
  check.eq(valor_final_compra(100.0, Dinheiro), 90.0)
  check.eq(valor_final_compra(200.0, PIX), 180.0)
  check.eq(valor_final_compra(300.0, Boleto), 276.0)
  check.eq(valor_final_compra(100.0, CartaoCredito(1)), 100.0)
  check.eq(valor_final_compra(100.0, CartaoCredito(3)), 100.0)
  check.eq(valor_final_compra(200.0, CartaoCredito(4)), 200.0 *. 1.12)
}

/// Representa as embalagens existentes.
pub type Embalagem {
  Envelope(comprimento: Int, largura: Int)
  Caixa(comprimento: Int, largura: Int, altura: Int)
  Rolo(comprimento: Int, diametro: Int)
}

/// Verifica se *e* é uma embalagem válida, ou seja, está
/// dentro dos limites especificados.
///
/// Envelope:
/// - Comprimento (C): 16 cm a 60 cm
/// - Largura (L): 11 cm a 60 cm
/// - Soma (C + L): 27 cm a 120 cm
///
/// Caixa:
/// - Comprimento (C): 15 cm a 100 cm
/// - Largura (L): 10 cm a 100 cm
/// - Altura (A): 1 cm a 100 cm
/// - Soma (C + L + A): 26 cm a 200 cm
///
/// Rolo:
/// - Comprimento (C): 18 cm a 100 cm
/// - Diâmetro (D): 5 cm a 91 cm
/// - Soma (C + 2D): 28 cm a 200 cm
///
/// Retorna `True` se todas as condições forem satisfeitas,
/// e `False` caso contrário.
pub fn verifica_validade_embalagem(e: Embalagem) -> Bool {
  case e {
    Envelope(comprimento, largura) ->
      comprimento >= 16 && comprimento <= 60 && largura >= 11 && largura <= 60
    Caixa(comprimento, largura, altura) ->
      comprimento >= 15
      && comprimento <= 100
      && largura >= 10
      && largura <= 100
      && altura >= 1
      && altura <= 100
      && { { comprimento + largura + altura } <= 200 }
    Rolo(comprimento, diametro) ->
      comprimento >= 18
      && comprimento <= 100
      && diametro >= 5
      && diametro <= 91
      && { { comprimento + 2 * diametro } <= 200 }
  }
}

pub fn verifica_validade_embalagem_examples() {
  check.eq(verifica_validade_embalagem(Envelope(15, 30)), False)
  check.eq(verifica_validade_embalagem(Envelope(61, 30)), False)
  check.eq(verifica_validade_embalagem(Envelope(30, 10)), False)
  check.eq(verifica_validade_embalagem(Envelope(30, 61)), False)
  check.eq(verifica_validade_embalagem(Envelope(16, 11)), True)
  check.eq(verifica_validade_embalagem(Envelope(60, 60)), True)
  check.eq(verifica_validade_embalagem(Caixa(14, 50, 20)), False)
  check.eq(verifica_validade_embalagem(Caixa(101, 50, 20)), False)
  check.eq(verifica_validade_embalagem(Caixa(50, 9, 20)), False)
  check.eq(verifica_validade_embalagem(Caixa(50, 101, 20)), False)
  check.eq(verifica_validade_embalagem(Caixa(50, 50, 0)), False)
  check.eq(verifica_validade_embalagem(Caixa(50, 50, 101)), False)
  check.eq(verifica_validade_embalagem(Caixa(15, 10, 1)), True)
  check.eq(verifica_validade_embalagem(Caixa(100, 100, 100)), False)
  check.eq(verifica_validade_embalagem(Caixa(66, 67, 67)), True)
  check.eq(verifica_validade_embalagem(Caixa(120, 40, 40)), False)
  check.eq(verifica_validade_embalagem(Rolo(17, 50)), False)
  check.eq(verifica_validade_embalagem(Rolo(101, 50)), False)
  check.eq(verifica_validade_embalagem(Rolo(60, 4)), False)
  check.eq(verifica_validade_embalagem(Rolo(60, 92)), False)
  check.eq(verifica_validade_embalagem(Rolo(18, 5)), True)
  check.eq(verifica_validade_embalagem(Rolo(100, 91)), False)
  check.eq(verifica_validade_embalagem(Rolo(100, 50)), True)
  check.eq(verifica_validade_embalagem(Rolo(100, 51)), False)
  check.eq(verifica_validade_embalagem(Rolo(80, 60)), True)
  check.eq(verifica_validade_embalagem(Rolo(80, 61)), False)
}
