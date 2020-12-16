//
//  MainView.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 12/12/2020.
//

import SwiftUI
import HealthKit
struct MainView: View {
    @State var isPresented = false
    @State var chosenWorkout: Workout?
    
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    HStack{
                        VStack(alignment:.leading){
                            Text("Vek").font(.title)
                            Text("\(self.viewModel.age ?? 0)").font(.headline)
                        }
                        Spacer()
                        VStack(alignment:.leading){
                            Text("Pohlavie").font(.title)
                            Text(getSex(self.viewModel.sex)).font(.headline)
                        }
                    }.padding(.bottom, 8)
                }.padding()
                
                List{
                        ForEach(self.viewModel.workouts, id:\.self){ workout in
                            NavigationLink(
                                destination: WorkoutDetailworkout(workout: workout),
                                label: {
                                    Text(formatDate(workout.stratDateTime))
                                })
                        }
                }.onAppear(perform: { // Pri zobrazeni je nutne hodnoty nacitat cez VM
                    self.viewModel.getWorkouts()
                    self.viewModel.getUserInfo()
                })
                    
                Spacer()
                NavigationLink(destination: WorkoutView(healthModel: self.viewModel)){
                    HStack{
                        Text("Nová aktivita").font(.headline)
                        Image(systemName: "plus")
                    }
                    .foregroundColor(Color.init(red: 152/255, green: 172/255, blue: 248/255))
                    .padding()
                    .background(Color.init(red: 190/255, green: 220/255, blue: 250/255))
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.init(red: 152/255, green: 172/255, blue: 248/255), lineWidth: 3))
                }
                Spacer()
            }.navigationTitle(Text("Vaše informácie"))
            .padding()
        }
    }
    
    
    
    // Funkcia na prevedenie HKBiologicalSex na textovú reprezentaciu
    private func getSex(_ sex: HKBiologicalSex?) -> String{
        if let sex = sex{
            switch sex {
            case .female:
                return "Female"
            case .male:
                return "Male"
            case .other:
                return "Other"
            default:
                return "Not set"
            }
        }
        return "Not set"

    }
    // Funkcia na formatovanie casu
    private func formatDate(_ date: Date?) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        if let date = date{
            return formatter.string(from: date)
        }
        return "Unknown"
        
    }
}

// Detailny view treningu
struct WorkoutDetailworkout: View {
    @State var workout: Workout?
    
    var body: some View {
        VStack{
            Text("Vzdialenosť \(workout?.distance ?? 0) km")
            Text((secondsToHoursMinutesSeconds(seconds: Int(workout?.duration ?? 0))))
            Text(getAvHeartRate(rate: workout?.heartRate ?? []))
            Text("\(workout?.distance ?? 0)")
            Text("Spálené kalórie \(workout?.calories ?? 0)")
        }
    }
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> String{
        return "\(seconds / 3600) hodin : \((seconds % 3600) / 60) min : \((seconds % 3600) % 60) sekund"
    }
    
    private func getAvHeartRate(rate: [Double]) -> String {
        let total = rate.reduce(0, +)
        return "Priemerný tep je \(total/Double(rate.count)) bpm"
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel.init())
    }
}
