import day10_1
import gleam/io
import simplifile
import u

pub fn main() -> Nil {
  simplifile.read("input/day10.txt")
  |> u.ok
  |> day10_1.main
  |> io.println
}
