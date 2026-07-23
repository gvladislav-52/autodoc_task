//
//  HomeView.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import ATUIKit
import ATResources

protocol DisplaysHome: UIView {
    var viewDelegate: HomeViewDelegate? { get set }
    func apply(state: HomeDataFlow.State)
}

protocol HomeViewDelegate: AnyObject {
    func homeView(_ view: HomeView, didSelectPost post: HomePostsModel)
    func homeView(_ view: HomeView, willDisplayItemAt index: Int)
    func homeViewDidPullToRefresh(_ view: HomeView)
}

final class HomeView: UIView {
    typealias DataSource = UICollectionViewDiffableDataSource<HomeCollectionSection, HomeCollectionItem>
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HomePostsModel>
    typealias SupplementaryHeaderRegistration = UICollectionView.SupplementaryRegistration<HomeSectionHeaderView>
    typealias SupplementaryFooterRegistration = UICollectionView.SupplementaryRegistration<HomeSectionFooterView>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeCollectionSection, HomeCollectionItem>

    private(set) lazy var dataSource: DataSource = setupDataSource()
    private var isLoadingNextPage = false
    private var hasLoadedData = false

    private(set) lazy var collectionView: UICollectionView = {
        let homeCollectionLayout = HomeCollectionLayout()
        let layout = homeCollectionLayout.createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.isPrefetchingEnabled = false
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        return collectionView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.viewDelegate?.homeViewDidPullToRefresh(self)
        }, for: .valueChanged)
        return control
    }()

    private let skeletonView = SkeletonView()
    weak var viewDelegate: HomeViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
        showSkeleton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: DisplaysHome {
    func apply(state: HomeDataFlow.State) {
        render(state)
    }
}

private extension HomeView {
    func render(_ state: HomeDataFlow.State) {
        switch state {
        case .idle:
            if hasLoadedData {
                hideSkeleton()
            } else {
                showSkeleton()
            }

        case .loading:
            if !hasLoadedData {
                showSkeleton()
            }

        case .success(let viewModel):
            hasLoadedData = true
            hideSkeleton()
            setupSnapshot(posts: viewModel.posts)
            updateFooterLoading(viewModel.isLoadingNextPage)
            updateRefreshControl(viewModel.isRefreshing)

        case .failure:
            refreshControl.endRefreshing()
            if !hasLoadedData {
                showSkeleton()
            }
        }
    }

    func showSkeleton() {
        guard skeletonView.isHidden else {
            skeletonView.startAnimating()
            return
        }
        collectionView.isHidden = true
        skeletonView.isHidden = false
        skeletonView.startAnimating()
    }

    func hideSkeleton() {
        guard !skeletonView.isHidden else { return }
        skeletonView.stopAnimating()
        skeletonView.isHidden = true
        collectionView.isHidden = false
    }

    func updateRefreshControl(_ isRefreshing: Bool) {
        if isRefreshing {
            if !refreshControl.isRefreshing {
                refreshControl.beginRefreshing()
            }
        } else {
            refreshControl.endRefreshing()
        }
    }

    func updateFooterLoading(_ isLoading: Bool) {
        isLoadingNextPage = isLoading

        guard collectionView.numberOfSections > 0 else { return }
        let indexPath = IndexPath(item: 0, section: collectionView.numberOfSections - 1)

        if let footerView = collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: indexPath
        ) as? HomeSectionFooterView {
            footerView.setLoading(isLoading)
        }
    }
}

extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

        switch item {
        case .posts(let post):
            viewDelegate?.homeView(self, didSelectPost: post)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath), case .posts = item else { return }
        viewDelegate?.homeView(self, willDisplayItemAt: indexPath.item)
    }
}

private extension HomeView {
    func createSupplementaryFooterRegistration() -> SupplementaryFooterRegistration {
        SupplementaryFooterRegistration(
            elementKind: UICollectionView.elementKindSectionFooter
        ) { [weak self] footerView, _, _ in
            footerView.setLoading(self?.isLoadingNextPage ?? false)
        }
    }

    func createSupplementaryHeaderRegistration() -> SupplementaryHeaderRegistration {
        SupplementaryHeaderRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { supplementaryView, _, indexPath in
            guard let section = HomeCollectionSection(rawValue: indexPath.section) else {
                return
            }

            switch section {
            case .posts:
                supplementaryView.configure(
                    labelText: Strings.Home.Section.Posts.title
                )
            }
        }
    }

    func setupDataSource() -> DataSource {
        let supplementaryHeaderRegistration = createSupplementaryHeaderRegistration()
        let supplementaryFooterRegistration = createSupplementaryFooterRegistration()

        let cellRegistration = CellRegistration { [weak self] cell, _, item in
            self?.configureCell(cell, with: item)
        }

        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .posts(let post):
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: post
                )
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: supplementaryHeaderRegistration,
                    for: indexPath
                )
            case UICollectionView.elementKindSectionFooter:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: supplementaryFooterRegistration,
                    for: indexPath
                )
            default:
                return nil
            }
        }

        return dataSource
    }

    func configureCell(_ cell: UICollectionViewListCell, with post: HomePostsModel) {
        cell.contentConfiguration = HomePostsContentConfiguration(
            id: post.id,
            title: post.title,
            description: post.description,
            publishedDate: post.publishedDate,
            url: post.url,
            fullUrl: post.fullUrl,
            titleImageUrl: post.titleImageUrl,
            categoryType: post.categoryType
        )
    }

    func setupSnapshot(posts: [HomePostsModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections(HomeCollectionSection.allCases)

        let postsItems = posts.map { HomeCollectionItem.posts($0) }

        snapshot.appendItems(postsItems, toSection: .posts)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

private extension HomeView {
    func addSubviews() {
        addSubview(collectionView)
        addSubview(skeletonView)
    }

    func addConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        skeletonView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            skeletonView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            skeletonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            skeletonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            skeletonView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
