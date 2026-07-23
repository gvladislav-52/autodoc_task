//
//  HomePostsContentView.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import ATUIKit
import ATNetworking

struct HomePostsContentConfiguration: UIContentConfiguration {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: URL?
    let categoryType: String

    func makeContentView() -> UIView & UIContentView {
        HomePostsContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {
        self
    }
}

final class HomePostsContentView: UIView, UIContentView {
    private var contentConfiguration: HomePostsContentConfiguration

    var configuration: UIContentConfiguration {
        get {
            contentConfiguration
        }
        set {
            guard let newValue = newValue as? HomePostsContentConfiguration else {
                return
            }
            contentConfiguration = newValue
            applyConfiguration()
        }
    }

    private let imageContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 16
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let categoryBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.palette.secondaryText.withAlphaComponent(0.15)
        view.layer.cornerRadius = 10
        return view
    }()

    private let categoryLabel = AppLabel(
        font: AppFonts.caption,
        color: AppColors.palette.primaryText,
        numberOfLines: 1
    )

    private let titleLabel: AppLabel = {
        let label = AppLabel(
            font: AppFonts.subtitleBold,
            color: AppColors.palette.primaryText,
            numberOfLines: 2
        )
        return label
    }()

    private let descriptionLabel = AppLabel(
        font: AppFonts.body,
        color: AppColors.palette.primaryText.withAlphaComponent(0.7),
        numberOfLines: 2
    )

    private let calendarIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = AppColors.palette.primaryText.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let createDateLabel = AppLabel(
        font: AppFonts.caption,
        color: AppColors.palette.primaryText.withAlphaComponent(0.5)
    )

    private lazy var dateStackView: UIStackView = {
        let spacer = UIView()

        let stack = UIStackView(arrangedSubviews: [
            spacer,
            calendarIconView,
            createDateLabel
        ])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            categoryBadgeView,
            titleLabel,
            descriptionLabel
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.setCustomSpacing(12, after: categoryBadgeView)
        return stack
    }()

    private var imageHeightConstraint: NSLayoutConstraint?
    private var contentStackTopToImageConstraint: NSLayoutConstraint?
    private var contentStackTopToSelfConstraint: NSLayoutConstraint?

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    init(configuration: HomePostsContentConfiguration) {
        self.contentConfiguration = configuration
        super.init(frame: .zero)
        backgroundColor = AppColors.palette.primaryBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        clipsToBounds = false
        addSubview()
        addConstraint()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomePostsContentView {
    func addSubview() {
        addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)

        categoryBadgeView.addSubview(categoryLabel)

        addSubview(contentStackView)
        addSubview(dateStackView)
    }

    func addConstraint() {
        let contentPadding: CGFloat = 16
        let badgeHorizontalPadding: CGFloat = 10
        let badgeVerticalPadding: CGFloat = 5
        let imageAspectRatio: CGFloat = 9.0 / 16.0
        let calendarIconViewSize: CGFloat = 14
        let dateStackViewPadding: CGFloat = 14

        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.translatesAutoresizingMaskIntoConstraints = false

        let imageHeightConstraint = imageContainerView.heightAnchor.constraint(
            equalTo: imageContainerView.widthAnchor,
            multiplier: imageAspectRatio
        )
        self.imageHeightConstraint = imageHeightConstraint

        contentStackTopToImageConstraint = contentStackView.topAnchor.constraint(
            equalTo: imageContainerView.bottomAnchor, constant: contentPadding
        )
        contentStackTopToSelfConstraint = contentStackView.topAnchor.constraint(
            equalTo: topAnchor, constant: contentPadding
        )

        dateStackView.alignment = .center
        calendarIconView.setContentHuggingPriority(.required, for: .horizontal)
        createDateLabel.setContentHuggingPriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageHeightConstraint,

            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),

            categoryLabel.topAnchor.constraint(
                equalTo: categoryBadgeView.topAnchor, constant: badgeVerticalPadding
            ),
            categoryLabel.bottomAnchor.constraint(
                equalTo: categoryBadgeView.bottomAnchor, constant: -badgeVerticalPadding
            ),
            categoryLabel.leadingAnchor.constraint(
                equalTo: categoryBadgeView.leadingAnchor, constant: badgeHorizontalPadding
            ),
            categoryLabel.trailingAnchor.constraint(
                equalTo: categoryBadgeView.trailingAnchor, constant: -badgeHorizontalPadding
            ),

            calendarIconView.widthAnchor.constraint(equalToConstant: calendarIconViewSize),
            calendarIconView.heightAnchor.constraint(equalToConstant: calendarIconViewSize),

            contentStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: contentPadding
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -contentPadding
            ),

            dateStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: contentPadding
            ),
            dateStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -contentPadding
            ),
            dateStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -contentPadding
            ),
            dateStackView.topAnchor.constraint(
                greaterThanOrEqualTo: contentStackView.bottomAnchor, constant: dateStackViewPadding
            )
        ])

        contentStackTopToImageConstraint?.isActive = true
    }

    func toggleImageVisibility(hasImage: Bool) {
        imageContainerView.isHidden = !hasImage
        imageHeightConstraint?.isActive = hasImage
        backgroundColor = hasImage ? AppColors.palette.primaryBackground : AppColors.palette.errorColor
        categoryBadgeView.backgroundColor
            = hasImage ? AppColors.palette.secondaryText.withAlphaComponent(0.15) : AppColors.palette.primaryBackground.withAlphaComponent(0.25)

        contentStackTopToImageConstraint?.isActive = hasImage
        contentStackTopToSelfConstraint?.isActive = !hasImage
    }

    func applyConfiguration() {
        imageView.setImage(with: contentConfiguration.titleImageUrl)
        toggleImageVisibility(hasImage: contentConfiguration.titleImageUrl != nil)

        categoryLabel.text = contentConfiguration.categoryType.uppercased()
        titleLabel.text = contentConfiguration.title
        descriptionLabel.text = contentConfiguration.description
        createDateLabel.text = formattedDate(from: contentConfiguration.publishedDate)
    }

    func formattedDate(from isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        let date: Date? = isoFormatter.date(from: isoString) ?? {
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.locale = Locale(identifier: "ru_RU")
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return fallbackFormatter.date(from: isoString)
        }()

        guard let date else { return isoString }

        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "ru_RU")
        displayFormatter.dateFormat = "d MMMM yyyy"
        return displayFormatter.string(from: date)
    }
}
