import Foundation

let inputFilePath = "day7_input.txt"

func readFile() -> String {
  guard let fileContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read \(inputFilePath). Make sure it exists in the current directory.")
    return ""
  }
  return fileContent
}

func parseGrid(_ content: String) -> [[Character]] {
  content.split(separator: "\n").map { Array($0) }
}

func findStart(in grid: [[Character]]) -> (Int, Int)? {
  guard let row = grid.firstIndex(where: { $0.contains("S") }) else { return nil }
  guard let col = grid[row].firstIndex(of: "S") else { return nil }
  return (row, col)
}

func countSplits(in grid: [[Character]], start: (Int, Int)) -> Int {
  let rowCount = grid.count
  let colCount = grid.first?.count ?? 0
  var active: Set<Int> = [start.1]
  var splits = 0
  var row = start.0 + 1
  while row < rowCount && !active.isEmpty {
    var next: Set<Int> = []
    for col in active {
      if col < 0 || col >= colCount { continue }
      let cell = grid[row][col]
      if cell == "^" {
        splits += 1
        if col > 0 { next.insert(col - 1) }
        if col + 1 < colCount { next.insert(col + 1) }
      } else {
        next.insert(col)
      }
    }
    active = next
    row += 1
  }
  return splits
}

func countTimelines(in grid: [[Character]], start: (Int, Int)) -> Int {
  let rowCount = grid.count
  let colCount = grid.first?.count ?? 0
  var current: [Int: Int] = [start.1: 1]
  var row = start.0 + 1
  while row < rowCount && !current.isEmpty {
    var next: [Int: Int] = [:]
    for (col, count) in current {
      if col < 0 || col >= colCount { continue }
      let cell = grid[row][col]
      if cell == "^" {
        if col > 0 { next[col - 1, default: 0] += count }
        if col + 1 < colCount { next[col + 1, default: 0] += count }
      } else {
        next[col, default: 0] += count
      }
    }
    current = next
    row += 1
  }
  return current.values.reduce(0, +)
}

func solve() {
  let fileContent = readFile()
  let grid = parseGrid(fileContent)
  guard let start = findStart(in: grid) else { return }
  let part1 = countSplits(in: grid, start: start)
  let part2 = countTimelines(in: grid, start: start)
  print(part1)
  print(part2)
}

solve()
