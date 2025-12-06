import gleam/int
import gleam/list
import gleam/result
import gleam/string
import u

pub fn main(input: String) -> String {
  let #(operands, nums) = input |> parse_input

  list.map2(operands, nums, with: fn(operand, nums) {
    list.reduce(nums, with: fn(acc, num) {
      case operand {
        "+" -> acc + num
        "*" -> acc * num
        _ -> panic
      }
    })
    |> result.lazy_unwrap(fn() { panic })
  })
  |> list.fold(from: 0, with: int.add)
  |> int.to_string
}

fn parse_input(input: String) {
  let assert [operands, ..nums] = input |> string.split("\n") |> list.reverse

  let operands = operands |> string.split(" ") |> list.filter(fn(x) { x != "" })

  let nums: List(List(Int)) = {
    nums
    |> list.map(string.to_graphemes)
    |> list.transpose
    |> list.map(fn(num) {
      num |> string.join("") |> string.trim |> string.reverse
    })
    |> string.join(" ")
    |> string.split("  ")
    |> list.map(fn(nums) { nums |> string.split(" ") |> list.map(u.int) })
  }

  #(operands, nums)
}
