//
//  ViewController.swift
//  ScollTest
//
//  Created by frolov on 21.01.2022.
//

import UIKit
import Utils
import ReactiveDataDisplayManager
import KeyboardManager

final class ViewController: UIViewController {

    private enum Constants {
        static let buttonContainerHeight: CGFloat = 80
    }

    @IBOutlet private weak var mainButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonContainer: UIView!

    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    private lazy var manager = tableView.rddm.baseBuilder.build()
    private lazy var adapter = CellAdapter(manager: manager)

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        enableKeyboardManager(with: [
            .encreaseConstraintAboveKeyboard(constraint: bottomConstraint, offset: 0),
            .autoScroll(mode: .toCenter(offset: Constants.buttonContainerHeight))
        ])
    }

    private func configure() {
        title = "Test table view"
        navigationController?.navigationBar.prefersLargeTitles = true
        adapter.configure(len: 30)
    }

}
