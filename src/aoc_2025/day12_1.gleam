import gleam/int
import gleam/list
import gleam/string
import u

pub fn main(input: String) -> String {
  input
  |> string.split("\n")
  |> list.count(is_line_valid)
  |> int.to_string
}

fn is_line_valid(line: String) -> Bool {
  use line <- u.return_on_error(line |> string.split_once(": "), return: False)
  let region = line.0 |> string.split("x") |> list.map(u.int) |> int.product
  let block_count = line.1 |> string.split(" ") |> list.map(u.int) |> int.sum

  block_count * 8 <= region
}
