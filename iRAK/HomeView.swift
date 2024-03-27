//
//  HomeView.swift
//  iRAK Bubble Bar Home View
//
//  Created by 90310013 on 3/14/24.
//
// Credit to https://www.youtube.com/watch?v=Lw-vimpu6Cs for the tab view
//

import SwiftUI

var tabs = ["house", "archivebox", "bell", "message", "mic"]

struct HomeView: View {
  @State private var isSettingsPresented = false
  @State private var isProfilePresented = false
  @State var selectedTab = "house"
  
  var body: some View {
    NavigationView {
      ZStack {
        Color("BackgroundColor")
          .ignoresSafeArea()
        VStack {
          // Buttons on top
          HStack {
            Button(action: {
              self.isSettingsPresented.toggle()
            }) {
              ZStack {
                Circle()
                  .fill(Color("ForegroundColor"))
                  .shadow(radius: 3)
                  .frame(width: 40, height: 40)
                Image(systemName: "gearshape.fill")
              }
            }
            
            Spacer()
            
            Text(getTitle(sheetNum: selectedTab))
              .dynamicTypeSize(.xxxLarge)
              .bold()
            
            Spacer()
            
            Button(action: {
              self.isProfilePresented.toggle()
            }) {
              ZStack {
                Circle()
                  .fill(Color("ForegroundColor"))
                  .shadow(radius: 3)
                  .frame(width: 40, height: 40)
                Image(systemName: "person.circle.fill")
              }
            }
          }
          .padding(.horizontal)
          .dynamicTypeSize(.xxxLarge)
          
          // Tab view at the bottom
          TabsView(selectedTab: $selectedTab)
        }
        .sheet(isPresented: $isSettingsPresented) {
          Text("This is the settings view")
        }
        .sheet(isPresented: $isProfilePresented) {
          Text("This is the profile view")
        }
      }
    }
  }
  
  func getTitle(sheetNum: String) -> String {
    switch sheetNum {
    case "house":
      return "Game 1 title"
    case "archivebox":
      return "Game 2 title"
    case "bell":
      return "Game 3 title"
    case "message":
      return "Game 4 title"
    case "mic":
      return "Game 5 title"
    default:
      return "title"
    }
  }
}

struct TabsView: View {
  @Binding var selectedTab: String
  var bottomPadding: CGFloat = 0
  
  init(selectedTab: Binding<String>) {
    UITabBar.appearance().isHidden = true
    _selectedTab = selectedTab
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let safeAreaInsetsBottom = windowScene.windows.first?.safeAreaInsets.bottom {
      bottomPadding = safeAreaInsetsBottom
    }
  }
  
  @State var xAxis: CGFloat = 0
  @Namespace var animation
  
  var body: some View {
    VStack {
      TabView(selection: $selectedTab) {
        ZStack {
          Color("BackgroundColor")
            .ignoresSafeArea(.all, edges: .all)
          VStack {
            Image(systemName: "globe")
              .imageScale(.large)
              .foregroundColor(.accentColor)
            Text("Hello, world!")
          }
          .padding()
        }
        .tag("house")
        
        ContentView()
          .ignoresSafeArea(.all, edges: .all)
          .tag("archivebox")
        Color.red
          .ignoresSafeArea(.all, edges: .all)
          .tag("bell")
        Color("BackgroundColor")
          .ignoresSafeArea(.all, edges: .all)
          .tag("message")
        ZStack {
          Color("BackgroundColor")
            .ignoresSafeArea(.all, edges: .all)
          VStack {
            NavigationLink(destination: ContentView()) {
              Text("Go to another view")
            }
          }
          .padding()
        }
        .tag("mic")
      }
      HStack(spacing: 0) {
        ForEach(tabs, id: \.self) {image in
          GeometryReader { reader in
            Button(action: {
              withAnimation(.spring()) {
                selectedTab = image
                xAxis = reader.frame(in: .global).minX
              }
            }, label: {
              Image(systemName: image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(selectedTab == image ? getColor(image: image) : Color.gray)
                .padding(selectedTab == image ? 15 : 0)
                .background(Color("ForegroundColor").opacity(selectedTab == image ? 1 : 0).clipShape(Circle()).shadow(radius: 3)).offset(x: selectedTab == image ? -14 : 0)
                .matchedGeometryEffect(id: image, in: animation)
                .offset(x: reader.frame(in: .global).minX - reader.frame(in: .global).midX + 14, y: selectedTab == image ? -50 : 0)
            })
            .onAppear(perform: {
              if selectedTab == tabs.first {
                xAxis = reader.frame(in: .global).minX
              }
            })
          }
          .frame(width: 25, height: 30)
          if image != tabs.last{Spacer(minLength: 0)}
        }
      }
      .padding(.horizontal, 30)
      .padding(.vertical)
      .background(Color("ForegroundColor").clipShape(CustomShape(xAxis: xAxis)).cornerRadius(12).shadow(radius: 3))
      .padding(.horizontal)
      .padding(.bottom, bottomPadding)
    }
    .ignoresSafeArea(.all, edges: .bottom)
  }
}

func getColor(image: String) -> Color {
  switch image {
  case "house":
    return Color.green
  case "archivebox":
    return Color.blue
  case "bell":
    return Color.red
  case "message":
    return Color.yellow
  case "mic":
    return Color.purple
  default:
    return Color.gray
  }
}

struct CustomShape: Shape {
  var xAxis: CGFloat
  var animatableData: CGFloat {
    get{return xAxis}
    set{xAxis = newValue}
  }
  func path(in rect: CGRect) -> Path {
    return Path { path in
      path.move(to: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: rect.width, y: 0))
      path.addLine(to: CGPoint(x: rect.width, y: rect.height))
      path.addLine(to: CGPoint(x: 0, y: rect.height))
      
      let center = xAxis
      
      path.move(to: CGPoint(x: center - 50 , y: 0))
      
      let to1 = CGPoint(x: center, y: 35)
      let control1 = CGPoint(x: center - 25, y: 0)
      let control2 = CGPoint(x: center - 25, y: 35)
      
      let to2 = CGPoint(x: center + 50, y: 0)
      let control3 = CGPoint(x: center + 25, y: 35)
      let control4 = CGPoint(x: center + 25, y: 0)
      
      path.addCurve(to: to1, control1: control1, control2: control2)
      path.addCurve(to: to2, control1: control3, control2: control4)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
