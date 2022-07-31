import UIKit
import SnapKit

class GameViewController: UIViewController, Coordinated {
    // MARK: - Parameters
    var coordinator: CoordinatorProtocol
    
    var gameOver: Bool = false
    
    var moveScore = 0
    
    var fieldSize: Int = 4
    
    var matrix: [[Int]] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: SecondCollectionViewCell.identifier )
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy var movesCountPlate: UILabel = {
       let label = UILabel()
        label.text = "Moves: \(moveScore)"
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    lazy var field: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 135, height: 135)))
        view.backgroundColor = #colorLiteral(red: 0.8125980496, green: 1, blue: 0.8917096853, alpha: 1)
        view.layer.borderWidth = 5
        view.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var startButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start game", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()
    // MARK: - Functions
    @objc func startGame() {
        addRandom()
        collectionView.reloadData()
        addSwipe()
        startButton.isHidden = true
    }
    
    func updateMove() {
        moveScore += 1
        movesCountPlate.text = "Moves: \(moveScore)"
    }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        matrix = buildMatrix(size: fieldSize)
        view.backgroundColor = #colorLiteral(red: 0.8774181008, green: 0.8884639144, blue: 0.8882696033, alpha: 1)
        view.addSubview(field)
        view.addSubview(collectionView)
        view.addSubview(startButton)
        view.addSubview(movesCountPlate)
        setupConstraints()
    }
    // MARK: - Matrix Operations
    func buildMatrix(size: Int) -> [[Int]] {
        var result: [[Int]] = []
        var array: [Int] = []
        for _ in 0...size-1 {
            array.append(0)
        }
        for _ in 0...size-1 {
            result.append(array)
        }
        return result
    }

    func randomize(row : [[Int]]) -> [Int] {
        let randomCellId: [Int] = row.randomElement()!
        return randomCellId
    }
    
    func addRandom() {
        var emptyCells: [[Int]] = []
        let starters = [2, 4]
        for i in 0...fieldSize-1 {
            for j in 0...fieldSize-1 {
                if matrix[i][j] == 0 {
                    emptyCells.append([i, j])
                }
            }
        }
        if emptyCells.count > 1 {
            var appendingNumber = 0
            let a = randomize(row: emptyCells)
            var b = randomize(row: emptyCells)
            while a == b {
                b = randomize(row: emptyCells)
            }
            appendingNumber = starters.randomElement()!
            print("Add number \(appendingNumber)")
            matrix[a[0]][a[1]] = appendingNumber
            appendingNumber = starters.randomElement()!
            print("Add number \(appendingNumber)")
            matrix[b[0]][b[1]] = appendingNumber
        }
        else if emptyCells.count == 1 {
            var appendingNumber = 0
            let a = randomize(row: emptyCells)
            appendingNumber = starters.randomElement()!
            matrix[a[0]][a[1]] = appendingNumber
            print("Add number \(appendingNumber)")
        }
        else {
            gameOver = true
            print("Game Over!")
            return
        }
    }
    
    func addSwipe() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    func moveCells(direction: Direction) {
        switch direction {
        case .right:
            for var row in 0...fieldSize-1 {
                var replaceRow: [Int] = []
                for var place in 0...fieldSize-1 {
                    if matrix[row][place] != 0 {
                        replaceRow.append(matrix[row][place])
                    }
                }
                while replaceRow.count < fieldSize {
                    replaceRow.insert(0, at: 0)
                }
                matrix[row] = replaceRow
            }
            updateMove()
        case .left:
            for var row in 0...fieldSize-1 {
                var replaceRow: [Int] = []
                for var place in 0...fieldSize-1 {
                    if matrix[row][place] != 0 {
                        replaceRow.append(matrix[row][place])
                    }
                }
                while replaceRow.count < fieldSize {
                    replaceRow.append(0)
                }
                matrix[row] = replaceRow
            }
            updateMove()
        case .up:
            for var place in 0...fieldSize-1 {
                var replaceRow: [Int] = []
                for var row in 0...fieldSize-1 {
                    if matrix[row][place] != 0 {
                        replaceRow.append(matrix[row][place])
                    }
                }
                while replaceRow.count < fieldSize {
                    replaceRow.insert(0, at: 0)
                }
                replaceRow = replaceRow.reversed()
                for i in 0...fieldSize-1 {
                    matrix[i][place] = replaceRow [i]
                }
            }
            updateMove()
        case .down:
            for var place in 0...fieldSize-1 {
                var replaceRow: [Int] = []
                for var row in 0...fieldSize-1 {
                    if matrix[row][place] != 0 {
                        replaceRow.append(matrix[row][place])
                    }
                }
                while replaceRow.count < fieldSize {
                    replaceRow.insert(0, at: 0)
                }
                for i in 0...fieldSize-1 {
                    matrix[i][place] = replaceRow [i]
                }
            }
            updateMove()
        }
    }
    
    func summ(direction: Direction) {
        switch direction {
        case .right:
            for var row in 0...fieldSize-1 {
                for var place in 0...fieldSize-2 {
                    if matrix[row][place] == matrix[row][place+1] {
                        let sumNumber = matrix[row][place] + matrix[row][place+1]
                        matrix[row][place] = 0
                        matrix [row][place+1] = sumNumber
                        continue
                        continue
                    }
                }
            }
            moveCells(direction: .right)
        case .left:
            for var row in 0...fieldSize-1 {
                for var place in 0...fieldSize-2 {
                    if matrix[row][place] == matrix[row][place+1] {
                        let sumNumber = matrix[row][place] + matrix [row][place+1]
                        matrix[row][place] = 0
                        matrix [row][place+1] = sumNumber
                        continue
                    }
                }
            }
            moveCells(direction: .left)
        case .up:
            for var stolbec in 0...fieldSize-1 {
                for var stroka in 0...fieldSize-2 {
                    if matrix[stroka][stolbec] == matrix[stroka+1][stolbec] {
                        let sumNumber = matrix[stroka][stolbec] + matrix [stroka+1][stolbec]
                        matrix[stroka+1][stolbec] = 0
                        matrix [stroka][stolbec] = sumNumber
                        continue
                    }
                }
            }
            moveCells(direction: .up)
        case .down:
            for var stolbec in 0...fieldSize-1 {
                for var stroka in 0...fieldSize-2 {
                    if matrix[stroka][stolbec] == matrix[stroka+1][stolbec] {
                        let sumNumber = matrix[stroka][stolbec] + matrix [stroka+1][stolbec]
                        matrix[stroka][stolbec] = 0
                        matrix [stroka+1][stolbec] = sumNumber
                        continue
                    }
                }
            }
            moveCells(direction: .down)
        }
        
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let direction = sender.direction
        switch direction {
        case .right:
            print("Gesture direction: Right")
            moveCells(direction: .right)
            summ(direction: .right)
            addRandom()
            collectionView.reloadData()
            print ("Result matrix:")
            for i in 0...fieldSize-1 {
                print("\(matrix[i])")
            }
        case .left:
            moveCells(direction: .left)
            summ(direction: .left)
            addRandom()
            collectionView.reloadData()
            print("Gesture direction: Left")
        case .up:
            moveCells(direction: .up)
            summ(direction: .up)
            addRandom()
            collectionView.reloadData()
            print("Gesture direction: Up")
        case .down:
            moveCells(direction: .down)
            summ(direction: .down)
            addRandom()
            collectionView.reloadData()
            print("Gesture direction: Down")
        default:
            print("Unrecognized Gesture Direction")
        }
    }
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup
    func setupConstraints() {
        field.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(200)
            make.leading.equalTo(view.snp.leading).offset(40)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
            make.height.equalTo(self.field.snp.width)
        }

        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(field.snp.top).offset(10)
            make.leading.equalTo(field.snp.leading).offset(10)
            make.width.equalTo(field.snp.width).offset(-20)
            make.height.equalTo(field.snp.width).offset(-20)
        }
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(field.snp.bottom).offset(50)
            make.leading.equalTo(field.snp.leading)
            make.width.equalTo(field.snp.width)
            make.height.equalTo(50)
        }
        
        movesCountPlate.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(100)
            make.leading.equalTo(view.snp.leading).offset(-50)
            make.trailing.equalTo(view.snp.trailing).offset(-50)
            make.height.equalTo(50)
        }
    }

}
    // MARK: - CollectionView Setup
extension GameViewController: UICollectionViewDataSource {
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fieldSize
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fieldSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCollectionViewCell.identifier, for: indexPath) as! SecondCollectionViewCell
            cell.source = matrix[indexPath.section][indexPath.row]
//        cell.layer.borderWidth = 5
//        cell.layer.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Int(field.bounds.width) - 40 - 5 * fieldSize) / fieldSize, height: (Int(field.bounds.width) - 40 - 5 * fieldSize) / fieldSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // delegate?.openGallery()
        print("Cell Tapped")
    }
}

