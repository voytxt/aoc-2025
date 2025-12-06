import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import u

pub fn main(input: String) -> String {
  input
  |> string.split(on: ",")
  |> list.fold(from: 0, with: fn(sum, range) {
    let assert Ok(#(from, to)) = range |> string.split_once(on: "-")

    list.range(from |> u.int, to |> u.int)
    |> list.fold(from: 0, with: fn(acc, id) {
      let id_string = id |> int.to_string
      let length = id_string |> string.byte_size

      use <- bool.guard(when: length |> int.is_odd, return: acc)

      let part = id_string |> string.slice(at_index: 0, length: length / 2)

      case part <> part == id_string {
        True -> acc + id
        False -> acc
      }
    })
    |> int.add(sum)
  })
  |> int.to_string
}
