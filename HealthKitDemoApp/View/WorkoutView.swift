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
    @State var activeTime: Int = 0
    @State var kcal: Double = 0.0
    @State var duration: String = ""
    @State var begin: Date = Date()
    @ObservedObject var source = WorkoutViewModel.init()
    @ObservedObject var healthModel: MainViewModel
    @State var alert = false
    @State var message = ""
    var timer = TimerManager()
    var manager = LocationManager()
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    HStack{
                        Text("Ubehnutý čas")
                        Text("\(activeTime) sec")
                    }
                    HStack{
                        Text("Vzdialenosť")
                        Text("\(distance) m")
                    }
                    HStack{
                        Text("Spálené kalórie")
                        Text("\(kcal) kcal")
                    }
                    HStack{
                        Text("Trvanie")
                        Text(duration)
                    }
                    
                    Divider()
                    
                    
                }
            }
        }
        .navigationBarItems(trailing: Button(action:{
            activityIsRunning.toggle()
            if activityIsRunning{
                self.begin = Date()
                self.source.startCapturing()
                self.timer.runTimer(every: 1, unit: .second, handler:{
                    self.source.actualizeLocation()
                    self.distance = self.source.distanceFromStart
                    self.activeTime += 1
                })
            }else{
                self.duration = formatDuration(since: self.begin, until: Date())
                self.timer.endTimer()
                self.source.stopCapturing()
                self.kcal = distance / 1000 * 72 * 1.038 // Km * vaha * konstanta
                healthModel.saveWorkout(of: .running, from: Workout(distance: self.distance, stratDateTime: self.begin, endDateTime: Date(), duration: TimeInterval.init(self.activeTime), heartRate: [], calories: self.kcal)) { succ in
                    alert.toggle()
                    if succ{
                        self.message = "Data boli ulozene"
                    }else{
                        self.message = "Data sa nepodarilo ulozit"
                    }
                }
            }
        }){
            activityIsRunning ? Text("Zastaviť aktivitu") : Text("Spustit aktivitu")
        })

    }
    
    private func formatDuration(since: Date, until: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return  "\(formatter.string(from: since)) - \(formatter.string(from:until))"
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(healthModel: MainViewModel())
    }
}
