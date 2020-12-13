//
//  MainView.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 12/12/2020.
//

import SwiftUI

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
                            Text("Meno").font(.title)
                            Text("Lukáš Schmelcer").font(.headline)
                        }
                        Spacer()
                        VStack(alignment:.leading){
                            Text("Narodený ").font(.title)
                            Text("23.1.1990").font(.headline)
                        }
                    }.padding(.bottom, 8)
                    HStack{
                        VStack(alignment:.leading){
                            Text("Pohlavie").font(.title)
                            Text("Muž").font(.headline)
                        }
                        Spacer()
                        VStack(alignment:.leading){
                            Text("Krvná sku.").font(.title)
                            Text("AB-").font(.headline)
                        }
                    }
                }.padding()
                
                ScrollView(.horizontal) {
                    if !self.viewModel.workouts.isEmpty{
                        HStack{
                            ForEach(self.viewModel.workouts){workout in
                                Button(action:{
                                    chosenWorkout = workout
                                    isPresented.toggle()
                                }){
                                    ZStack{
                                        VStack{
                                            Image(systemName: "").presentImage(fromUrl: URL(string: "https://vietnaminsider.vn/wp-content/uploads/2019/01/runnings.jpg")!)
                                                .resizable()
                                                .scaledToFill()
                                               
                                        }
                                        .shadow(color: .black, radius: 5, x: 1, y: 0)
                                        .frame(width:275, height: 175)
                                        
                                        .cornerRadius(40) // Workout 2
                                        VStack{
                                            Text(formatDate(workout.stratDateTime)).foregroundColor(.white)
                                        }
                                        
                                        .frame(width:275, height: 175)
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(40) // Workout 2
                                    }
                                }
                               
                            }
                        }
                    }
                }.onAppear{
                    
                    self.viewModel.getWorkouts()
                }
                Spacer()
                NavigationLink(destination: WorkoutView()){
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
            }.navigationTitle(Text("Tvoj deň Lukáš"))
            .padding()
            .sheet(isPresented: $isPresented){
                Text("Hello")
            }
        }
    }
    private func formatDate(_ date: Date?) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        if let date = date{
            return formatter.string(from: date)
        }
        return "Unknown"
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel.init())
    }
}
