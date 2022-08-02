import DropDown
import UIKit

class SettingsViewController: UIViewController {
    
    var rootVC: GameViewController
    
    let dropMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "4x4",
            "5x5",
            "6x6"
        ]
        return menu
    }()
    lazy var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = .white
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Settings", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
        return button
    }()
    
    lazy var settingFieldLabel: UIButton = {
        let label = UIButton()
        label.backgroundColor = .systemFill
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("FieldSize is \(rootVC.fieldSize)x\(rootVC.fieldSize)", for: .normal)
        label.layer.cornerRadius = 5
        label.setTitleColor(UIColor.systemBlue, for: .normal)
        label.addTarget(self, action: #selector(showSizes), for: .touchUpInside)
        return label
    }()
    lazy var settingName: UILabel = {
        let label = UILabel()
        label.text = "Set size of field"
        return label
    }()
    lazy var titleItem: UINavigationItem = {
        let title = UINavigationItem(title: "Settings")
        return title
    }()
    
    override func viewWillAppear(_ animated: Bool) {

        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(navBar)
        view.addSubview(saveButton)
        view.addSubview(settingFieldLabel)
        view.addSubview(settingName)
        dropMenu.anchorView = settingFieldLabel
        dropMenu.selectionAction = { index, title in
            switch index {
            case 0:
                self.rootVC.fieldSize = 4
                self.settingFieldLabel.setTitle("FieldSize is \(self.rootVC.fieldSize)x\(self.rootVC.fieldSize)", for: .normal)
            case 1:
                self.rootVC.fieldSize = 5
                self.settingFieldLabel.setTitle("FieldSize is \(self.rootVC.fieldSize)x\(self.rootVC.fieldSize)", for: .normal)
            case 2:
                self.rootVC.fieldSize = 6
                self.settingFieldLabel.setTitle("FieldSize is \(self.rootVC.fieldSize)x\(self.rootVC.fieldSize)", for: .normal)
            default:
                self.rootVC.fieldSize = 4
                self.settingFieldLabel.setTitle("FieldSize is \(self.rootVC.fieldSize)x\(self.rootVC.fieldSize)", for: .normal)
            }
        }
        navBar.setItems([titleItem], animated: false)
        setupConstraints()
    }
    init(controller: GameViewController) {
        rootVC = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func saveSettings() {
        rootVC.clearField()
        self.dismiss(animated: true)
    }
    
    @objc func showSizes() {
        dropMenu.show()
        
    }
    
    func setupConstraints() {
        navBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(100)}
        
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(-100)
            make.leading.equalTo(view.snp.leading).offset(50)
            make.trailing.equalTo(view.snp.trailing).offset(-50)
            make.height.equalTo(50)}
        
        settingName.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(150)
            make.leading.equalTo(view.snp.leading).offset(50)
            make.trailing.equalTo(view.snp.trailing).offset(-50)
            make.height.equalTo(50)}
        
        settingFieldLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(200)
            make.leading.equalTo(view.snp.leading).offset(50)
            make.trailing.equalTo(view.snp.trailing).offset(-50)
            make.height.equalTo(30)}
        
        
    }
    
}
