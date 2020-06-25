//
//  ContentView.swift
//  Amigo
//
//  Created by אביעד on 07/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//
import  MapKit
import SwiftUI

struct ContentView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    var body: some View {
    ZStack {
        MapView(centerCoordinate: $centerCoordinate)
            .edgesIgnoringSafeArea(.all)
        Circle()
            .fill(Color.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
