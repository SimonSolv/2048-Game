import UIKit
import SnapKit

class GameViewController: UIViewController, Coordinated {
    // MARK: - Parameters
    var coordinator: CoordinatorProtocol
    
    var gameOver: Bool = false
    
    var moveScore = 0
    
    var fieldWidth = 40
    
    var fieldSize: Int = 4
    
    var matrix: [[Int]] = []
    
    var layoutK: CGFloat = 32.0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: SecondCollectionViewCell.identifier )
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .infoDark)
        button.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
        return button
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
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start game", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()
    
    lazy var settingsButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Settings", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return button
    }()
    // MARK: - Functions
    @objc func startGame() {
        clearField()
        addRandom()
        moveScore = 0
        collectionView.reloadData()
        addSwipe()
        startButton.isHidden = true
    }
    
    func clearField() {
        matrix = buildMatrix(size: fieldSize)
        startButton.isHidden = false
        collectionView.reloadData()
    }
    
    @objc func settingsTapped() {
        let controller = SettingsViewController(controller: self)
        self.present(controller, animated: true)
    }
    
    @objc func infoTapped() {
        let alert = UIAlertController(title: "Field size", message: "Current fieldsize is \(fieldSize)", preferredStyle: .actionSheet)
  //      alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            
        }))
        present(alert, animated: true)
    }
    
    func updateMove() {
        moveScore += 1
        movesCountPlate.text = "Moves: \(moveScore)"
    }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        matrix = buildMatrix(size: fieldSize)
        switch fieldSize {
        case 4:
            layoutK = 6
        case 5:
            layoutK = 4
        case 6:
            layoutK = 2
            fieldWidth = 10
        default:
            layoutK = 4
        }
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
        setupConstraints()
        collectionView.reloadData()
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
    
    func setupViews() {
        view.backgroundColor = .systemGray2
        view.addSubview(field)
        view.addSubview(collectionView)
        view.addSubview(startButton)
        view.addSubview(movesCountPlate)
        view.addSubview(infoButton)
        view.addSubview(settingsButton)
        collectionView.isScrollEnabled = false
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
            if endGame(matrix: matrix) {
                let alert = UIAlertController(title: "Game over!", message: "You don't have any moves", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Start new", style: .cancel, handler: { _ in
                    self.clearField()
                    self.startGame()
                }))
                alert.addAction(UIAlertAction(title: "End game", style: .destructive, handler: { _ in
                    self.startButton.isHidden = false
                    self.view.gestureRecognizers?.removeAll()
                }))
                present(alert, animated: true)
                print("Game Over!")
                return
            }
        }
    }
    
    func endGame(matrix: [[Int]]) -> Bool {
        var rightSum = false
        var leftSum = false
        var upSum = false
        var downSum = false
        let sourceMatrix = matrix
        var newMatrix = matrix
        for var row in 0...fieldSize-1 {
            for var place in 0...fieldSize-2 {
                if newMatrix[row][place] == newMatrix[row][place+1] {
                    let sumNumber = newMatrix[row][place] + newMatrix[row][place+1]
                    newMatrix[row][place] = 0
                    newMatrix [row][place+1] = sumNumber
                    continue
                }
            }
        }
        if newMatrix == sourceMatrix { rightSum = true }
        newMatrix = matrix
        for var row in 0...fieldSize-1 {
            for var place in 0...fieldSize-2 {
                if newMatrix[row][place] == newMatrix[row][place+1] {
                    let sumNumber = newMatrix[row][place] + newMatrix [row][place+1]
                    newMatrix[row][place] = 0
                    newMatrix [row][place+1] = sumNumber
                    continue
                }
            }
        }
        if newMatrix == sourceMatrix { leftSum = true }
        newMatrix = matrix
        for var stolbec in 0...fieldSize-1 {
            for var stroka in 0...fieldSize-2 {
                if newMatrix[stroka][stolbec] == newMatrix[stroka+1][stolbec] {
                    let sumNumber = newMatrix[stroka][stolbec] + newMatrix [stroka+1][stolbec]
                    newMatrix[stroka+1][stolbec] = 0
                    newMatrix[stroka][stolbec] = sumNumber
                    continue
                }
            }
        }
        if newMatrix == sourceMatrix { upSum = true }
        newMatrix = matrix
        for var stolbec in 0...fieldSize-1 {
            for var stroka in 0...fieldSize-2 {
                if newMatrix[stroka][stolbec] == newMatrix[stroka+1][stolbec] {
                    let sumNumber = newMatrix[stroka][stolbec] + newMatrix [stroka+1][stolbec]
                    newMatrix[stroka][stolbec] = 0
                    newMatrix[stroka+1][stolbec] = sumNumber
                    continue
                }
            }
        }
        if newMatrix == sourceMatrix { downSum = true }
        newMatrix = matrix
        if rightSum == true && leftSum == true && upSum == true && downSum == true {
            return true
        } else {return false}
    }
    func addSwipe() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
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
                    matrix[i][place] = replaceRow[i]
                }
            }
            
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
            moveCells(direction: .right)
            summ(direction: .right)
            addRandom()
            updateMove()
            collectionView.reloadData()
        case .left:
            moveCells(direction: .left)
            summ(direction: .left)
            addRandom()
            updateMove()
            collectionView.reloadData()
        case .up:
            moveCells(direction: .up)
            summ(direction: .up)
            addRandom()
            updateMove()
            collectionView.reloadData()
        case .down:
            moveCells(direction: .down)
            summ(direction: .down)
            addRandom()
            updateMove()
            collectionView.reloadData()
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
            make.leading.equalTo(view.snp.leading).offset(fieldWidth)
            make.trailing.equalTo(view.snp.trailing).offset(-fieldWidth)
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
        
        settingsButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(-100)
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
        
        infoButton.snp.makeConstraints { (make) in
            make.top.equalTo(movesCountPlate.snp.top).offset(15)
            make.leading.equalTo(field.snp.leading)
           // make.trailing.equalTo(view.snp.trailing).offset(-50)
          //  make.height.equalTo(50)
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
        cell.sizeOfField = fieldSize
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Int(field.bounds.width) - 50 - 5 * fieldSize) / fieldSize, height: (Int(field.bounds.width) - 50 - 5 * fieldSize) / fieldSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(layoutK), left: CGFloat(layoutK), bottom: CGFloat(layoutK), right: CGFloat(layoutK))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // delegate?.openGallery()
        print("Cell Tapped")
    }
}

