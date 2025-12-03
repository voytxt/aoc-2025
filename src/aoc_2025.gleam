import day03_2
import gleam/io
import simplifile

pub fn main() -> Nil {
  let assert Ok(input) = simplifile.read("input/day03.txt")

  input |> day03_2.main |> io.println

  Nil
}
