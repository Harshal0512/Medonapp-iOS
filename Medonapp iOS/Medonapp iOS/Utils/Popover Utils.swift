//
//  Popover Utils.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 07/11/22.
//

import Foundation
import SwiftUI



//var popover = Popover { PopoverView() }
//popover.attributes.sourceFrame = { [weak view] in
//    view.windowFrame()
//}
//popover.attributes.position = .relative(popoverAnchors: [.top])
//popover.attributes.presentation.animation = .spring()
//popover.attributes.presentation.transition = .move(edge: .top)
//popover.attributes.dismissal.animation = .spring(response: 3, dampingFraction: 0.8, blendDuration: 1)
//popover.attributes.dismissal.transition = .move(edge: .top)
//popover.attributes.dismissal.mode = [.dragUp]
//popover.attributes.dismissal.dragDismissalProximity = 0.1
//
//present(popover)
//DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//    popover.dismiss()
//}

struct PopoverView: View {
    var body: some View {
        HStack {
            ExampleImage("bell.fill", color: UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
            Text("The OTP you entered is incorrect, please try again.")
                .font(.custom("NunitoSans-Regular", size: 15))
            Spacer()
        }
        .frame(maxWidth: 600)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color(uiColor: UIColor.label.withAlphaComponent(0.25)), lineWidth: 1)
        )
    }
}

struct ExampleImage: View {
    let imageName: String
    let color: UIColor

    init(_ imageName: String, color: UInt = 0x00AEEF) {
        self.imageName = imageName
        self.color = UIColor(hex: color)
    }

    init(_ imageName: String, color: UIColor) {
        self.imageName = imageName
        self.color = color
    }

    var body: some View {
        Image(systemName: imageName)
            .foregroundColor(.white)
            .frame(width: 36, height: 36)
            .background(
                LinearGradient(
                    colors: [
                        Color(uiColor: color),
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .cornerRadius(10)
    }

    static var tip: ExampleImage {
        ExampleImage("lightbulb", color: 0x00C300)
    }

    static var warning: ExampleImage {
        ExampleImage("exclamationmark.triangle.fill", color: 0xEBD43D)
    }
}
