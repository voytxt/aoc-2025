import gleam/int
import gleam/list
import gleam/string

type State {
  State(dial: Int, password: Int)
}

pub fn main(input: String) -> String {
  let state =
    input
    |> string.split("\n")
    |> list.fold(
      from: State(dial: 50, password: 0),
      with: fn(state: State, rotation: String) {
        let assert [direction, ..distance] = rotation |> string.to_graphemes
        let assert Ok(distance) = distance |> string.join("") |> int.parse

        let assert Ok(dial) =
          case direction {
            "L" -> state.dial - distance
            "R" -> state.dial + distance
            _ -> panic
          }
          |> int.modulo(100)

        let password = case dial {
          0 -> state.password + 1
          _ -> state.password
        }

        State(dial:, password:)
      },
    )

  state.password |> int.to_string
}
