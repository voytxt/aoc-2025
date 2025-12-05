import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string
import u

type Position {
  Position(i: Int, j: Int)
}

pub fn main(input: String) -> String {
  let all_rolls_positions: Set(Position) = input |> parse_input

  u.set_count(in: all_rolls_positions, where: fn(pos) {
    count_adjacent(all_rolls_positions, pos) < 4
  })
  |> int.to_string
}

fn parse_input(input: String) -> Set(Position) {
  let lines = input |> string.split("\n")

  list.index_fold(over: lines, from: set.new(), with: fn(set, row, i) {
    let row: List(String) = row |> string.to_graphemes

    list.index_fold(over: row, from: set, with: fn(set, char, j) {
      case char {
        "@" -> set |> set.insert(Position(i:, j:))
        "." -> set
        _ -> panic as { "Uknown char: " <> char }
      }
    })
  })
}

fn count_adjacent(all_rolls_positions: Set(Position), pos: Position) -> Int {
  list.count(u.offsets, where: fn(offset) {
    all_rolls_positions
    |> set.contains(Position(i: pos.i + offset.0, j: pos.j + offset.1))
  })
}
