//
//  ContentView.swift
//  kumparantest2021
//
//  Created by irfan wahendra on 14/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.postsWithUserDetails) { postWithUserDetails in
                VStack(alignment: .leading) {
                    Text(postWithUserDetails.title)
                        .font(.headline)
                    Text(postWithUserDetails.body)
                        .font(.subheadline)
                    Text("User: \(postWithUserDetails.userName)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("Company: \(postWithUserDetails.userCompanyName)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Posts")
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

