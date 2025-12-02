import Foundation

let inputFilePath = "day2_input.txt"

func readFile() -> String {
  guard let fileContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read \(inputFilePath). Make sure it exists in the current directory.")
    return ""
  }
  return fileContent
}

func isInvalidID(id: Int) -> Bool {
  let digits = String(id).map { Int(String($0))! }
  if digits.count % 2 != 0 {
    return false
  }
  let firstHalf = digits.prefix(digits.count / 2)
  let secondHalf = digits.suffix(digits.count / 2)
  return firstHalf == secondHalf
}

func solve() {
  let fileContent = readFile()
  let ranges = fileContent.components(separatedBy: ",").filter { !$0.isEmpty }

  var sumofInvalidIDs = 0

  for range in ranges {
    let parts = range.split(separator: "-")
    let start = Int(parts[0])!
    let end = Int(parts[1])!

    for id in start...end {
      if isInvalidID(id: id) {
        sumofInvalidIDs += id
      }
    }
  }

  print("Sum of invalid IDs: \(sumofInvalidIDs)")
}

func invalidID2(id: Int) -> Bool {
  let idString = String(id)
  let n = idString.count

  if n < 2 {
    return false
  }

  for patternLength in 1...(n / 2) {
    if n % patternLength == 0 {
      let repetitions = n / patternLength
      if repetitions >= 2 {
        let pattern = String(idString.prefix(patternLength))
        let repeated = String(repeating: pattern, count: repetitions)
        if repeated == idString {
          return true
        }
      }
    }
  }
  return false
}

func solve2() {
  let fileContent = readFile()
  let ranges = fileContent.components(separatedBy: ",").filter { !$0.isEmpty }

  var sumofInvalidIDs = 0

  for range in ranges {
    let parts = range.split(separator: "-")
    let start = Int(parts[0])!
    let end = Int(parts[1])!

    for id in start...end {
      if invalidID2(id: id) {
        sumofInvalidIDs += id
      }
    }
  }

  print("Sum of invalid IDs (pt2): \(sumofInvalidIDs)")
}

solve()
solve2()
