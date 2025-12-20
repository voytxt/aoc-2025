import gleam/int
import gleam/list
import gleam/string
import u

pub fn main(input: String) -> String {
  let #(operands, nums) = input |> parse_input

  list.map2(operands, nums, with: fn(operand, nums) {
    case operand {
      "+" -> nums |> int.sum
      "*" -> nums |> int.product
      _ -> panic as "Unknown operand."
    }
  })
  |> int.sum
  |> int.to_string
}

fn parse_input(input: String) {
  let assert [operands, ..nums] = input |> string.split("\n") |> list.reverse

  let operands = operands |> split_on_spaces

  let nums: List(List(Int)) = {
    nums
    |> list.map(fn(row) { row |> split_on_spaces |> list.map(u.int) })
    |> list.transpose
  }

  #(operands, nums)
}

fn split_on_spaces(string: String) -> List(String) {
  string |> string.split(" ") |> list.filter(fn(x) { x != "" })
}
