import gleam/int
import gleam/list
import gleam/string
import u

type Range {
  Range(from: Int, to: Int)
}

/// A list of non-overlapping ranges.
type UniqueRanges {
  UniqueRanges(list: List(Range))
}

pub fn main(input: String) -> String {
  input
  |> parse_input
  |> remove_overlaps
  |> count_ingredients
  |> int.to_string
}

fn parse_input(input: String) -> List(Range) {
  input
  |> string.split("\n")
  |> list.take_while(fn(line) { line != "" })
  |> list.map(fn(range: String) {
    let assert Ok(#(from, to)) = range |> string.split_once(on: "-")

    Range(from: from |> u.int, to: to |> u.int)
  })
}

/// We make sure to merge as many ranges as possible, that means that in the end,
/// the interval won't have any overlaps whatsoever.
fn remove_overlaps(ranges: List(Range)) -> UniqueRanges {
  ranges |> list.fold(from: UniqueRanges([]), with: add_new_range)
}

fn add_new_range(unique_ranges: UniqueRanges, range: Range) -> UniqueRanges {
  // grab all ranges that overlap with the range we want to add
  let #(unique_ranges, overlapping_ranges) = {
    unique_ranges |> remove_overlapping_ranges(range)
  }

  // merge the overlapping ranges with out range
  range
  |> merge_with(overlapping_ranges:)
  |> list.prepend(to: unique_ranges.list)
  |> UniqueRanges
}

/// Removes all ranges in the interval, which overlap with the given range.
fn remove_overlapping_ranges(
  interval: UniqueRanges,
  range: Range,
) -> #(UniqueRanges, List(Range)) {
  let #(remove, keep) = {
    list.partition(interval.list, with: does_overlap(range, _))
  }

  #(UniqueRanges(keep), remove)
}

fn does_overlap(a: Range, b: Range) -> Bool {
  // a:  x----x
  // b:     x-----
  let x = a.from <= b.from && b.from <= a.to

  // a:       x-----
  // b:    x----x
  let y = b.from <= a.from && a.from <= b.to

  x || y
}

fn merge_with(
  range: Range,
  overlapping_ranges overlapping_ranges: List(Range),
) -> Range {
  list.fold(over: overlapping_ranges, from: range, with: fn(a, b) {
    let from = int.min(a.from, b.from)
    let to = int.max(a.to, b.to)

    Range(from:, to:)
  })
}

fn count_ingredients(ranges: UniqueRanges) -> Int {
  list.fold(over: ranges.list, from: 0, with: fn(acc, range) {
    acc + { range.to - range.from + 1 }
  })
}
