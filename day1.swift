import Foundation

let inputFilePath = "day1_input.txt"
let dialSize = 100
let startPosition = 50
let targetPosition = 0

func floorDiv(_ a: Int, _ b: Int) -> Int {
  let q = a / b
  let r = a % b
  if (r < 0 && b > 0) || (r > 0 && b < 0) {
    return q - 1
  }
  return q
}

func readFile() -> String {
  guard let fileContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read \(inputFilePath). Make sure it exists in the current directory.")
    return ""
  }
  return fileContent
}

func solve() {
  let fileContent = readFile()
  let instructions = fileContent.components(separatedBy: .newlines).filter { !$0.isEmpty }

  var currentPosition = startPosition
  var zeroCount = 0

  for instruction in instructions {
    let direction = instruction.prefix(1)
    guard let amount = Int(instruction.dropFirst()) else { continue }

    if direction == "R" {
      currentPosition = (currentPosition + amount) % dialSize
    } else if direction == "L" {
      let rawValue = (currentPosition - amount) % dialSize
      currentPosition = (rawValue + dialSize) % dialSize
    }

    if currentPosition == targetPosition {
      zeroCount += 1
    }
  }

  print("Part 1 Password: \(zeroCount)")
}

func solvePartTwo() {
  let fileContent = readFile()
  let instructions = fileContent.components(separatedBy: .newlines).filter { !$0.isEmpty }

  var absolutePosition = startPosition
  var totalZeros = 0

  for instruction in instructions {
    let direction = instruction.prefix(1)
    guard let amount = Int(instruction.dropFirst()) else { continue }

    if direction == "R" {
      let nextPosition = absolutePosition + amount
      let zerosCrossed = floorDiv(nextPosition, dialSize) - floorDiv(absolutePosition, dialSize)
      totalZeros += zerosCrossed
      absolutePosition = nextPosition
    } else if direction == "L" {
      let nextPosition = absolutePosition - amount
      let startFloor = floorDiv(absolutePosition - 1, dialSize)
      let endFloor = floorDiv(nextPosition - 1, dialSize)
      totalZeros += (startFloor - endFloor)
      absolutePosition = nextPosition
    }
  }

  print("Method 0x434C49434B Password (Part 2): \(totalZeros)")
}

solve()
solvePartTwo()
