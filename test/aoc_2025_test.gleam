import day01_1
import day01_2
import day02_1
import day02_2
import day03_1
import day03_2
import day04_1
import day05_1
import day05_2
import day06_1
import day06_2
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

pub fn day04_test() {
  let assert Ok(input) = simplifile.read("input/day04.txt")
  assert input |> day04_1.main == "1449"
  // assert input |> day04_2.main == "8746"
}

pub fn day05_test() {
  let assert Ok(input) = simplifile.read("input/day05.txt")
  assert input |> day05_1.main == "635"
  assert input |> day05_2.main == "369761800782619"
}

pub fn day06_test() {
  let assert Ok(input) = simplifile.read("input/day06.txt")
  assert input |> day06_1.main == "8108520669952"
  assert input |> day06_2.main == "11708563470209"
}
