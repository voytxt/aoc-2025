import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
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
  // key = index (just "beam" in part 1)
  // value = count
  State(beams: Dict(Int, Int), timeline_count: Int)
}

pub fn main(input: String) -> String {
  let #(beams, grid) = input |> parse_input
  let state = State(beams:, timeline_count: 1) |> simulate_row(grid)

  state.timeline_count |> int.to_string
}

fn parse_input(input: String) -> #(Dict(Int, Int), Grid) {
  let assert [first_line, ..rest] = input |> string.split("\n")

  let beam: Int =
    first_line
    |> string.to_graphemes
    |> u.index_of("S")

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

  #(dict.from_list([#(beam, 1)]), grid)
}

fn simulate_row(state: State, grid: Grid) -> State {
  case grid.rows {
    [] -> state

    [current_row, ..remaining_rows] -> {
      dict.fold(
        over: state.beams,
        from: State(..state, beams: dict.new()),
        with: fn(state: State, beam: Int, count: Int) {
          case current_row.splitters |> set.contains(beam) {
            // no splitter, re-add the beams
            False ->
              State(..state, beams: state.beams |> add_beam(beam, count: count))

            // yes splitter!
            True ->
              State(
                beams: state.beams
                  |> add_beam(beam - 1, count:)
                  |> add_beam(beam + 1, count:),
                timeline_count: state.timeline_count + count,
              )
          }
        },
      )
      |> simulate_row(Grid(rows: remaining_rows))
    }
  }
}

fn add_beam(dict: Dict(Int, Int), beam: Int, count count: Int) -> Dict(Int, Int) {
  dict.upsert(in: dict, update: beam, with: fn(dict_count) {
    case dict_count {
      Some(dict_count) -> dict_count + count
      None -> count
    }
  })
}
