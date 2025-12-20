import gleam/int
import gleam/list
import gleam/string
import u

type Range {
  Range(from: Int, to: Int)
}

pub fn main(input: String) -> String {
  let #(ranges, ingredients) = input |> parse_input

  list.count(ingredients, where: fn(ingredient) {
    list.any(in: ranges, satisfying: is_in_range(ingredient, _))
  })
  |> int.to_string
}

fn parse_input(input: String) -> #(List(Range), List(Int)) {
  let assert Ok(#(ranges, ingredients)) = input |> string.split_once(on: "\n\n")

  let ranges: List(Range) = {
    ranges
    |> string.split(on: "\n")
    |> list.map(fn(range: String) {
      let assert Ok(#(from, to)) = range |> string.split_once(on: "-")

      Range(from: from |> u.int, to: to |> u.int)
    })
  }

  let ingredients: List(Int) = {
    ingredients |> string.split(on: "\n") |> list.map(u.int)
  }

  #(ranges, ingredients)
}

fn is_in_range(ingredient: Int, range: Range) {
  ingredient >= range.from && ingredient <= range.to
}
