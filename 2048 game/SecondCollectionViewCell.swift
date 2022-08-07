import UIKit
import SnapKit

class SecondCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "Second"
    var sizeOfField: Int? {
        didSet {
            guard sizeOfField != nil else {
                sizeOfField = 4
                return}
            number.layer.borderWidth = CGFloat(32/sizeOfField!)
            number.font = UIFont.boldSystemFont(ofSize: CGFloat(120/sizeOfField!))
        }
    }
    var source: Int? {
        didSet {
            if source != nil {
                if source == 0 {
                    number.layer.borderColor = #colorLiteral(red: 0.9536803002, green: 0.9825797033, blue: 0.9825797033, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    number.text = ""
                }
                else if source == 4 {
                    number.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    number.text = "\(source!)"
                }
                else if source == 8 {
                    number.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                    number.text = "\(source!)"
                }
                else if source == 16 {
                    number.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                    number.text = "\(source!)"
                }
                else if source == 32 {
                    number.layer.borderColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    number.text = "\(source!)"
                }
                else if source == 64 {
                    number.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                    number.text = "\(source!)"
                }
                else if source == 128 {
                    number.layer.borderColor = #colorLiteral(red: 0.554854611, green: 0.8919665404, blue: 0.4443540674, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.8841446522, green: 1, blue: 0.5526547509, alpha: 1)
                    number.text = "\(source!)"
                }
                else if source == 256 {
                    number.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    number.text = "\(source!)"
                }
                else if source == 512 {
                    number.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    number.text = "\(source!)"
                }
                else if source == 1024 {
                    number.layer.borderColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    number.text = "\(source!)"
                }
                else if source == 2048 {
                    number.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    number.text = "\(source!)"
                }
                else {
                    number.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    number.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    number.text = "\(source!)"
                }
            }
            
        }
    }
    
    lazy var number: UILabel = {
       let view = UILabel()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.textAlignment = .center
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(number)
        number.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
