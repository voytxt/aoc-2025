import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string
import u

type Rack {
  Rack(devices: Dict(String, List(String)))
}

pub fn main(input: String) -> String {
  input |> parse_input |> count_paths_to_out(from: "you") |> int.to_string
}

fn parse_input(input: String) -> Rack {
  input
  |> string.split(on: "\n")
  |> list.fold(from: dict.new(), with: fn(dict, line) {
    let assert Ok(#(device, outputs)) = line |> string.split_once(": ")

    dict |> dict.insert(for: device, insert: outputs |> string.split(" "))
  })
  |> Rack
}

fn count_paths_to_out(rack: Rack, from from: String) {
  case from {
    "out" -> 1

    _ -> {
      rack.devices
      |> dict.get(from)
      |> u.ok
      |> list.fold(from: 0, with: fn(acc, output) {
        rack |> count_paths_to_out(from: output) |> int.add(acc)
      })
    }
  }
}
