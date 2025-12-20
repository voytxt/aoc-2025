import gleam/int
import gleam/list
import gleam/string
import u

type State {
  State(dial: Int, password: Int)
}

type Direction {
  Left
  Right
}

pub fn main(input: String) -> String {
  let state = {
    input
    |> string.split("\n")
    |> list.fold(
      from: State(dial: 50, password: 0),
      with: fn(state: State, rotation: String) {
        let #(direction, distance) = case rotation {
          "L" <> distance -> #(Left, distance |> u.int)
          "R" <> distance -> #(Right, distance |> u.int)
          _ -> panic
        }

        state |> apply_rotation(direction:, distance:)
      },
    )
  }

  state.password |> int.to_string
}

fn apply_rotation(
  state: State,
  direction direction: Direction,
  distance distance: Int,
) -> State {
  case distance {
    0 -> state

    _ -> {
      let dial: Int = case direction {
        Left -> { state.dial - 1 } % 100
        Right -> { state.dial + 1 } % 100
      }

      let password: Int = case dial {
        0 -> state.password + 1
        _ -> state.password
      }

      State(dial:, password:)
      |> apply_rotation(direction:, distance: distance - 1)
    }
  }
}
