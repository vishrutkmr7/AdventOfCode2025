import Foundation

let inputFilePath = "day4_input.txt"

func readFile() -> String {
  guard let fileContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read \(inputFilePath). Make sure it exists in the current directory.")
    return ""
  }
  return fileContent
}

func parseGrid(_ input: String) -> [[Character]] {
  return input.split(separator: "\n").map { Array($0) }
}

func countAdjacentRolls(grid: [[Character]], row: Int, col: Int) -> Int {
  let directions = [
    (-1, -1), (-1, 0), (-1, 1),  // top-left, top, top-right
    (0, -1), (0, 1),  // left, right
    (1, -1), (1, 0), (1, 1),  // bottom-left, bottom, bottom-right
  ]

  var count = 0
  let rows = grid.count
  let cols = grid[0].count

  for (dr, dc) in directions {
    let newRow = row + dr
    let newCol = col + dc

    // Check bounds
    if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols {
      if grid[newRow][newCol] == "@" {
        count += 1
      }
    }
  }

  return count
}

func findAccessibleRolls(grid: [[Character]]) -> [(Int, Int)] {
  var accessible: [(Int, Int)] = []

  for row in 0..<grid.count {
    for col in 0..<grid[row].count {
      if grid[row][col] == "@" {
        let adjacentRolls = countAdjacentRolls(grid: grid, row: row, col: col)
        if adjacentRolls < 4 {
          accessible.append((row, col))
        }
      }
    }
  }

  return accessible
}

func solvePart1(grid: [[Character]]) -> Int {
  return findAccessibleRolls(grid: grid).count
}

func solvePart2(grid: [[Character]]) -> Int {
  var mutableGrid = grid
  var totalRemoved = 0

  while true {
    let accessible = findAccessibleRolls(grid: mutableGrid)

    if accessible.isEmpty {
      break
    }

    // Remove all accessible rolls
    for (row, col) in accessible {
      mutableGrid[row][col] = "."
    }

    totalRemoved += accessible.count
  }

  return totalRemoved
}

func solve() {
  let fileContent = readFile()
  let grid = parseGrid(fileContent)

  let part1 = solvePart1(grid: grid)
  print("Part 1: \(part1) rolls of paper can be accessed by a forklift")

  let part2 = solvePart2(grid: grid)
  print("Part 2: \(part2) rolls of paper can be removed in total")
}

solve()
