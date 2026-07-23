//
//  HomeCollectionLayout.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import ATUIKit

struct HomeCollectionLayout {
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, environment -> NSCollectionLayoutSection? in
            return self.createPostsSection(environment: environment)
        }
    }
}

private extension HomeCollectionLayout {
    func createPostsSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let paddingTop: CGFloat = 12
        let padding: CGFloat = 16
        let minColumnWidth: CGFloat = 361
        let postsHeight: CGFloat = 48
        let imageAspectRatio: CGFloat = 16.0 / 9.0
        let textBlockHeight: CGFloat = 180

        let containerWidth = environment.container.effectiveContentSize.width
        let columnsCount = max(1, Int((containerWidth + padding) / (minColumnWidth + padding)))

        let totalSpacing = padding * CGFloat(columnsCount - 1)
        let columnWidth = (containerWidth - totalSpacing) / CGFloat(columnsCount)

        let imageHeight = (columnWidth / imageAspectRatio).rounded()
        let itemHeight = imageHeight + textBlockHeight

        let supplementarySize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(postsHeight)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: supplementarySize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / CGFloat(columnsCount)),
                heightDimension: .absolute(itemHeight)
            )
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemHeight)
            ),
            subitems: Array(repeating: item, count: columnsCount)
        )
        group.interItemSpacing = .fixed(padding)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = padding
        section.contentInsets = NSDirectionalEdgeInsets(
            top: paddingTop, leading: padding, bottom: padding, trailing: padding
        )
        section.boundarySupplementaryItems = [header]
        return section
    }
}
