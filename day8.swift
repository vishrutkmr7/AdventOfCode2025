import Foundation

private let inputFilePath = "day8_input.txt"
private let connectionsToMake = 1000

struct Point {
  let x: Int64
  let y: Int64
  let z: Int64
}

struct Edge {
  let dist: Int64
  let u: Int
  let v: Int
}

final class DisjointSet {
  private var parent: [Int]
  private var size: [Int]
  private var components: Int

  init(_ count: Int) {
    parent = Array(0..<count)
    size = Array(repeating: 1, count: count)
    components = count
  }

  private func find(_ x: Int) -> Int {
    if parent[x] == x {
      return x
    }
    parent[x] = find(parent[x])
    return parent[x]
  }

  @discardableResult
  func union(_ a: Int, _ b: Int) -> Bool {
    let rootA = find(a)
    let rootB = find(b)
    if rootA == rootB {
      return false
    }
    if size[rootA] < size[rootB] {
      parent[rootA] = rootB
      size[rootB] += size[rootA]
    } else {
      parent[rootB] = rootA
      size[rootA] += size[rootB]
    }
    components -= 1
    return true
  }

  var componentCount: Int {
    components
  }

  func componentSizes() -> [Int] {
    var counts: [Int: Int] = [:]
    for idx in 0..<parent.count {
      let root = find(idx)
      counts[root, default: 0] += 1
    }
    return Array(counts.values)
  }
}

func readInput() -> String {
  guard let fileContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read \(inputFilePath). Make sure it exists in the current directory.")
    return ""
  }
  return fileContent
}

func parsePoints(from input: String) -> [Point] {
  input
    .split(whereSeparator: \.isNewline)
    .compactMap { line -> Point? in
      let parts = line.split(separator: ",")
      guard parts.count == 3,
        let x = Int64(parts[0]),
        let y = Int64(parts[1]),
        let z = Int64(parts[2])
      else {
        return nil
      }
      return Point(x: x, y: y, z: z)
    }
}

func buildEdges(for points: [Point]) -> [Edge] {
  let n = points.count
  var edges: [Edge] = []
  edges.reserveCapacity(n * (n - 1) / 2)

  for i in 0..<n {
    for j in (i + 1)..<n {
      let dx = points[i].x - points[j].x
      let dy = points[i].y - points[j].y
      let dz = points[i].z - points[j].z
      let dist = dx * dx + dy * dy + dz * dz
      edges.append(Edge(dist: dist, u: i, v: j))
    }
  }

  edges.sort {
    if $0.dist == $1.dist {
      if $0.u == $1.u {
        return $0.v < $1.v
      }
      return $0.u < $1.u
    }
    return $0.dist < $1.dist
  }

  return edges
}

func productOfLargestThree(_ sizes: [Int]) -> Int64 {
  guard !sizes.isEmpty else { return 0 }
  let sorted = sizes.sorted(by: >)
  var values: [Int64] = []
  for i in 0..<min(3, sorted.count) {
    values.append(Int64(sorted[i]))
  }
  while values.count < 3 {
    values.append(1)  // Neutral element if fewer than three components.
  }
  return values.reduce(1, *)
}

func solvePart1(points: [Point], edges: [Edge]) -> Int64 {
  let edgesToProcess = min(connectionsToMake, edges.count)
  let dsu = DisjointSet(points.count)
  for idx in 0..<edgesToProcess {
    let edge = edges[idx]
    dsu.union(edge.u, edge.v)
  }
  return productOfLargestThree(dsu.componentSizes())
}

func solvePart2(points: [Point], edges: [Edge]) -> Int64 {
  let dsu = DisjointSet(points.count)
  var finalEdge: Edge?
  for edge in edges {
    let merged = dsu.union(edge.u, edge.v)
    if merged && dsu.componentCount == 1 {
      finalEdge = edge
      break
    }
  }
  guard let last = finalEdge else {
    return 0
  }
  return points[last.u].x * points[last.v].x
}

func solve() {
  let rawInput = readInput()
  let points = parsePoints(from: rawInput)
  guard points.count >= 2 else {
    print("Insufficient points to form circuits.")
    return
  }

  let edges = buildEdges(for: points)
  let part1 = solvePart1(points: points, edges: edges)
  let part2 = solvePart2(points: points, edges: edges)
  print(part1)
  print(part2)
}

solve()
