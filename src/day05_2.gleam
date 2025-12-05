import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import u

type Interval {
  Interval(ranges: List(Range))
}

type Range {
  Range(from: Int, to: Int)
}

pub fn main(input: String) -> String {
  input
  |> parse_input
  |> combine_ranges
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

/// We make sure to combine as many ranges as possible, that means that in the end,
/// the interval won't have any overlaps whatsoever.
fn combine_ranges(ranges: List(Range)) -> Interval {
  ranges |> list.fold(from: Interval(ranges: []), with: add_new_range)
}

fn add_new_range(interval: Interval, range: Range) -> Interval {
  // the range is completely enclosed in our interval already, we can discard it
  // this check is actually redundant as well, but whatever
  use <- bool.guard(when: is_range_redundant(interval, range), return: interval)

  // this range is completely new, meaning that it doesn't overlap
  // with anything, so we can just add it
  use <- bool.guard(
    when: is_range_completely_new(interval, range),
    return: Interval(ranges: [range, ..interval.ranges]),
  )

  // this range overlaps with our interval, so we need to combine them all into a single one

  // 1. remove all overlapping ranges from the interval
  let #(interval, overlapping_ranges) = {
    interval |> remove_overlapping_ranges(range)
  }

  // 2. combine all of these ranges into a single range
  let range = [range, ..overlapping_ranges] |> combine_overlapping_ranges

  // 3. add the final range back to the interval
  Interval(ranges: [range, ..interval.ranges])
}

/// Returns true if at least one range in the interval completely covers our range,
///
/// i: x--------x
/// r:   x---x
fn is_range_redundant(interval: Interval, r: Range) -> Bool {
  list.any(in: interval.ranges, satisfying: fn(i) {
    i.from <= r.from && i.to >= r.to
  })
}

/// Returns true if none of the numbers from our range are within the interval,
///
/// i: x---x
/// r:        x----x
fn is_range_completely_new(interval: Interval, r: Range) -> Bool {
  list.all(in: interval.ranges, satisfying: fn(i) {
    i.to < r.from || i.from > r.to
  })
}

/// Removes all ranges in the interval, which overlap with the given range.
fn remove_overlapping_ranges(
  interval: Interval,
  range: Range,
) -> #(Interval, List(Range)) {
  let #(remove, keep) = {
    list.partition(interval.ranges, with: are_ranges_overlapping(range, _))
  }

  #(Interval(ranges: keep), remove)
}

fn are_ranges_overlapping(a: Range, b: Range) {
  // a:  x----x
  // b:     x-----
  let x = a.from <= b.from && b.from <= a.to

  // a:       x-----
  // b:    x----x
  let y = b.from <= a.from && a.from <= b.to

  x || y
}

fn combine_overlapping_ranges(ranges: List(Range)) -> Range {
  list.reduce(ranges, with: fn(a, b) {
    let from = int.min(a.from, b.from)
    let to = int.max(a.to, b.to)

    Range(from:, to:)
  })
  |> result.lazy_unwrap(or: fn() { panic })
}

fn count_ingredients(interval: Interval) {
  list.fold(over: interval.ranges, from: 0, with: fn(acc, range) {
    acc + { range.to - range.from + 1 }
  })
}
