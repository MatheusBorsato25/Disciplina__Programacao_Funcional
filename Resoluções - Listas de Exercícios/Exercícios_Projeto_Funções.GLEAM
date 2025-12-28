import gleam/float
import gleam/int
import gleam/string
import sgleam/check

/// Produz True se uma pessoa com *idade* é isento da
/// tarifa de transporte público, isto é, tem menos
/// de 18 anos ou 65 ou mais. Produz False caso contrário.
pub fn isento_tarifa(idade: Int) -> Bool {
  idade < 18 || idade >= 65
}

pub fn isento_tarifa_examples() {
  check.eq(isento_tarifa(17), True)
  check.eq(isento_tarifa(18), False)
  check.eq(isento_tarifa(50), False)
  check.eq(isento_tarifa(65), True)
  check.eq(isento_tarifa(70), True)
}

/// Conta a quantidade de dígitos de *n*.
/// Se *n* é 0, então devolve zero.
/// Se *n* é menor que zero, então devolve a quantidade
/// de dígitos do valor absoluto de *n*.
pub fn quantidade_digitos(n: Int) -> Int {
  case n == 0 {
    True -> 0
    False -> string.length(int.to_string(valor_absoluto(n)))
  }
}

/// Devolve o valor absoluto de *n*.
pub fn valor_absoluto(n: Int) -> Int {
  case n < 0 {
    True -> -n
    False -> n
  }
}

pub fn valor_absoluto_examples() {
  check.eq(valor_absoluto(5), 5)
  check.eq(valor_absoluto(-5), 5)
  check.eq(valor_absoluto(0), 0)
}

pub fn quantidade_digitos_examples() {
  check.eq(quantidade_digitos(123), 3)
  check.eq(quantidade_digitos(0), 0)
  check.eq(quantidade_digitos(-1519), 4)
}

/// Produz True se uma pessoa com *idade* é supercentenária,
/// isto é, tem 110 anos ou mais, produz False caso contrário.
pub fn supercentenario(idade: Int) -> Bool {
  idade >= 110
}

pub fn supercentenario_examples() {
  check.eq(supercentenario(101), False)
  check.eq(supercentenario(110), True)
  check.eq(supercentenario(112), True)
}

/// Transforma a string *data* que está no formato "dia/mes/ano"
/// para o formato "ano/mes/dia".
///
/// Requer que o dia e o mês tenham dois dígitos e que
/// o ano tenha quatro dígitos.
pub fn dma_para_amd(data: String) -> String {
  let dia: String = string.slice(data, 0, 2)
  let mes: String = string.slice(data, 3, 2)
  let ano: String = string.slice(data, 6, 4)
  ano <> "/" <> mes <> "/" <> dia
}

pub fn dma_para_amd_examples() {
  check.eq(dma_para_amd("19/07/2023"), "2023/07/19")
  check.eq(dma_para_amd("01/01/1980"), "1980/01/01")
  check.eq(dma_para_amd("02/02/2002"), "2002/02/02")
}

/// Calcula um novo valor aplicando *porcentagem* ao *valor*, aumentando-o.
/// Requer que *valor* e *porcentagem* sejam não negativos.
pub fn aumenta(valor: Float, porcentagem: Float) -> Float {
  valor *. { 1.0 +. porcentagem /. 100.0 }
}

pub fn aumenta_examples() {
  check.eq(aumenta(90.0, 5.0), 94.5)
  check.eq(aumenta(30.0, 60.0), 48.0)
  check.eq(aumenta(10.0, 97.0), 19.7)
}

pub type Tamanho =
  String

/// Classifica *nome* de acordo com a quantidade de caracteres da forma a seguir:
/// "curto" para nomes com 4 ou menos caracteres;
/// "longo" para nomes com mais que 10 caracteres;
/// "médio" para nomes entre 5 e 10 caracteres.
pub fn tamanho_nome(nome: String) -> Tamanho {
  case string.length(nome) <= 4 {
    True -> "curto"
    False ->
      case string.length(nome) <= 10 {
        True -> "médio"
        False -> "longo"
      }
  }
}

pub fn tamanho_nome_examples() {
  check.eq(tamanho_nome("Ana"), "curto")
  check.eq(tamanho_nome("Rafa"), "curto")
  check.eq(tamanho_nome("Pedro"), "médio")
  check.eq(tamanho_nome("Matheus"), "médio")
  check.eq(tamanho_nome("Wellington"), "médio")
  check.eq(tamanho_nome("Maximiliano"), "longo")
}

/// Adiciona "." (ponto final) em *frase*, caso ela não termine com ele.
pub fn adiciona_ponto_final(frase: String) -> String {
  let ultimo_caracter = string.slice(frase, string.length(frase) - 1, 1)
  case ultimo_caracter == "." {
    True -> frase
    False -> frase <> "."
  }
}

pub fn adiciona_ponto_final_examples() {
  check.eq(adiciona_ponto_final(""), ".")
  check.eq(adiciona_ponto_final("Vai Corinthians"), "Vai Corinthians.")
  check.eq(adiciona_ponto_final("Vai Corinthians."), "Vai Corinthians.")
  check.eq(adiciona_ponto_final("Que.dia.maravilhoso."), "Que.dia.maravilhoso.")
  check.eq(adiciona_ponto_final("Que.dia.maravilhoso"), "Que.dia.maravilhoso.")
}

/// Produz True se *palavra* tem um hífen no meio.
/// Produz False caso contrário.
pub fn tem_traco(palavra: String) -> Bool {
  let elemento_meio = string.slice(palavra, string.length(palavra) / 2, 1)
  { string.length(palavra) % 2 == 1 } && { elemento_meio == "-" }
}

pub fn tem_traco_examples() {
  check.eq(tem_traco(""), False)
  check.eq(tem_traco("Bom-dia"), True)
  check.eq(tem_traco("Bom-dias"), False)
  check.eq(tem_traco("Boa-tarde"), False)
  check.eq(tem_traco("Lero-lero"), True)
  check.eq(tem_traco("Vai Corinthians"), False)
}

/// Produz o máximo entre *a*, *b* e *c*.
/// Requer que *a*, *b* e *c* sejam inteiros.
pub fn maximo(a: Int, b: Int, c: Int) -> Int {
  case a > b {
    True ->
      case a > c {
        True -> a
        False -> c
      }
    False ->
      case b > c {
        True -> b
        False -> c
      }
  }
}

pub fn maximo_examples() {
  check.eq(maximo(7, 8, 3), 8)
  check.eq(maximo(9, 2, 5), 9)
  check.eq(maximo(3, 6, 10), 10)
  check.eq(maximo(2, 2, 2), 2)
}

/// Altera *palavra*, substituindo seus *n* primeiros caracteres 
/// por *n* letras x. 
/// Se *n* for maior que o tamanho de *palavra*, devolve uma string com
/// todos os caracteres de *palavra* substituídos por letras "x".
/// Se *n for menor ou igual a zero, devolve *palavra*.
pub fn muda_palavra(palavra: String, n: Int) -> String {
  case n <= 0 {
    True -> palavra
    False -> {
      let tamanho: Int = string.length(palavra)
      let resto: String = string.slice(palavra, n, tamanho - n)
      string.repeat("x", int.min(tamanho, n)) <> resto
    }
  }
}

pub fn muda_palavra_examples() {
  check.eq(muda_palavra("Corinthians", 0), "Corinthians")
  check.eq(muda_palavra("Celular", 2), "xxlular")
  check.eq(muda_palavra("Dentista", 5), "xxxxxsta")
  check.eq(muda_palavra("Hoje", 4), "xxxx")
  check.eq(muda_palavra("Hoje", 7), "xxxx")
  check.eq(muda_palavra("Hoje", -1), "Hoje")
}

/// Verifica se um texto está de acordo com a regra "sem espaços extras",
/// ou seja, não começa nem termina com espaço.
/// Devolve True em caso de respeito a regra e False, caso contrário.
pub fn sem_espaco_extra(texto: String) -> Bool {
  let primeiro_caracter = string.slice(texto, 0, 1)
  let ultimo_caracter = string.slice(texto, string.length(texto) - 1, 1)
  primeiro_caracter != " " && ultimo_caracter != " "
}

pub fn sem_espaco_extra_examples() {
  check.eq(sem_espaco_extra(""), True)
  check.eq(sem_espaco_extra("Corinthians"), True)
  check.eq(sem_espaco_extra(" Corinthians"), False)
  check.eq(sem_espaco_extra("Corinthians "), False)
  check.eq(sem_espaco_extra(" Corinthians "), False)
  check.eq(sem_espaco_extra("C o r i n t h i a n s"), True)
}

/// Calcula o imposto que uma pessoa com a renda *r* deve pagar. O percentual
/// do imposto é determinado da seguinte forma:
/// Se *r* <= 1000, 5% de *r*.
/// Se 1000 < *r* <= 5000, 5% de 1000 e 10% do que passar de 1000.
/// Se 5000 < *r*, 5% de 1000, 10% de 4000 e 20% do que passar de 5000.
pub fn calcula_imposto(r: Float) -> Float {
  case r <=. 1000.0 {
    True -> r *. 0.05
    False ->
      case r >. 5000.0 {
        True -> 50.0 +. 400.0 +. 0.2 *. { r -. 5000.0 }
        False -> 50.0 +. 0.1 *. { r -. 1000.0 }
      }
  }
}

pub fn calcula_imposto_examples() {
  check.eq(calcula_imposto(900.0), 45.0)
  check.eq(calcula_imposto(1000.0), 50.0)
  check.eq(calcula_imposto(3000.0), 250.0)
  check.eq(calcula_imposto(5000.0), 450.0)
  check.eq(calcula_imposto(8000.0), 1050.0)
  check.eq(calcula_imposto(10_000.0), 1450.0)
}

/// Produz True se *palavra* é formada pela ocorrência de duas partes iguais,
/// separadas ou não por hífen.
/// Produz False, caso contrário.
pub fn palavra_duplicada(palavra: String) -> Bool {
  let tamanho: Int = string.length(palavra)
  let meio: Int = tamanho / 2
  case tamanho % 2 == 0 {
    True -> string.slice(palavra, 0, meio) == string.slice(palavra, meio, meio)
    False ->
      string.slice(palavra, 0, meio) == string.slice(palavra, meio + 1, meio)
      && string.slice(palavra, meio, 1) == "-"
  }
}

pub fn palavra_duplicada_examples() {
  check.eq(palavra_duplicada("mimi"), True)
  check.eq(palavra_duplicada("arara"), False)
  check.eq(palavra_duplicada("lero-lero"), True)
  check.eq(palavra_duplicada("bom-dia"), False)
  check.eq(palavra_duplicada("bombom"), True)
  check.eq(palavra_duplicada("hoje"), False)
}

/// Calcula o número de azulejos de 0,2mx0,2m necessários para azulejar uma
/// parede com tamanho *comprimento* x *altura* (em metros) considerando que
/// nenhum azulejo é perdido e que recortes são descartados.
/// *comprimento* e *largura* devem ser positivos.
pub fn numero_azulejos(comprimento: Float, altura: Float) -> Int {
  float.truncate(
    float.ceiling(comprimento /. 0.2) *. float.ceiling(altura /. 0.2),
  )
}

pub fn numero_azulejos_examples() {
  check.eq(numero_azulejos(3.0, 2.2), 165)
  check.eq(numero_azulejos(1.7, 2.5), 117)
  check.eq(numero_azulejos(0.2, 0.2), 1)
  check.eq(numero_azulejos(0.5, 0.2), 3)
  check.eq(numero_azulejos(0.3, 0.5), 6)
  check.eq(numero_azulejos(0.5, 0.5), 9)
  check.eq(numero_azulejos(0.0, 0.0), 0)
  check.eq(numero_azulejos(9.3, 14.2), 3337)
}

/// Produz uma string realizando o equivalente a *n* operações de move 1 a
/// direita, se *n* é não negativo, ou o equivalente a *-n* operações de move 1
/// a esquerda se *n* é negativo. Mover 1 à direita significa colocar o último
/// caractere de uma string no início da string. Mover 1 à esquerda significa
/// colocar o primeiro caractere de uma string no final da string
pub fn rotaciona_direita(s: String, n: Int) -> String {
  let tamanho: Int = string.length(s)
  let operacoes_modulo: Int = n % tamanho
  case operacoes_modulo >= 0 {
    True ->
      string.slice(s, tamanho - operacoes_modulo, operacoes_modulo)
      <> string.slice(s, 0, tamanho - operacoes_modulo)
    False ->
      string.slice(s, -operacoes_modulo, tamanho + operacoes_modulo)
      <> string.slice(s, 0, -operacoes_modulo)
  }
}

pub fn rotaciona_direita_examples() {
  check.eq(rotaciona_direita("marcelio", 5), "celiomar")
  check.eq(rotaciona_direita("abc", 0), "abc")
  check.eq(rotaciona_direita("abc", 1), "cab")
  check.eq(rotaciona_direita("abc", 2), "bca")
  check.eq(rotaciona_direita("abc", 3), "abc")
  check.eq(rotaciona_direita("abc", 7), "cab")
  check.eq(rotaciona_direita("abc", -1), "bca")
  check.eq(rotaciona_direita("abc", -2), "cab")
  check.eq(rotaciona_direita("abc", -3), "abc")
  check.eq(rotaciona_direita("abc", -8), "cab")
}

/// Adiciona um nono dígito em *telefone* (no caso, o número 9),
/// caso ele ainda não o tenha.
pub fn adiciona_nove(telefone: String) -> String {
  let tamanho_telefone = string.length(telefone)
  case tamanho_telefone == 14 {
    True ->
      string.slice(telefone, 0, 5)
      <> "9"
      <> string.slice(telefone, 5, tamanho_telefone - 5)
    False -> telefone
  }
}

pub fn adiciona_nove_examples() {
  check.eq(adiciona_nove("(44) 9787-1241"), "(44) 99787-1241")
  check.eq(adiciona_nove("(51) 95872-9989"), "(51) 95872-9989")
  check.eq(adiciona_nove("(41) 8876-1562"), "(41) 98876-1562")
}

/// Seleciona partes de *msg* para serem exibidas no momento *m* em um letreiro
/// que tem espaço para *tam* caracteres.
///
/// Se consideramos *s* sendo uma string com infinitas repetições de *msg*
/// separadas por espaço, então essa função produz uma resposta que é
/// equivalente a substring de s que começa na posição *m* e tem *tam*
/// caracteres.
///
/// Requer que a quantidade de caracteres de msg seja maior que tam.
pub fn msg_letreiro(tam: Int, msg: String, m: Int) -> String {
  let msg_dup = msg <> " " <> msg
  let inicio = m % { string.length(msg) + 1 }
  string.slice(msg_dup, inicio, tam)
}

pub fn msg_letreiro_examples() {
  check.eq(msg_letreiro(4, "Entrada", 0), "Entr")
  check.eq(msg_letreiro(4, "Entrada", 1), "ntra")
  check.eq(msg_letreiro(4, "Entrada", 2), "trad")
  check.eq(msg_letreiro(4, "Entrada", 3), "rada")
  check.eq(msg_letreiro(4, "Entrada", 4), "ada ")
  check.eq(msg_letreiro(4, "Entrada", 5), "da E")
  check.eq(msg_letreiro(4, "Entrada", 6), "a En")
  check.eq(msg_letreiro(4, "Entrada", 7), " Ent")
  check.eq(msg_letreiro(4, "Entrada", 8), "Entr")
  check.eq(msg_letreiro(4, "Entrada", 9), "ntra")
  check.eq(
    msg_letreiro(20, "Promoção de sorvetes, pague 2 leve 3!", 0),
    "Promoção de sorvetes",
  )
  check.eq(
    msg_letreiro(20, "Promoção de sorvetes, pague 2 leve 3!", 1),
    "romoção de sorvetes,",
  )
  check.eq(
    msg_letreiro(20, "Promoção de sorvetes, pague 2 leve 3!", 2),
    "omoção de sorvetes, ",
  )
  check.eq(
    msg_letreiro(20, "Promoção de sorvetes, pague 2 leve 3!", 17),
    "tes, pague 2 leve 3!",
  )
  check.eq(
    msg_letreiro(20, "Promoção de sorvetes, pague 2 leve 3!", 18),
    "es, pague 2 leve 3! ",
  )
  check.eq(
    msg_letreiro(20, "Promoção de sorvetes, pague 2 leve 3!", 19),
    "s, pague 2 leve 3! P",
  )
  check.eq(
    msg_letreiro(20, "Promoção de sorvetes, pague 2 leve 3!", 37),
    " Promoção de sorvete",
  )
}

/// Produz True se *n* tem 4 dígitos e é palíndromo, isto é, tem os mesmos
/// dígitos quando lido da direita para a esquerda ou da esquerda para a
/// direita. Produz False, caso contrário.
pub fn palindromo(n: Int) -> Bool {
  let unidade = n % 10
  let dezena = { n / 10 } % 10
  let centena = { n / 100 } % 10
  let milhar = { n / 1000 } % 10
  unidade == milhar && dezena == centena
}

pub fn palindromo_examples() {
  check.eq(palindromo(11), False)
  check.eq(palindromo(222), False)
  check.eq(palindromo(9119), True)
  check.eq(palindromo(1221), True)
  check.eq(palindromo(2006), False)
  check.eq(palindromo(21_112), False)
}

/// É possível modificar a sua função de maneira que ela funcione
/// para qualquer número de entrada e não apenas para números de 4 dígitos?
/// Sim, existem duas formas, construídas a partir de recursão, para tratar
/// qualquer número de entrada.
/// Inverte *n*, colocando os digitos a esquerda na direita e vice-versa.
/// Requer que o acumulador *novo_numero* seja 0.
pub fn inverte_numero(n: Int, novo_numero: Int) -> Int {
  case n == 0 {
    True -> novo_numero
    False -> inverte_numero(n / 10, novo_numero * 10 + n % 10)
  }
}

pub fn inverte_numero_examples() {
  check.eq(inverte_numero(26, 0), 62)
  check.eq(inverte_numero(9521, 0), 1259)
  check.eq(inverte_numero(145_789_652, 0), 256_987_541)
}

/// Produz True se *n* é palíndromo, isto é, tem os mesmos
/// dígitos quando lido da direita para a esquerda ou da esquerda para a
/// direita. Produz False, caso contrário.
pub fn eh_palindromo(n: Int) -> Bool {
  n == inverte_numero(n, 0)
}

pub fn eh_palindromo_examples() {
  check.eq(eh_palindromo(11), True)
  check.eq(eh_palindromo(90), False)
  check.eq(eh_palindromo(222), True)
  check.eq(eh_palindromo(252), True)
  check.eq(eh_palindromo(224), False)
  check.eq(eh_palindromo(9119), True)
  check.eq(eh_palindromo(1221), True)
  check.eq(eh_palindromo(2006), False)
  check.eq(eh_palindromo(21_112), True)
  check.eq(eh_palindromo(54_452), False)
}

/// Produz True se a string *n* representa um palíndromo,
/// ou seja, se seus caracteres são iguais quando lidos da esquerda
/// para a direita e da direita para a esquerda.
/// Caso contrário, produz False.
pub fn verifica_digitos(n: String) -> Bool {
  let tamanho = string.length(n)
  case tamanho {
    0 | 1 -> True
    _ ->
      string.slice(n, 0, 1) == string.slice(n, tamanho - 1, 1)
      && verifica_digitos(string.slice(n, 1, tamanho - 2))
  }
}

/// Produz True se *n* é palíndromo, isto é, tem os mesmos
/// dígitos quando lido da direita para a esquerda ou da esquerda para a
/// direita. Produz False, caso contrário.
pub fn eh_palindromo2(n: Int) -> Bool {
  verifica_digitos(int.to_string(n))
}

pub fn eh_palindromo2_examples() {
  check.eq(eh_palindromo2(11), True)
  check.eq(eh_palindromo2(90), False)
  check.eq(eh_palindromo2(222), True)
  check.eq(eh_palindromo2(252), True)
  check.eq(eh_palindromo2(224), False)
  check.eq(eh_palindromo2(9119), True)
  check.eq(eh_palindromo2(1221), True)
  check.eq(eh_palindromo2(2006), False)
  check.eq(eh_palindromo2(21_112), True)
  check.eq(eh_palindromo2(54_452), False)
}
