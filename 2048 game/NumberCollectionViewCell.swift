import UIKit
import SnapKit

class NumberCollectionViewCell: UICollectionViewCell {
    static let identifier = "NumCell"
//    var source: Int? {
//        didSet {
//            if source == 0 {
//                number.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
//                number.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
//                number.layer.opacity = 0.5
//                number.layer.cornerRadius = 10
//                contentView.layer.cornerRadius = 10
//                number.clipsToBounds = true
//                number.layer.borderWidth = 8
//                number.text = ""
//            }
//            else {
//                number.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//                number.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//                number.layer.opacity = 0.5
//                number.layer.cornerRadius = 10
//                contentView.layer.cornerRadius = 10
//                number.clipsToBounds = true
//                number.layer.borderWidth = 8
//                number.text = "\(String(describing: source))"
//            }
//        }
//    }
    lazy var number: UILabel = {
        let view = UILabel()
        view.textColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        view.font = .boldSystemFont(ofSize: 30)
        view.text = "0"
        view.textAlignment = .center
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
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
