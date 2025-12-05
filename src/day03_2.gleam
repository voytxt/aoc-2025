import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import u

type Bank {
  Bank(batteries: List(Int))
}

pub fn main(input: String) -> String {
  input
  |> parse_input
  |> list.fold(from: 0, with: fn(acc, bank) { acc + find_largest_dozen(bank) })
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

fn find_largest_dozen(bank: Bank) -> Int {
  bank |> find_largest_dozen_loop([])
}

fn find_largest_dozen_loop(bank: Bank, dozen: List(Int)) -> Int {
  let dozen_length = dozen |> list.length

  use <- bool.guard(when: dozen_length > 11, return: dozen |> sum_batteries)

  let bank_length = bank.batteries |> list.length

  let batteries_missing_in_dozen = 12 - dozen_length

  // we have run into a situation, where there's not enough batteries to make anything
  use <- bool.guard(when: bank_length < batteries_missing_in_dozen, return: 0)

  let #(batteries_to_pick_from, rest_batteries): #(List(Int), List(Int)) =
    bank.batteries
    |> list.split(at: bank_length - batteries_missing_in_dozen + 1)

  let largest_battery: Int =
    batteries_to_pick_from
    |> list.max(with: int.compare)
    |> result.lazy_unwrap(fn() { panic })

  let assert #(_, [picked_battery, ..batteries_left]) =
    batteries_to_pick_from
    |> list.split_while(fn(battery) { battery < largest_battery })

  assert largest_battery == picked_battery

  let dozen = dozen |> list.append([picked_battery])

  batteries_left
  |> list.append(rest_batteries)
  |> Bank
  |> find_largest_dozen_loop(dozen)
}

fn sum_batteries(batteries: List(Int)) {
  list.fold(batteries, from: 0, with: fn(acc, battery) { acc * 10 + battery })
}
