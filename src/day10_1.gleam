import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import u

/// A button that toggles the lights, with specified indexes.
type Button {
  Button(lights: List(Int))
}

type Light {
  On
  Off
}

/// We start with all lights in the given state (from input).
/// Goal: All lights turned off.
type Machine {
  Machine(lights: List(Light), buttons: List(Button))
}

pub fn main(input: String) -> String {
  input
  |> parse_input
  |> list.map(solve_machine)
  |> list.fold(from: 0, with: int.add)
  |> int.to_string
}

type ParsingState {
  Idle
  InsideLights(lights: List(Light))
  InsideSchematics(wiring: String)
  InsideJoltage
}

fn parse_input(input: String) -> List(Machine) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.to_graphemes
    |> list.fold(from: #(Machine([], []), Idle), with: fn(acc, char) {
      let #(machine, state) = acc

      case state, char {
        Idle, "[" -> #(machine, InsideLights([]))
        Idle, "(" -> #(machine, InsideSchematics(""))
        Idle, "{" -> #(machine, InsideJoltage)
        Idle, _ -> acc

        InsideLights(lights:), "#" -> #(
          machine,
          InsideLights(lights: lights |> list.append([On])),
        )
        InsideLights(lights:), "." -> #(
          machine,
          InsideLights(lights: lights |> list.append([Off])),
        )
        InsideLights(lights:), "]" -> #(Machine(..machine, lights:), Idle)
        InsideLights(_), _ -> panic

        InsideSchematics(wiring:), ")" -> {
          let wiring = wiring |> string.split(",") |> list.map(u.int) |> Button

          #(
            Machine(..machine, buttons: machine.buttons |> list.prepend(wiring)),
            Idle,
          )
        }
        InsideSchematics(wiring:), char -> #(
          machine,
          InsideSchematics(wiring <> char),
        )

        InsideJoltage, "}" -> #(machine, Idle)
        InsideJoltage, _ -> acc
      }
    })
  })
  |> list.map(pair.first)
}

fn solve_machine(machine: Machine) -> Int {
  [machine] |> solve_machines_loop(0)
}

fn solve_machines_loop(machines: List(Machine), press_count: Int) -> Int {
  case machines |> list.any(is_solved) {
    // if it's solved, return number of the steps
    True -> press_count

    // if it's not solved, press all the buttons and try again
    False -> {
      machines
      |> list.flat_map(try_to_press_all_buttons)
      |> solve_machines_loop(press_count + 1)
    }
  }
}

fn try_to_press_all_buttons(machine: Machine) -> List(Machine) {
  machine.buttons
  |> list.map(fn(button) {
    Machine(..machine, lights: machine.lights |> press_button(button))
  })
}

fn press_button(lights: List(Light), button: Button) -> List(Light) {
  list.index_map(lights, with: fn(light, index) {
    case button.lights |> list.contains(index) {
      True -> light |> toggle_light
      False -> light
    }
  })
}

fn toggle_light(light: Light) -> Light {
  case light {
    Off -> On
    On -> Off
  }
}

fn is_solved(machine: Machine) -> Bool {
  list.all(in: machine.lights, satisfying: fn(light) { light == Off })
}
