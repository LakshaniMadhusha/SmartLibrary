import SwiftUI

struct MemberTabView: View {
    let user: AppUser

    var body: some View {
        TabView {
            HomeView(user: user)
                .tabItem { Label("Home", systemImage: "house.fill") }

            DiscoverView()
                .tabItem { Label("Discover", systemImage: "magnifyingglass") }

            LibraryView()
                .tabItem { Label("Library", systemImage: "books.vertical.fill") }

            HallsListView()
                .tabItem { Label("Halls", systemImage: "chair.lounge.fill") }

            RewardsView()
                .tabItem { Label("Rewards", systemImage: "trophy.fill") }

            ProfileView(user: user)
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(.primary)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.cardBg, for: .tabBar)
    }
}

