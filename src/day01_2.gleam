import gleam/int
import gleam/list
import gleam/string

type State {
  State(dial: Int, password: Int)
}

type Direction {
  Left
  Right
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

        let direction = case direction {
          "L" -> Left
          "R" -> Right
          _ -> panic
        }

        state |> apply_rotation(direction:, distance:)
      },
    )

  state.password |> int.to_string
}

fn apply_rotation(
  state state: State,
  direction direction: Direction,
  distance distance: Int,
) -> State {
  case distance {
    0 -> state
    _ -> {
      let assert Ok(dial) =
        case direction {
          Left -> state.dial - 1
          Right -> state.dial + 1
        }
        |> int.modulo(100)

      let password = case dial {
        0 -> state.password + 1
        _ -> state.password
      }

      apply_rotation(
        state: State(dial:, password:),
        direction:,
        distance: distance - 1,
      )
    }
  }
}
