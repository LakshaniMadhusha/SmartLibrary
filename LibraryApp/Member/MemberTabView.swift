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

<<<<<<< HEAD
=======
            HallsListView()
                .tabItem { Label("Halls", systemImage: "chair.lounge.fill") }

>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
            RewardsView()
                .tabItem { Label("Rewards", systemImage: "trophy.fill") }

            ProfileView(user: user)
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
<<<<<<< HEAD
        .tint(Color.accent)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .environment(\.symbolVariants, .fill)
=======
        .tint(.primary)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.cardBg, for: .tabBar)
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
    }
}

