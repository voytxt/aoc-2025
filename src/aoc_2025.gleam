import day11_2
import gleam/io
import simplifile
import u

pub fn main() -> Nil {
  simplifile.read("input/day11.txt")
  |> u.ok
  |> day11_2.main
  |> io.println
}
