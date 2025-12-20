import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string

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

/// Dangerously converts a string to an integer.
/// Will panic if given an invalid input.
pub fn int(string: String) -> Int {
  case string |> int.parse {
    Ok(int) -> int
    Error(Nil) -> panic as { "Failed to parse " <> string <> " as int" }
  }
}

/// Counts the number of elements in a given set satisfying a given predicate.
pub fn set_count(in set: Set(a), where predicate: fn(a) -> Bool) -> Int {
  set |> set.filter(keeping: predicate) |> set.size
}

/// Unwraps a result. Panics when given an error.
pub fn ok(result: Result(a, b)) -> a {
  case result {
    Ok(a) -> a
    Error(_) -> panic as { "Failed to unwrap " <> result |> string.inspect }
  }
}

pub fn index_of(list: List(a), a: a) -> Int {
  list |> list.index_map(fn(x, i) { #(x, i) }) |> list.key_find(a) |> ok
}

// pub fn indexes_of(list: List(a), a: a) -> List(Int) {
//   list |> list.index_map(fn(x, i) { #(x, i) }) |> list.key_filter(a)
// }

/// Runs a callback on `a` from `Result(a, Nil)`.
///
/// ## Examples
///
/// ```gleam
/// let input: Result(Int, Nil) = Ok(5)
/// use num <- return_on_error(input, "no number")
/// "you picked " <> num
/// ...
/// // -> "you picked 5"
/// ```
pub fn return_on_error(
  result: Result(a, Nil),
  return on_error: b,
  otherwise on_ok: fn(a) -> b,
) -> b {
  case result {
    Ok(a) -> on_ok(a)
    Error(Nil) -> on_error
  }
}
