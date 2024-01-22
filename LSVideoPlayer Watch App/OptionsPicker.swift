//
//  OptionsPicker.swift
//  LSVideoPlayer Watch App
//
//  Created by 凌嘉徽 on 2024/1/21.
//

import SwiftUI


struct DoublePicker: View {
    @Binding var selectionMode:Int
    var pickerInlineTitle:String
    var pickerInlineSFSymbol:String
    var item1Name:String
    var item2Name:String
    var item3Name:String?
    var tip:String?
    @State var show = false
    
    var body: some View {
        Label(pickerInlineTitle, systemImage: pickerInlineSFSymbol)
            .beButton {
                show = true
            }
        .sheet(isPresented: $show, content: {
           SwipeSheet(showMe: $show, content: { name,action in
               VStack {
                   List {
                           Button(action: {
                               withAnimation(.easeOut) {
                                   selectionMode = 1
                               }
                           }) {
                               VStack {
                                   HStack {
                                       Text(item1Name)
                                           .actionOn(name: name, action: action)
                                       Spacer()
                                       if selectionMode == 1 {
                                           Image(systemName: "checkmark.circle")
                                       }
                                   }
                               }
                           }
                          
                           Button(action: {
                               withAnimation(.easeOut) {
                                   selectionMode = 2
                               }
                           }) {
                               VStack {
                                   HStack {
                                       Text(item2Name)
                                       Spacer()
                                       if selectionMode == 2 {
                                           Image(systemName: "checkmark.circle")
                                       }
                                       
                                   }
                              
                               }
                           }
                       if let item3Name {
                           Button(action: {
                               withAnimation(.easeOut) {
                                   selectionMode = 3
                               }
                           }) {
                               VStack {
                                   HStack {
                                       Text(item3Name)
                                       Spacer()
                                       if selectionMode == 3 {
                                           Image(systemName: "checkmark.circle")
                                       }
                                       
                                   }
                                   
                               }
                           }
                       }
                       if let tip {
                           Text(tip)
                       }
                   }
               }
               
           })
        })
    }
}
