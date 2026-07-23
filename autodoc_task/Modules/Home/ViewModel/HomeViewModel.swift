//
//  HomeViewModel.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation
import Combine
import ATNetworking

protocol HomeViewModelProtocol: AnyObject {
    var statePublisher: Published<HomeDataFlow.State>.Publisher { get }
    func loadHome()
    func loadNextPageIfNeeded(currentIndex: Int)
    func refreshHome()
}

final class HomeViewModel {
    private enum Constants {
        static let pageSize = 15
        static let prefetchThreshold = 3
    }

    @Published private(set) var state: HomeDataFlow.State = .idle

    private let provider: ProvidesHome
    private var loadTask: Task<Void, Never>?
    private var loadNextPageTask: Task<Void, Never>?
    private var refreshTask: Task<Void, Never>?

    private var posts: [HomePostsModel] = []
    private var currentPage = 1
    private var isLastPage = false
    private var isLoadingNextPage = false
    private var isRefreshing = false

    init(provider: ProvidesHome) {
        self.provider = provider
    }

    deinit {
        loadTask?.cancel()
        loadNextPageTask?.cancel()
        refreshTask?.cancel()
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    var statePublisher: Published<HomeDataFlow.State>.Publisher {
        $state
    }

    func loadHome() {
        loadTask?.cancel()
        loadNextPageTask?.cancel()
        refreshTask?.cancel()

        posts = []
        currentPage = 1
        isLastPage = false
        isLoadingNextPage = false
        isRefreshing = false

        state = .loading
        loadTask = Task { [weak self] in
            guard let self else {
                return
            }

            do {
                let response = try await self.provider.fetchHomePosts(
                    page: self.currentPage,
                    postCount: Constants.pageSize
                )
                let mapped = self.mapHomePostsResponseToViewModels(response)

                guard !Task.isCancelled else {
                    return
                }

                self.posts = mapped
                self.isLastPage = mapped.count < Constants.pageSize
                self.state = .success(HomeDataFlow.ViewModelSuccess(posts: self.posts))
            } catch let error as APIError {
                guard !Task.isCancelled else {
                    return
                }
                self.state = .failure(HomeDataFlow.ViewModelFailure(message: ErrorViewModel(error).message))
            } catch {
                guard !Task.isCancelled else {
                    return
                }
                self.state = .failure(HomeDataFlow.ViewModelFailure(message: error.localizedDescription))
            }
        }
    }

    func loadNextPageIfNeeded(currentIndex: Int) {
        guard !isLoadingNextPage, !isRefreshing, !isLastPage else {
            return
        }
        guard currentIndex >= posts.count - Constants.prefetchThreshold else {
            return
        }

        isLoadingNextPage = true
        state = .success(HomeDataFlow.ViewModelSuccess(posts: posts, isLoadingNextPage: true))

        let nextPage = currentPage + 1

        loadNextPageTask = Task { [weak self] in
            guard let self else {
                return
            }

            do {
                let response = try await self.provider.fetchHomePosts(
                    page: nextPage,
                    postCount: Constants.pageSize
                )
                let mapped = self.mapHomePostsResponseToViewModels(response)

                guard !Task.isCancelled else {
                    return
                }

                let existingIds = Set(self.posts.map(\.id))
                let newPosts = mapped.filter { !existingIds.contains($0.id) }

                self.currentPage = nextPage
                self.isLastPage = mapped.count < Constants.pageSize || newPosts.isEmpty
                self.posts += newPosts
                self.isLoadingNextPage = false
                self.state = .success(HomeDataFlow.ViewModelSuccess(posts: self.posts))
            } catch {
                guard !Task.isCancelled else {
                    return
                }
                self.isLoadingNextPage = false
                self.state = .success(HomeDataFlow.ViewModelSuccess(posts: self.posts))
            }
        }
    }

    func refreshHome() {
        guard !isRefreshing else { return }

        loadNextPageTask?.cancel()
        refreshTask?.cancel()

        isRefreshing = true
        state = .success(HomeDataFlow.ViewModelSuccess(posts: posts, isRefreshing: true))

        refreshTask = Task { [weak self] in
            guard let self else {
                return
            }

            do {
                let response = try await self.provider.fetchHomePosts(
                    page: 1,
                    postCount: Constants.pageSize
                )
                let mapped = self.mapHomePostsResponseToViewModels(response)

                guard !Task.isCancelled else {
                    return
                }

                let existingIds = Set(self.posts.map(\.id))
                let newPosts = mapped.filter { !existingIds.contains($0.id) }

                self.posts = newPosts + self.posts

                self.isRefreshing = false
                self.state = .success(HomeDataFlow.ViewModelSuccess(posts: self.posts))
            } catch {
                guard !Task.isCancelled else {
                    return
                }
                self.isRefreshing = false
                self.state = .success(HomeDataFlow.ViewModelSuccess(posts: self.posts))
            }
        }
    }
}

private extension HomeViewModel {
    func mapHomePostsResponseToViewModels(_ response: WebDTO.HomePostResponse) -> [HomePostsModel] {
        response.news.map { post in
            HomePostsModel(
                id: post.id,
                title: post.title,
                description: post.description,
                publishedDate: post.publishedDate,
                url: post.url,
                fullUrl: post.fullUrl,
                titleImageUrl: post.titleImageUrl.flatMap { URL(string: $0) },
                categoryType: post.categoryType
            )
        }
    }
}
