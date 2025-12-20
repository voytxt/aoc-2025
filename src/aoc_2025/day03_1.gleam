import gleam/int
import gleam/list
import gleam/string
import u

type Bank {
  Bank(batteries: List(Int))
}

pub fn main(input: String) -> String {
  input
  |> parse_input
  |> list.fold(from: 0, with: fn(acc, bank) { acc + find_largest_pair(bank) })
  |> int.to_string
}

fn parse_input(input: String) -> List(Bank) {
  input
  |> string.split("\n")
  |> list.map(fn(bank) {
    bank
    |> string.to_graphemes
    |> list.map(u.int)
    |> Bank
  })
}

fn find_largest_pair(bank: Bank) -> Int {
  bank.batteries
  |> list.combination_pairs
  |> list.map(fn(pair) { pair.0 * 10 + pair.1 })
  |> list.max(with: int.compare)
  |> u.ok
}
