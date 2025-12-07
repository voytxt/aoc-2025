import day07_2
import gleam/io
import simplifile
import u

pub fn main() -> Nil {
  simplifile.read("input/day07.txt")
  |> u.ok
  |> day07_2.main
  |> io.println
}
