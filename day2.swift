import Foundation

let inputFilePath = "day2_input.txt"

func readFile() -> String {
  guard let fileContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read \(inputFilePath). Make sure it exists in the current directory.")
    return ""
  }
  return fileContent
}

func parseRanges(_ fileContent: String) -> [(Int, Int)] {
  return fileContent.components(separatedBy: ",")
    .filter { !$0.isEmpty }
    .map { str -> (Int, Int) in
      let parts = str.split(separator: "-")
      return (Int(parts[0])!, Int(parts[1])!)
    }
}

func solve() {
  let fileContent = readFile()
  let ranges = parseRanges(fileContent)

  guard let maxVal = ranges.map({ $0.1 }).max() else { return }

  var sumOfInvalidIDs = 0
  let maxPrefix = Int(pow(10, Double(String(maxVal).count / 2 + 1)))

  for prefix in 1..<maxPrefix {
    let prefixStr = String(prefix)
    let len = prefixStr.count
    let multiplier = Int(pow(10.0, Double(len))) + 1
    let candidate = prefix * multiplier

    for (start, end) in ranges {
      if candidate >= start && candidate <= end {
        sumOfInvalidIDs += candidate
      }
    }
  }

  print("Sum of invalid IDs: \(sumOfInvalidIDs)")
}

func solve2() {
  let fileContent = readFile()
  let ranges = parseRanges(fileContent)

  guard let maxVal = ranges.map({ $0.1 }).max() else { return }

  var validInvalidIDs = Set<Int>()
  let maxDigits = String(maxVal).count

  for patternLen in 1...(maxDigits / 2) {
    let startPattern = Int(pow(10.0, Double(patternLen - 1)))
    let endPattern = Int(pow(10.0, Double(patternLen))) - 1

    for pattern in startPattern...endPattern {
      let patternStr = String(pattern)
      var currentStr = patternStr + patternStr

      while true {
        guard let val = Int(currentStr) else { break }
        if val > maxVal { break }

        for (start, end) in ranges {
          if val >= start && val <= end {
            validInvalidIDs.insert(val)
            break
          }
        }

        currentStr += patternStr
      }
    }
  }

  let sumOfInvalidIDs = validInvalidIDs.reduce(0, +)
  print("Sum of invalid IDs (pt2): \(sumOfInvalidIDs)")
}

solve()
solve2()
