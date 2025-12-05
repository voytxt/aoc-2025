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

  use <- bool.guard(when: length == 1, return: True)

  let id: List(String) = id |> string.to_graphemes

  // go though all possible sequence lengths
  list.all(list.range(1, length / 2), fn(sequence_length) {
    let assert [first, ..rest] = id |> list.sized_chunk(into: sequence_length)

    rest |> list.any(fn(x) { x != first })
  })
}
