//
//  TextFieldCell.swift
//  ScollTest
//
//  Created by frolov on 21.01.2022.
//

import UIKit
import ReactiveDataDisplayManager

final class TextFieldCell: UITableViewCell, ConfigurableItem {

    @IBOutlet private weak var textField: UITextField!

    var onBecomeActive: (() -> Void)?

    func configure(with model: Bool) {
        if model {
            textField.text = "This is last cell"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.backgroundColor = .orange
    }

}

extension TextFieldCell: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        onBecomeActive?()
    }

}
