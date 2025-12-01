import gleam/int

pub fn int(string: String) -> Int {
  case string |> int.parse {
    Ok(int) -> int
    Error(Nil) -> panic as { "Couldn't parse " <> string <> " as int" }
  }
}
