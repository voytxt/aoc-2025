import day09_2
import gleam/io
import simplifile
import u

pub fn main() -> Nil {
  simplifile.read("input/day09.txt")
  |> u.ok
  |> day09_2.main
  |> io.println
}
