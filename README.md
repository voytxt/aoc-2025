# Advent of Code in Gleam

## Solved problems

Click on the ✅s to view the code for each day!

|     | 2025                                                                  |
| :-: | --------------------------------------------------------------------- |
|  1  | [✅](./src/aoc_2025/day01_1.gleam) [✅](./src/aoc_2025/day01_2.gleam) |
|  2  | [✅](./src/aoc_2025/day02_1.gleam) [✅](./src/aoc_2025/day02_2.gleam) |
|  3  | [✅](./src/aoc_2025/day03_1.gleam) [✅](./src/aoc_2025/day03_2.gleam) |
|  4  | [✅](./src/aoc_2025/day04_1.gleam) [✅](./src/aoc_2025/day04_2.gleam) |
|  5  | [✅](./src/aoc_2025/day05_1.gleam) [✅](./src/aoc_2025/day05_2.gleam) |
|  6  | [✅](./src/aoc_2025/day06_1.gleam) [✅](./src/aoc_2025/day06_2.gleam) |
|  7  | [✅](./src/aoc_2025/day07_1.gleam) [✅](./src/aoc_2025/day07_2.gleam) |
|  8  | [✅](./src/aoc_2025/day08_1.gleam) [✅](./src/aoc_2025/day08_2.gleam) |
|  9  | [✅](./src/aoc_2025/day09_1.gleam) [✅](./src/aoc_2025/day09_2.gleam) |
| 10  | [✅](./src/aoc_2025/day10_1.gleam)                                    |
| 11  | [✅](./src/aoc_2025/day11_1.gleam) [✅](./src/aoc_2025/day11_2.gleam) |
| 12  | [✅](./src/aoc_2025/day12_1.gleam)                                    |

## Running

First create `src/aoc.gleam` to run a specific day and then run `gleam run`. This is for example how I would run day 11 part 2:

```gleam
import aoc_2025/day11_2
import gleam/io
import simplifile
import u

pub fn main() -> Nil {
  "input/day11.txt"
  |> simplifile.read
  |> u.ok
  |> day11_2.main
  |> io.println
}
```
