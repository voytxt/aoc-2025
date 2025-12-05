import gleam/int
import gleam/set.{type Set}

pub const offsets = [
  #(-1, -1),
  #(-1, 0),
  #(-1, 1),
  #(0, -1),
  #(0, 1),
  #(1, -1),
  #(1, 0),
  #(1, 1),
]

/// Dangerously converts a string to an integer. Will panick if given
/// an invalid input.
pub fn int(string: String) -> Int {
  case string |> int.parse {
    Ok(int) -> int
    Error(Nil) -> panic as { "Couldn't parse " <> string <> " as int" }
  }
}

/// Counts the number of elements in a given set satisfying a given predicate.
pub fn set_count(in set: Set(a), where predicate: fn(a) -> Bool) -> Int {
  set |> set.filter(keeping: predicate) |> set.size
}
