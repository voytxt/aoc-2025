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
      use <- bool.guard(when: id < 10, return: acc)

      let id_string = id |> int.to_string
      let length = id_string |> string.byte_size

      let is_invalid = {
        list.range(from: 1, to: length / 2)
        |> list.any(satisfying: fn(sequence_length) {
          use <- bool.guard(when: length % sequence_length != 0, return: False)

          id_string
          |> string.slice(at_index: 0, length: sequence_length)
          |> string.repeat(times: length / sequence_length)
          == id_string
        })
      }

      case is_invalid {
        True -> acc + id
        False -> acc
      }
    })
    |> int.add(sum)
  })
  |> int.to_string
}
