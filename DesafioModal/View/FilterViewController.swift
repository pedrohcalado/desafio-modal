// FilterViewController.swift

import UIKit
import RxSwift

class FilterViewController: UIViewController {
    @IBOutlet var starsFilterButton: UIButton!
    @IBOutlet var followersFilterButton: UIButton!
    @IBOutlet var dateFilterButton: UIButton!
    @IBOutlet var ascendingOrderButton: UIButton!
    @IBOutlet var descendingOrderButton: UIButton!

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var applyFilterButton: UIButton!

    private let disposeBag = DisposeBag()
    var viewModel: FilterViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.sorting.onNext(FilterService.shared.sorting)
        viewModel.order.onNext(FilterService.shared.order)

        setUpBindings()

        try? applyStylingToButtons()
    }

    private func setUpBindings() {
        let sortingButtons: [UIButton] = [starsFilterButton, followersFilterButton, dateFilterButton]
        let orderButtons: [UIButton] = [ascendingOrderButton, descendingOrderButton]

        closeButton.rx.tap
            .bind { [weak self] in self?.viewModel.closeFilterView() }
            .disposed(by: disposeBag)

        clearButton.rx.tap
            .bind { [weak self] in self?.viewModel.resetFilters() }
            .disposed(by: disposeBag)

        applyFilterButton.rx.tap
            .bind { [weak self] in self?.viewModel.applyFilters() }
            .disposed(by: disposeBag)

        for button in sortingButtons {
            button.rx.tap
                .bind { [weak self] in self?.viewModel.changeSorting(rawValue: button.accessibilityLabel) }
                .disposed(by: disposeBag)
        }

        for button in orderButtons {
            button.rx.tap
                .bind { [weak self] in self?.viewModel.changeOrder(rawValue: button.accessibilityLabel) }
                .disposed(by: disposeBag)
        }

        viewModel.didFilterChanged
            .subscribe(onNext: { [weak self] in try? self?.applyStylingToButtons() })
            .disposed(by: disposeBag)
    }

    private func applyStylingToButtons() throws {
        let buttons: [UIButton] = [starsFilterButton, followersFilterButton, dateFilterButton, ascendingOrderButton, descendingOrderButton]

        let sorting = try viewModel.sorting.value()
        let order = try viewModel.order.value()

        for button in buttons {
            if button.accessibilityLabel == order.rawValue || button.accessibilityLabel == sorting?.rawValue {
                button.backgroundColor = .black
                button.setTitleColor(.white, for: .normal)

                let checkmark = UIImage.init(systemName: "checkmark")!

                button.setImage(checkmark, for: .normal)
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8.45, bottom: 0, right: 0)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                button.setImage(nil, for: .normal)
            }

            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 4.0

        }
    }

}
