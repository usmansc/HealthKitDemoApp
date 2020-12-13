//
//  WorkoutView.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 12/12/2020.
//

import SwiftUI

struct WorkoutView: View {
    @State var activityIsRunning = false
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    HStack{
                        Text("Ubehnutý čas")
                        Text("00:00 min:sec")
                    }
                    HStack{
                        Text("Vzdialenosť")
                        Text("0 km")
                    }
                    HStack{
                        Text("Spálené kalórie")
                        Text("0 kcal")
                    }
                    HStack{
                        Text("Trvanie")
                        Text("16:30 - 17:45")
                    }
                    HStack{
                        Text("Dátum")
                        Text("12.12.2020")
                    }
                    
                    Divider()
                    
                    
                }
            }
        }.navigationBarItems(trailing: Button(action:{
            activityIsRunning.toggle()
            print("Started new activity")
        }){
            activityIsRunning ? Text("Zastaviť aktivitu") : Text("Spustit aktivitu")
        })
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
