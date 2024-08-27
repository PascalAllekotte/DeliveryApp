//
//  ContentView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//

import SwiftUI

struct ContentView: View {
    @State var currentTab: Tab = .Home
 //   @State private var showChatBotView: Bool = true
    @Namespace var animation
    

    var body: some View {
        VStack {
                TabView(selection: $currentTab){
                    HomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("bg").ignoresSafeArea())
                        .tag(Tab.Home)

                    SearchView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("bg").ignoresSafeArea())
                        .tag(Tab.Search)

                    CartView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("bg").ignoresSafeArea())
                        .tag(Tab.Cart)

                    ProfileView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("bg").ignoresSafeArea())
                        .tag(Tab.Profile)

                    IngredientsCall()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("bg").ignoresSafeArea())
                        .tag(Tab.ApiCall)
                }
                .overlay(
                    HStack(spacing: 0){
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            TabButton(tab: tab)
                        }
                        .padding(.vertical)
                        .padding(.bottom, getSafeArea().bottom == 0 ? 5 : (getSafeArea().bottom - 15))
                        .background(Color("bg2"))
                    },
                    alignment: .bottom
                )
                .ignoresSafeArea(.all, edges: .bottom)
            
        } //tes
    }

    func TabButton(tab: Tab) -> some View {
        GeometryReader { proxy in
            Button(action: {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            }, label: {
                VStack(spacing: 0) {
                    Image(systemName: currentTab == tab ? tab.rawValue + ".fill" : tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(currentTab == tab ? Color.black : .secondary)
                        .padding(currentTab == tab ? 15 : 0)
                        .background(
                            ZStack {
                                if currentTab == tab {
                                    MaterialEffect(style: .light)
                                        .clipShape(Circle())
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                    
                                    Text(tab.tabName).foregroundStyle(.black)
                                        .font(.footnote).padding(.top, 50)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                        .offset(y: currentTab == tab ? -35 : 0)
                }
            })
        }
        .frame(height: 25)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartViewModel())
}

enum Tab: String, CaseIterable {
    case Home = "storefront"
    case Search = "sparkle.magnifyingglass"
    case Cart = "basket"
    case Profile = "person.crop.circle"
    case ApiCall = "bolt"
    
    var tabName: String {
        switch self {
        case .Home:
            return "Home"
        case .Search:
            return "Search"
        case .Cart:
            return "Cart"
        case .Profile:
            return "Profile"
        case .ApiCall:
            return "mehr"
        }
    }
}

// safe area

extension View {
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
}

struct MaterialEffect: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
