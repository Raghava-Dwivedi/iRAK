//
//  HomeView.swift
//  iRAK Bubble Bar Home View
//
//  Created by 90310013 on 3/14/24.
//
// Credit to https://www.youtube.com/watch?v=Lw-vimpu6Cs for the tab view
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    VStack {
      Home()
    }
  }
}

struct Home: View {
  @State var selectedTab = "house"
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  @State var xAxis: CGFloat = 0
  @Namespace var animation
  
  var body: some View {
    ZStack {
      getColor(image: selectedTab)
        .ignoresSafeArea()
      VStack {
        TabView(selection: $selectedTab) {
          ZStack {
            Color.green
              .ignoresSafeArea(.all, edges: .all)
            VStack {
              Text("Hi")
            }
            .tag("house")
          }
          
          Color.blue
            .ignoresSafeArea(.all, edges: .all)
            .tag("archivebox")
          Color.red
            .ignoresSafeArea(.all, edges: .all)
            .tag("bell")
          Color.yellow
            .ignoresSafeArea(.all, edges: .all)
            .tag("message")
          Color.orange
            .ignoresSafeArea(.all, edges: .all)
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
                  .background(Color.white.opacity(selectedTab == image ? 1 : 0).clipShape(Circle())).offset(x: selectedTab == image ? -14 : 0)
                  .matchedGeometryEffect(id: image, in: animation)
                  .offset(x: reader.frame(in: .global).minX - reader.frame(in: .global).midX + 14, y: selectedTab == image ? -50 : 0)
              })
              .onAppear(perform: {
                if image == tabs.first {
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
        .background(Color.white.clipShape(CustomShape(xAxis: xAxis)).cornerRadius(12))
        .padding(.horizontal)
        .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
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
      return Color.orange
    default:
      return Color.gray
    }
  }
}

var tabs = ["house", "archivebox", "bell", "message", "mic"]

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
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