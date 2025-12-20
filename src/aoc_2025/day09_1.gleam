import gleam/int
import gleam/list
import gleam/string
import u

type Pos {
  Pos(x: Int, y: Int)
}

pub fn main(input: String) -> String {
  input
  |> parse_input
  |> get_all_rectangle_areas
  |> list.max(int.compare)
  |> u.ok
  |> int.to_string
}

fn parse_input(input: String) -> List(Pos) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    let assert Ok(#(x, y)) = line |> string.split_once(on: ",")

    Pos(x: x |> u.int, y: y |> u.int)
  })
}

fn get_all_rectangle_areas(positions: List(Pos)) -> List(Int) {
  positions
  |> list.combination_pairs
  |> list.map(fn(pair) {
    let #(a, b) = pair

    let width = int.absolute_value(b.x - a.x) + 1
    let height = int.absolute_value(b.y - a.y) + 1

    { width * height }
  })
}
