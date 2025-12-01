import day01_2
import gleam/io
import simplifile

pub fn main() -> Nil {
  let assert Ok(input) = simplifile.read("input.txt")

  input |> day01_2.main |> io.println

  Nil
}
