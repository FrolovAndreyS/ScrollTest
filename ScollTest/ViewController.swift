//
//  ViewController.swift
//  ScollTest
//
//  Created by frolov on 21.01.2022.
//

import UIKit
import Utils
import ReactiveDataDisplayManager

final class ViewController: UIViewController {

    private enum Constants {
        static let buttonContainerHeight: CGFloat = 80
    }

    @IBOutlet private weak var mainButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonContainer: UIView!

    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!

    private var keyboardManager: KeyboardPositionManager?
    private var scrollManager: ScrollPositionManager?
    
    private lazy var manager = tableView.rddm.baseBuilder.build()
    private lazy var adapter = CellAdapter(manager: manager)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureKeyboardManager()
        keyboardManager?.subscribeOnKeyboardNotifications()
        subscribeOnKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager?.unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        title = "Test table view"

        navigationController?.navigationBar.prefersLargeTitles = true

        adapter.configure(len: 30)

        // ScrollManager
        
        adapter.onViewBecomeActive = { [weak self] cell in
            self?.scrollManager?.setActiveField(cell)
            self?.scrollManager?.scrollIfNeeded()
        }

        // RDDM

        adapter.onGeneratorBecomeActive = { [weak self] generator in
            //self?.manager.scrollTo(generator: generator, scrollPosition: .middle, animated: true)
        }
    }

    private func configureKeyboardManager() {
        let scrollManager = ScrollPositionManager(.init(scrollView: tableView,
                                                        offset: .zero))
        self.scrollManager = scrollManager
        keyboardManager = KeyboardPositionManager([scrollManager])
    }

}

// MARK: - Keyboard

extension ViewController: KeyboardObservable, FullKeyboardPresentable {

    func keyboardWillBeShown(keyboardInfo: Notification.KeyboardInfo) {
        guard let keyboardHeight = keyboardInfo.frameEnd?.height else { return }
        tableViewBottomConstraint.constant = keyboardHeight - (Constants.buttonContainerHeight + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? .zero))
        view.layoutIfNeeded()
    }

    func keyboardWillBeHidden(keyboardInfo: Notification.KeyboardInfo) {
        tableViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }

}
