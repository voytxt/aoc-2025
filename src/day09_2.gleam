import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import u

///
///   A
///   | ....
/// y | ....
///   o----->
///       x
///
type Pos {
  Pos(x: Int, y: Int)
}

/// a & b are corners
type Rectange {
  Rectangle(a: Pos, b: Pos, area: Int)
}

/// Horizontal edge:
/// x----x
///
/// Vertical edge:
/// x
/// |
/// |
/// x
type Edge {
  HorizontalEdge(x: #(Int, Int), y: Int)
  VerticalEdge(x: Int, y: #(Int, Int))
}

pub fn main(input: String) -> String {
  let input = input |> parse_input

  let rectangles = input |> get_all_rectangles_sorted_by_area
  let edges = input |> get_all_edges

  get_first_valid_area(rectangles, edges) |> int.to_string
}

fn parse_input(input: String) -> List(Pos) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    let assert Ok(#(x, y)) = line |> string.split_once(on: ",")

    Pos(x: x |> u.int, y: y |> u.int)
  })
}

fn get_all_rectangles_sorted_by_area(positions: List(Pos)) -> List(Rectange) {
  positions
  |> list.combination_pairs
  |> list.map(fn(pair) {
    let #(a, b) = pair

    let width = int.absolute_value(b.x - a.x) + 1
    let height = int.absolute_value(b.y - a.y) + 1

    Rectangle(a:, b:, area: width * height)
  })
  |> list.sort(by: fn(a, b) { int.compare(b.area, a.area) })
}

fn get_all_edges(corners: List(Pos)) -> List(Edge) {
  // window_by_2 doesn't window the last and first element,
  // so we add this pairing manually
  [corners |> list.last |> u.ok, ..corners]
  |> list.window_by_2
  |> list.map(fn(pair) {
    let #(a, b): #(Pos, Pos) = pair

    case a, b {
      Pos(x1, y1), Pos(x2, y2) if x1 == x2 -> VerticalEdge(x: x1, y: #(y1, y2))
      Pos(x1, y1), Pos(x2, y2) if y1 == y2 ->
        HorizontalEdge(x: #(x1, x2), y: y1)
      _, _ -> panic
    }
  })
}

fn get_first_valid_area(rectangles: List(Rectange), edges: List(Edge)) -> Int {
  let assert [rectangle, ..rectangles] = rectangles
    as "There should be at least one valid rectangle."

  case rectangle |> is_valid(edges) {
    True -> rectangle.area
    False -> get_first_valid_area(rectangles, edges)
  }
}

/// A rectangle is only valid if no edges of our big shape intersect with it.
/// Note that if the rectangle ends right on the edge, it's fine!
fn is_valid(rectangle: Rectange, edges: List(Edge)) -> Bool {
  let rectangle_left_x = int.min(rectangle.a.x, rectangle.b.x)
  let rectangle_right_x = int.max(rectangle.a.x, rectangle.b.x)
  let rectangle_bottom_y = int.min(rectangle.a.y, rectangle.b.y)
  let rectangle_top_y = int.max(rectangle.a.y, rectangle.b.y)

  // is there any edge that intersects?
  edges
  |> list.any(fn(edge) {
    // if the edge intersects our rectangle, it's invalid!
    case edge {
      //
      //        ----b
      //       |    |
      //  e--- |    | --- e
      //       |    |
      //       a----
      HorizontalEdge(_, _) -> {
        let edge_left_x = int.min(edge.x.0, edge.x.1)
        let edge_right_x = int.max(edge.x.0, edge.x.1)

        let does_intersect_x = {
          edge_left_x < rectangle_right_x && edge_right_x > rectangle_left_x
        }

        let does_intersect_y = {
          rectangle_bottom_y < edge.y && edge.y < rectangle_top_y
        }

        does_intersect_x && does_intersect_y
      }

      //   e
      //   |
      //  ----b
      // |    |
      // |    |
      // a----
      //   |
      //   e
      VerticalEdge(_, _) -> {
        let edge_bottom_y = int.min(edge.y.0, edge.y.1)
        let edge_top_y = int.max(edge.y.0, edge.y.1)

        let does_intersect_x = {
          rectangle_left_x < edge.x && edge.x < rectangle_right_x
        }

        let does_intersect_y = {
          edge_bottom_y < rectangle_top_y && edge_top_y > rectangle_bottom_y
        }

        does_intersect_x && does_intersect_y
      }
    }
  })
  // if there is an edge that intersects, it's not valid and we return false!
  |> bool.negate
}
