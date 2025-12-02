import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import u

pub fn main(input: String) -> String {
  input
  |> string.split(",")
  |> list.fold(from: 0, with: fn(gacc, range) {
    let assert Ok(#(from, to)) = range |> string.split_once("-")

    list.range(from |> u.int, to |> u.int)
    |> list.fold(from: 0, with: fn(acc, id) {
      case id |> is_valid {
        False -> acc + id
        True -> acc
      }
    })
    |> int.add(gacc)
  })
  |> int.to_string
}

fn is_valid(id: Int) -> Bool {
  let id = id |> int.to_string
  let length = id |> string.length

  use <- bool.guard(when: length % 2 != 0, return: True)

  let first_part = id |> string.slice(at_index: 0, length: length / 2)
  let last_part = id |> string.slice(at_index: length / 2, length: length / 2)

  first_part != last_part
}
