//
//  DateScrollsView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/18/25.
//

import SwiftUI
import SwiftData

struct DateScrollsView: View {
    
    @EnvironmentObject var taskManager: TaskManager
    
    @Query var tasks: [TaskModel]
    
    @State private var allDates = [Date]()
    @State private var dates = [Date]()
    @State private var lastShownIndex = 0
    @State private var scrollingDirection = 0
    
    var body: some View {
        
        let today = allDates.first(where: { $0.isToday(Date.now) })
        
        ScrollViewReader { reader in
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem()], spacing: 20.0) {
                    Spacer()
                    ForEach(taskManager.showJustTaskDays ? dates : allDates, id: \.self) { date in
                        Button {
                            taskManager.selectedDate = date
                        } label: {
                            ZStack {
                                if date.isFirstDayOrLastDayOfMonth() || date.isToday(taskManager.selectedDate) || date.isToday(Date.now) {
                                    HStack {
                                        Text(date.getMonth())
                                            .font(.caption2)
                                            .rotationEffect(Angle(degrees: -90.0))
                                            .padding(.horizontal, -8)
                                        Spacer()
                                    }
                                }
                                VStack(spacing: 8) {
                                    Text(date.getShortWeekdaySymbol())
                                        .font(.headline)
                                    Text(date.getDay())
                                        .font(.headline)
                                }
                                if dates.containedByDay(date) {
                                    VStack {
                                        Spacer()
                                        Circle()
                                            .frame(width: 5, height: 5)
                                    }
                                }
                            }
                            .foregroundStyle(date.isToday(taskManager.selectedDate) ? Color.selectedDate : Color.nonSelectedDate)
                            .frame(width: 45.0, height: 75)
                            .background {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundStyle(date.isToday(taskManager.selectedDate) ? Color.selectedDateBG : Color.clear)
                                        .padding(-8)
                                    if date.isToday(Date.now) {
                                        RoundedRectangle(cornerRadius: 18)
                                            .strokeBorder(Color.selectedDateBG, lineWidth: 3.0, antialiased: true)
                                            .padding(-8)
                                    }
                                }
                            }
                            .animation(.spring(), value: taskManager.selectedDate)
                        }
                        .id(date)
                        .onAppear {
                            if let index = allDates.firstIndex(where: { $0 == date }) {
                                self.lastShownIndex = index
                            }
                        }
                    }
                    Spacer()
                }
            }
            .onChange(of: tasks, { oldValue, newValue in
                dates = Set(tasks.map({ $0.dueDate.getDateWithoutTime() })).sorted(by: { $0 < $1 })
            })
            .scrollIndicators(.hidden, axes: .horizontal)
            .frame(height: 100)
            .onAppear {
                dates = Set(tasks.map({ $0.dueDate.getDateWithoutTime() })).sorted(by: { $0 < $1 })
                taskManager.selectedDate = Date.now
                allDates = taskManager.selectedDate.getDaysBefore(5)
                allDates.append(taskManager.selectedDate)
                allDates.append(contentsOf: taskManager.selectedDate.getDaysAfter(5))
            }
            .onChange(of: taskManager.shouldShowToday) { beforeState, currentState in
                if let today, currentState {
                    withAnimation {
                        reader.scrollTo(today, anchor: .center)
                        taskManager.shouldShowToday.toggle()
                    }
                }
            }
            .onChange(of: lastShownIndex) { oldValue, newValue in
//                print(oldValue, " ==> ", newValue, "   ===>  ", "count:", allDates.count, "  =>  ", "direction:", scrollingDirection )
                if oldValue > newValue && newValue == 0 {
                    // is going backward
                    guard let first = allDates.first else {
                        return
                    }
                    allDates.insert(contentsOf: first.getDaysBefore(5), at: 0)
                    scrollingDirection -= 1
                } else if newValue > oldValue && newValue == allDates.count - 1 {
                    // is leaping forward
                    guard let last = allDates.last else {
                        return
                    }
                    allDates.append(contentsOf: last.getDaysAfter(5))
                    scrollingDirection += 1
                }
            }
        }
    }
}




/*
 .onChange(of: scrollingDirection) { oldValue, newValue in
     if scrollingDirection <= -10 {
         // way too far backward
         let firstIndex = allDates.index(15, offsetBy: 0)
         let lastIndex = allDates.index(15, offsetBy: allDates.count - 15)
         allDates.removeSubrange(firstIndex..<lastIndex)
         print("Indexes removed from backward!")
         lastShownIndex = 1
         return
     }
     if scrollingDirection >= 10 {
         // way too far forward
         let startIndex = allDates.startIndex
         let beforeIndex = allDates.index(startIndex, offsetBy: allDates.count - 15)
         allDates.removeSubrange(startIndex..<beforeIndex)
         print("Indexes removed from backward!")
         lastShownIndex = allDates.count - 1
         return
     }
 }
 */
