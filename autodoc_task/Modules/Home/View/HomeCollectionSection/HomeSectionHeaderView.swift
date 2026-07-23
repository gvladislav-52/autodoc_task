//
//  HomeSectionHeaderView.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import ATUIKit

final class HomeSectionHeaderView: UICollectionReusableView {
    private let label: AppLabel = {
        let label = AppLabel(
            font: AppFonts.headline4,
            color: AppColors.palette.secondaryText,
            alignment: .left,
            numberOfLines: 1
        )
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        addConstraint()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(labelText: String) {
        label.text = labelText
    }
}

private extension HomeSectionHeaderView {
    func addSubview() {
        addSubview(label)
    }

    func addConstraint() {
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
