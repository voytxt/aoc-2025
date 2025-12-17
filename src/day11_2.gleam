import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string
import u

type Rack {
  Rack(devices: Dict(String, List(String)))
}

pub fn main(input: String) -> String {
  let rack = input |> parse_input

  let svr_fft_dac_out = {
    count_paths(rack, from: "svr", to: "fft")
    * count_paths(rack, from: "fft", to: "dac")
    * count_paths(rack, from: "dac", to: "out")
  }

  let svr_dac_fft_out = {
    count_paths(rack, from: "svr", to: "dac")
    * count_paths(rack, from: "dac", to: "fft")
    * count_paths(rack, from: "fft", to: "out")
  }

  int.to_string(svr_fft_dac_out + svr_dac_fft_out)
}

fn parse_input(input: String) -> Rack {
  input
  |> string.split(on: "\n")
  |> list.fold(from: dict.new() |> dict.insert("out", []), with: fn(dict, line) {
    let assert Ok(#(device, outputs)) = line |> string.split_once(": ")

    dict |> dict.insert(for: device, insert: outputs |> string.split(" "))
  })
  |> Rack
}

fn count_paths(rack: Rack, from from: String, to to: String) -> Int {
  count_paths_loop(rack, from:, to:, memo: dict.new()).1
}

/// Memo saves the number of paths betwen 2 points. Returns memo and count.
fn count_paths_loop(
  rack: Rack,
  from from: String,
  to to: String,
  memo memo: Dict(#(String, String), Int),
) -> #(Dict(#(String, String), Int), Int) {
  use <- bool.guard(when: from == to, return: #(memo, 1))

  case memo |> dict.get(#(from, to)) {
    Ok(count) -> #(memo, count)

    Error(Nil) -> {
      let #(memo, count) =
        rack.devices
        |> dict.get(from)
        |> u.ok
        |> list.fold(from: #(memo, 0), with: fn(acc, output) {
          let #(acc_memo, acc_count) = acc

          let #(memo, count) =
            rack |> count_paths_loop(from: output, to:, memo: acc_memo)

          #(memo, acc_count + count)
        })

      let memo = memo |> dict.insert(for: #(from, to), insert: count)

      #(memo, count)
    }
  }
}
