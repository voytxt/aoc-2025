import day02_2
import gleam/io
import simplifile

pub fn main() -> Nil {
  let assert Ok(input) = simplifile.read("input/day02.txt")

  input |> day02_2.main |> io.println

  Nil
}
