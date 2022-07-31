import Foundation
import UIKit

class GameFieldView: UIView {
    let field: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 135, height: 135)))
        view.backgroundColor = #colorLiteral(red: 0.8125980496, green: 1, blue: 0.8917096853, alpha: 1)
        view.layer.borderWidth = 5
        view.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func viewDidLoad() {
        self.addSubview(field)
    }
}

class CellView: UIView {
    let field: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func viewDidLoad() {
        self.addSubview(field)
    }
}
