import day05_2
import gleam/io
import simplifile

pub fn main() -> Nil {
  let assert Ok(input) = simplifile.read("input/day05.txt")

  input |> day05_2.main |> io.println

  Nil
}
