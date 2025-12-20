import gleam/int
import gleam/list
import gleam/string
import u

type State {
  State(dial: Int, password: Int)
}

pub fn main(input: String) -> String {
  let state = {
    input
    |> string.split("\n")
    |> list.fold(
      from: State(dial: 50, password: 0),
      with: fn(state: State, rotation: String) {
        let distance: Int = case rotation {
          "L" <> distance -> distance |> u.int |> int.negate
          "R" <> distance -> distance |> u.int
          _ -> panic
        }

        let dial: Int = { state.dial - distance } % 100

        let password: Int = case dial {
          0 -> state.password + 1
          _ -> state.password
        }

        State(dial:, password:)
      },
    )
  }

  state.password |> int.to_string
}
