import day06_2
import gleam/io
import simplifile

pub fn main() -> Nil {
  let assert Ok(input) = simplifile.read("input/day06.txt")

  input |> day06_2.main |> io.println

  Nil
}
