import Foundation

let inputFilePath = "day3_input.txt"

func readFile() -> String {
  guard let fileContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read \(inputFilePath). Make sure it exists in the current directory.")
    return ""
  }
  return fileContent
}

func max2DigitNumber(_ bank: String) -> Int {
  // 3 cases:
  // 1. largest number at the beginning - take the largest number after it and return the 2 digits in order of appearance
  // 2. largest number at the end - take the largest number before it and return the 2 digits in order of appearance
  // 3. largest number in the middle - take the largest number after it and return the 2 digits in order of appearance
  let digits = bank.map { Int(String($0))! }
  let maxDigit = digits.max()!
  let maxDigitIndex = digits.firstIndex(of: maxDigit)!

  if maxDigitIndex == digits.count - 1 {
    // Case 2: max is at the end - find largest before it, return in order of appearance
    let beforeMax = Array(digits[0..<maxDigitIndex])
    let secondMax = beforeMax.max()!
    return secondMax * 10 + maxDigit
  } else {
    // Case 1 & 3: max is at beginning or middle - find largest after it, return in order of appearance
    let afterMax = Array(digits[(maxDigitIndex + 1)...])
    let secondMax = afterMax.max()!
    return maxDigit * 10 + secondMax
  }
}

func solve() {
  let fileContent = readFile()
  let banks = fileContent.components(separatedBy: .newlines).filter { !$0.isEmpty }
  var totalJoltage = 0
  for bank in banks {
    let joltage = maxKDigitNumber(bank, k: 2)
    totalJoltage += joltage
  }
  print("Part 1 - Total Joltage: \(totalJoltage)")
}

func maxKDigitNumber(_ bank: String, k: Int) -> Int {
  let digits = bank.map { Int(String($0))! }
  let n = digits.count

  var result: [Int] = []
  var start = 0

  for i in 0..<k {
    // For position i, we can pick from 'start' to 'n - (k - i)'
    // This ensures we have enough digits left to complete the k-digit number
    let end = n - (k - i)
    var maxDigit = -1
    var maxIndex = start

    for j in start...end {
      if digits[j] > maxDigit {
        maxDigit = digits[j]
        maxIndex = j
      }
    }

    result.append(maxDigit)
    start = maxIndex + 1
  }

  // Convert result array to integer
  return result.reduce(0) { $0 * 10 + $1 }
}

func solve2() {
  let fileContent = readFile()
  let banks = fileContent.components(separatedBy: .newlines).filter { !$0.isEmpty }
  var totalJoltage = 0
  for bank in banks {
    let joltage = maxKDigitNumber(bank, k: 12)
    totalJoltage += joltage
  }
  print("Part 2 - Total Joltage: \(totalJoltage)")
}

solve()
solve2()
