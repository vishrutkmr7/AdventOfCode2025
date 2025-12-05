import Foundation

let inputFilePath = "day5_input.txt"

func readFile() -> String {
  guard let fileContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read \(inputFilePath). Make sure it exists in the current directory.")
    return ""
  }
  return fileContent
}

struct FreshRange {
  let start: Int
  let end: Int

  func contains(_ id: Int) -> Bool {
    return id >= start && id <= end
  }
}

func parseInput(_ input: String) -> (ranges: [FreshRange], ingredientIDs: [Int]) {
  // Split by blank line to separate ranges from ingredient IDs
  let sections = input.components(separatedBy: "\n\n")

  guard sections.count >= 2 else {
    print("Error: Invalid input format - expected two sections separated by blank line")
    return ([], [])
  }

  // Parse fresh ranges (first section)
  let rangeLines = sections[0].split(separator: "\n")
  let ranges: [FreshRange] = rangeLines.compactMap { line in
    let parts = line.split(separator: "-")
    guard parts.count == 2,
      let start = Int(parts[0]),
      let end = Int(parts[1])
    else {
      return nil
    }
    return FreshRange(start: start, end: end)
  }

  // Parse ingredient IDs (second section)
  let idLines = sections[1].split(separator: "\n")
  let ingredientIDs: [Int] = idLines.compactMap { Int($0) }

  return (ranges, ingredientIDs)
}

func isFresh(_ id: Int, ranges: [FreshRange]) -> Bool {
  return ranges.contains { $0.contains(id) }
}

func countFreshIngredients(ranges: [FreshRange], ingredientIDs: [Int]) -> Int {
  return ingredientIDs.filter { isFresh($0, ranges: ranges) }.count
}

func mergeRanges(_ ranges: [FreshRange]) -> [FreshRange] {
  guard !ranges.isEmpty else { return [] }

  // Sort ranges by start position
  let sorted = ranges.sorted { $0.start < $1.start }

  var merged: [FreshRange] = []
  var current = sorted[0]

  for range in sorted.dropFirst() {
    // Check if ranges overlap or are adjacent (current.end + 1 >= range.start)
    if range.start <= current.end + 1 {
      // Merge by extending the end if needed
      current = FreshRange(start: current.start, end: max(current.end, range.end))
    } else {
      // No overlap, save current and start new range
      merged.append(current)
      current = range
    }
  }
  merged.append(current)

  return merged
}

func countTotalFreshIDs(ranges: [FreshRange]) -> Int {
  let merged = mergeRanges(ranges)
  return merged.reduce(0) { total, range in
    total + (range.end - range.start + 1)
  }
}

func solve() {
  let input = readFile()
  guard !input.isEmpty else { return }

  let (ranges, ingredientIDs) = parseInput(input)

  print("Parsed \(ranges.count) fresh ranges")
  print("Parsed \(ingredientIDs.count) ingredient IDs to check")

  // Part 1
  let freshCount = countFreshIngredients(ranges: ranges, ingredientIDs: ingredientIDs)
  print("\nPart 1: \(freshCount) of the available ingredient IDs are fresh")

  // Part 2
  let totalFreshIDs = countTotalFreshIDs(ranges: ranges)
  let mergedRanges = mergeRanges(ranges)
  print(
    "\nPart 2: After merging \(ranges.count) ranges into \(mergedRanges.count) non-overlapping ranges:"
  )
  print("Answer: \(totalFreshIDs) ingredient IDs are considered fresh")
}

solve()
