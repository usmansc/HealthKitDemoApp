//
//  MainView.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 12/12/2020.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    Text("Informacie")
                }
                HStack{
                    VStack{
                        Text("Workout 1")
                    }
                    VStack{
                        Text("Workout 2")
                    }
                }
                Divider()
                VStack{
                    Button(action:{
                        
                    }){
                        Text("Novy Workout")
                    }
                }
            }.navigationTitle(Text("Tvoj deň Lukáš"))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
