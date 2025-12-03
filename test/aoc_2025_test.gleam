import day01_1
import day01_2
import day02_1
import day02_2
import day03_1
import day03_2
import gleeunit
import simplifile

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn day01_test() {
  let assert Ok(input) = simplifile.read("input/day01.txt")
  assert input |> day01_1.main == "1123"
  assert input |> day01_2.main == "6695"
}

pub fn day02_test() {
  let assert Ok(input) = simplifile.read("input/day02.txt")
  assert input |> day02_1.main == "24043483400"
  assert input |> day02_2.main == "38262920235"
}

pub fn day03_test() {
  let assert Ok(input) = simplifile.read("input/day03.txt")
  assert input |> day03_1.main == "17085"
  assert input |> day03_2.main == "169408143086082"
}
