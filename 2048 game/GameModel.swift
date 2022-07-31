import Foundation

class CellNumber {
    var randomNumber: Int = 2
    let numbers = [2, 4, 8, 16, 32, 64, 128, 254, 512, 1024, 2048]
    
    func randomize() -> Int {
        randomNumber = numbers[Int.random(in: 0..<3)]
        return randomNumber
    }
}


enum Direction {
    case right
    case left
    case up
    case down
}
