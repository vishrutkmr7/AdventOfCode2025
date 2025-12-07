import Foundation

let inputFilePath = "day6_input.txt"

func readFile() -> String {
  guard let fileContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read \(inputFilePath). Make sure it exists in the current directory.")
    return ""
  }
  return fileContent
}

struct ParsedWorksheet {
  let numberRows: [[Character]]
  let operatorRow: [Character]
  let problems: [[Int]]
}

func parseWorksheet(_ content: String) -> ParsedWorksheet? {
  let lines = content.components(separatedBy: "\n").filter { !$0.isEmpty }
  guard lines.count >= 2 else {
    print("Invalid input format")
    return nil
  }

  let rows = lines.map { Array($0) }

  let maxWidth = rows.map { $0.count }.max() ?? 0

  let paddedRows = rows.map { row -> [Character] in
    var r = row
    while r.count < maxWidth {
      r.append(" ")
    }
    return r
  }

  let numberRows = Array(paddedRows.dropLast())
  let operatorRow = paddedRows.last!

  var separatorColumns: Set<Int> = []
  for col in 0..<maxWidth {
    let allSpaces = numberRows.allSatisfy { $0[col] == " " }
    if allSpaces {
      separatorColumns.insert(col)
    }
  }

  var problems: [[Int]] = []
  var currentProblem: [Int] = []

  for col in 0..<maxWidth {
    if separatorColumns.contains(col) {
      if !currentProblem.isEmpty {
        problems.append(currentProblem)
        currentProblem = []
      }
    } else {
      currentProblem.append(col)
    }
  }
  if !currentProblem.isEmpty {
    problems.append(currentProblem)
  }

  return ParsedWorksheet(numberRows: numberRows, operatorRow: operatorRow, problems: problems)
}

func getOperator(for problemCols: [Int], from operatorRow: [Character]) -> Character {
  for col in problemCols {
    let c = operatorRow[col]
    if c == "+" || c == "*" {
      return c
    }
  }
  return " "
}

// MARK: - Part 1

func solvePart1(_ worksheet: ParsedWorksheet) -> Int {
  var grandTotal = 0

  for (index, problemCols) in worksheet.problems.enumerated() {
    let op = getOperator(for: problemCols, from: worksheet.operatorRow)

    var numbers: [Int] = []
    for row in worksheet.numberRows {
      let chars = problemCols.map { row[$0] }
      let numStr = String(chars).trimmingCharacters(in: .whitespaces)
      if let num = Int(numStr), !numStr.isEmpty {
        numbers.append(num)
      }
    }

    let result: Int
    if op == "+" {
      result = numbers.reduce(0, +)
    } else if op == "*" {
      result = numbers.reduce(1, *)
    } else {
      result = 0
    }

    if index < 3 {
      let opStr = op == "+" ? " + " : " * "
      let equation = numbers.map { String($0) }.joined(separator: opStr)
      print("  Problem \(index + 1): \(equation) = \(result)")
    }

    grandTotal += result
  }

  return grandTotal
}

// MARK: - Part 2

func solvePart2(_ worksheet: ParsedWorksheet) -> Int {
  var grandTotal = 0

  for (index, problemCols) in worksheet.problems.enumerated() {
    let op = getOperator(for: problemCols, from: worksheet.operatorRow)

    var numbers: [Int] = []
    for col in problemCols.reversed() {
      var digits: [Character] = []
      for row in worksheet.numberRows {
        let c = row[col]
        if c.isNumber {
          digits.append(c)
        }
      }
      if !digits.isEmpty {
        let numStr = String(digits)
        if let num = Int(numStr) {
          numbers.append(num)
        }
      }
    }

    let result: Int
    if op == "+" {
      result = numbers.reduce(0, +)
    } else if op == "*" {
      result = numbers.reduce(1, *)
    } else {
      result = 0
    }

    if index < 3 {
      let opStr = op == "+" ? " + " : " * "
      let equation = numbers.map { String($0) }.joined(separator: opStr)
      print("  Problem \(index + 1): \(equation) = \(result)")
    }

    grandTotal += result
  }

  return grandTotal
}

// MARK: - Main

func solve() {
  let content = readFile()
  guard !content.isEmpty else { return }

  guard let worksheet = parseWorksheet(content) else { return }

  print("Parsed \(worksheet.problems.count) problems from worksheet")
  print("Number rows: \(worksheet.numberRows.count)")

  print("\n--- Part 1 ---")
  print("(Numbers read horizontally per row)")
  let part1Result = solvePart1(worksheet)
  print("Grand Total: \(part1Result)")

  print("\n--- Part 2 ---")
  print("(Numbers read vertically per column, right-to-left)")
  let part2Result = solvePart2(worksheet)
  print("Grand Total: \(part2Result)")
}

solve()
