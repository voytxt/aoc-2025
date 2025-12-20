import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string
import u

type Row {
  Row(splitters: Set(Int))
}

type Grid {
  Grid(rows: List(Row))
}

type State {
  State(beams: Set(Int), split_count: Int)
}

pub fn main(input: String) -> String {
  let #(beams, grid) = input |> parse_input
  let state = State(beams:, split_count: 0) |> simulate_row(grid)

  state.split_count |> int.to_string
}

fn parse_input(input: String) -> #(Set(Int), Grid) {
  let assert [first_line, ..rest] = input |> string.split("\n")

  let beams: Set(Int) =
    first_line
    |> string.to_graphemes
    |> u.index_of("S")
    |> list.wrap
    |> set.from_list

  let grid: Grid =
    list.fold(
      over: rest,
      from: Grid(rows: []),
      with: fn(grid: Grid, line: String) {
        let row = {
          line
          |> string.to_graphemes
          |> list.index_fold(from: Row(set.new()), with: fn(row, char, i) {
            case char {
              "^" -> row.splitters |> set.insert(i) |> Row
              "." -> row
              _ -> panic
            }
          })
        }

        case row.splitters |> set.is_empty {
          True -> grid
          False -> grid.rows |> list.append([row]) |> Grid
        }
      },
    )

  #(beams, grid)
}

fn simulate_row(state: State, grid: Grid) -> State {
  case grid.rows {
    [] -> state

    [current_row, ..remaining_rows] -> {
      set.fold(
        over: state.beams,
        from: State(..state, beams: set.new()),
        with: fn(state: State, beam: Int) {
          case current_row.splitters |> set.contains(beam) {
            // no splitter, re-add the beam
            False -> State(..state, beams: state.beams |> set.insert(beam))

            // yes splitter!
            True ->
              State(
                beams: state.beams
                  |> set.insert(beam - 1)
                  |> set.insert(beam + 1),
                split_count: state.split_count + 1,
              )
          }
        },
      )
      |> simulate_row(Grid(rows: remaining_rows))
    }
  }
}
