//
//  ContentView.swift
//  HelloWorld
//
//  Created by 冯旭超 on 2020/3/18.
//  Copyright © 2020 冯旭超. All rights reserved.
//

import SwiftUI
import Combine

let scale = UIScreen.main.bounds.width / 414

struct ContentView: View {
    
    @State private var brain: CalculatorBarin = .left("0")
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(brain.output)
                .font(.system(size: 76))
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .trailing)
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
            CalculatorButtonPad(brain: self.$brain)
                .padding(.bottom)
        }.scaleEffect(scale)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView().previewDevice("iPhone SE")
        }
    }
}
#endif

struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width / 2)
        }
    }
}

struct CalculatorButtonRow: View {
    
    let row: [CalculatorButtonItem]
    
    @Binding var brain: CalculatorBarin
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName) {
                        self.brain = self.brain.apply(item: item)
                }
            }
        }
    }
    
}

struct CalculatorButtonPad: View {
    
    @Binding var brain: CalculatorBarin
    
    let pad: [[CalculatorButtonItem]] = [
        [.command(.clear), .command(.flip), .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id: \.self) { row in
                CalculatorButtonRow(row: row, brain: self.$brain)
            }
        }
    }
}
