//
// Copyright 2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only
// Please see LICENSE in the repository root for full details.
//

import SwiftUI

struct CustomGreenButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let backgroundColor = configuration.isPressed ? Color(red: 35 / 255, green: 234 / 255, blue: 34 / 255).opacity(0.7) : Color(red: 35 / 255, green: 234 / 255, blue: 34 / 255)
        return configuration.label
            .font(.custom("Avenir-Black", size: 18))
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(.black)
            .cornerRadius(16)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
