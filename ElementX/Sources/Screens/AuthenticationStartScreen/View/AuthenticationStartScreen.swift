//
// Copyright 2022-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only
// Please see LICENSE in the repository root for full details.
//

import SwiftUI

/// The screen shown at the beginning of the onboarding flow.
struct AuthenticationStartScreen: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    @ObservedObject var context: AuthenticationStartScreenViewModel.Context
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: UIConstants.spacerHeight(in: geometry))
                
                content
                    .frame(width: geometry.size.width)
                    .accessibilityIdentifier(A11yIdentifiers.authenticationStartScreen.hidden)
                
                Spacer()
                
                buttons
                    .frame(width: geometry.size.width)
                    .padding(.bottom, UIConstants.actionButtonBottomPadding)
                    .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 0 : 16)
                    .padding(.top, 8)
                
                Spacer()
                    .frame(height: UIConstants.spacerHeight(in: geometry))
            }
            .frame(maxHeight: .infinity)
        }
        .navigationBarHidden(true)
        .background(Color.white)
    }
    
    var content: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 8) {
                Text(L10n.screenOnboardingWelcomeTitle)
                    .font(.custom("Avenir-Black", size: 32))
                    .foregroundColor(.compound.textPrimary)
                    .multilineTextAlignment(.center)

                Text(L10n.screenOnboardingWelcomeMessage)
                    .font(.custom("Avenir", size: 20))
                    .foregroundColor(.compound.textSecondary)
                    .multilineTextAlignment(.center)
                if verticalSizeClass == .regular {
                    AuthenticationStartLogo(isOnGradient: true)
                }
            }
            .padding()
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(.bottom)
        .padding(.horizontal, 16)
        .readableFrame()
    }
    
    /// The main action buttons.
    var buttons: some View {
        VStack(spacing: 16) {
            if context.viewState.isQRCodeLoginEnabled {
                Button { context.send(viewAction: .loginWithQR) } label: {
                    Text(L10n.screenOnboardingSignInWithQrCode)
                }
                .buttonStyle(CustomGreenButtonStyle())
                .accessibilityIdentifier(A11yIdentifiers.authenticationStartScreen.signInWithQr)
            }
            
            Button { context.send(viewAction: .loginManually) } label: {
                Text(context.viewState.isQRCodeLoginEnabled ? L10n.screenOnboardingSignInManually : L10n.actionContinue)
            }
            .buttonStyle(CustomGreenButtonStyle())
            .accessibilityIdentifier(A11yIdentifiers.authenticationStartScreen.signIn)
        }
        .padding(.horizontal, verticalSizeClass == .compact ? 128 : 24)
        .readableFrame()
    }
}

// MARK: - Previews

struct AuthenticationStartScreen_Previews: PreviewProvider, TestablePreview {
    static let viewModel = AuthenticationStartScreenViewModel()
    
    static var previews: some View {
        AuthenticationStartScreen(context: viewModel.context)
    }
}
