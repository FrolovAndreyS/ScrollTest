//
//  CellAdapter.swift
//  ScollTest
//
//  Created by frolov on 21.01.2022.
//

import ReactiveDataDisplayManager
import UIKit

final class CellAdapter {

    typealias Generator = BaseNonReusableCellGenerator<TextFieldCell>

    var onGeneratorBecomeActive: ((TableCellGenerator) -> Void)?
    var onViewBecomeActive: ((UIView) -> Void)?

    private let manager: BaseTableManager

    init(manager: BaseTableManager) {
        self.manager = manager
    }

    func configure(len: Int) {
        (0...len).forEach { i in
            addGenerator(i: i, isLast: i == len)
        }
    }

    private func addGenerator(i: Int, isLast: Bool) {
        let generator = Generator(with: (i, isLast))

        generator.cell?.onBecomeActive = { [weak self, weak generator] in
            guard let generator = generator,
                  let cell = generator.cell
            else {
                return
            }
            self?.onGeneratorBecomeActive?(generator)
            self?.onViewBecomeActive?(cell)
        }

        manager.addCellGenerator(generator)
    }

}
