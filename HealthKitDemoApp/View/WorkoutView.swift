//
//  WorkoutView.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 12/12/2020.
//

import SwiftUI

struct WorkoutView: View {
    @State var activityIsRunning = false
    @State var distance: Double = 0.0
    @State var activeTime: Double = 0.0
    @ObservedObject var source = WorkoutViewModel.init()
    var timer = TimerManager()
    var manager = LocationManager()
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
            if activityIsRunning{
                self.source.startCapturing()
                self.timer.runTimer(every: 1, unit: .second, handler:{
                    self.source.actualizeLocation()
                    self.activeTime += 1
                })
            }else{
                self.timer.endTimer()
                self.source.stopCapturing()
                // Save data to healthkit here
            }
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
