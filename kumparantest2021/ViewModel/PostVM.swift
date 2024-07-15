//
//  PostVM.swift
//  kumparantest2021
//
//  Created by irfan wahendra on 14/07/24.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    @Published var postsWithUserDetails: [PostWithUserDetails] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPosts() {
        guard let postsURL = URL(string: "https://jsonplaceholder.typicode.com/posts"),
              let usersURL = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let postsPublisher = URLSession.shared.dataTaskPublisher(for: postsURL)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        let usersPublisher = URLSession.shared.dataTaskPublisher(for: usersURL)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        Publishers.Zip(postsPublisher, usersPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching posts or users: \(error)")
                }
            }, receiveValue: { [weak self] posts, users in
                self?.postsWithUserDetails = posts.compactMap { post in
                    if let user = users.first(where: { $0.id == post.userId }) {
                        return PostWithUserDetails(post: post, user: user)
                    }
                    return nil
                }
            })
            .store(in: &cancellables)
    }
}

struct PostWithUserDetails: Identifiable {
    let id: Int
    let title: String
    let body: String
    let userName: String
    let userCompanyName: String
    
    init(post: Post, user: User) {
        self.id = post.id
        self.title = post.title
        self.body = post.body
        self.userName = user.name
        self.userCompanyName = user.company.name
    }
}
