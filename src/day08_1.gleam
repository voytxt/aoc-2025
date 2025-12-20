import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string
import u

type Box {
  Box(x: Int, y: Int, z: Int)
}

type Edge =
  #(Box, Box)

type Circuit {
  Circuit(boxes: Set(Box))
}

pub fn main(input: String) -> String {
  input
  |> parse_input
  |> sort_edges_by_length
  |> list.take(1000)
  |> list.fold(from: [], with: add_edge_to_circuits)
  |> list.map(with: fn(circuit) { circuit.boxes |> set.size })
  |> list.sort(by: fn(a, b) { int.compare(b, a) })
  |> list.take(3)
  |> int.product
  |> int.to_string
}

fn parse_input(input: String) -> List(Edge) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    let assert [x, y, z] = line |> string.split(",") |> list.map(u.int)

    Box(x:, y:, z:)
  })
  |> list.combination_pairs
}

fn sort_edges_by_length(edges: List(Edge)) -> List(Edge) {
  edges
  |> list.map(fn(edge) {
    let #(a, b) = edge

    let d = Box(x: b.x - a.x, y: b.y - a.y, z: b.z - a.z)

    #(a, b, d.x * d.x + d.y * d.y + d.z * d.z)
  })
  |> list.sort(by: fn(a, b) { int.compare(a.2, b.2) })
  |> list.map(fn(pair) { #(pair.0, pair.1) })
}

fn add_edge_to_circuits(circuits: List(Circuit), edge: Edge) -> List(Circuit) {
  // try to find an existing circuit with one of the boxes from the given edge
  let #(circuit_adepts, remaining_circuits) = {
    list.partition(circuits, with: fn(circuit) {
      let a = circuit.boxes |> set.contains(edge.0)
      let b = circuit.boxes |> set.contains(edge.1)

      a || b
    })
  }

  case circuit_adepts {
    // the edge isn't in any circuit whatsoever, a new circuit has to be created
    [] -> {
      set.new()
      |> set.insert(edge.0)
      |> set.insert(edge.1)
      |> Circuit
      |> list.prepend(to: remaining_circuits)
    }

    // it's only in one circuit, we make sure to add the whole edge to it
    [Circuit(boxes)] -> {
      boxes
      |> set.insert(edge.0)
      |> set.insert(edge.1)
      |> Circuit
      |> list.prepend(to: remaining_circuits)
    }

    // the edge "connects" two circuits, so we combine them
    [Circuit(boxes_a), Circuit(boxes_b)] -> {
      set.union(boxes_a, boxes_b)
      |> Circuit
      |> list.prepend(to: remaining_circuits)
    }

    [_, _, _, ..] -> {
      panic as "An edge shouldn't be able to connect more than 2 circuits."
    }
  }
}
