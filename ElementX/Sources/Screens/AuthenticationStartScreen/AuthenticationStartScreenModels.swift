//
// Copyright 2022-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only
// Please see LICENSE in the repository root for full details.
//

import SwiftUI

// MARK: - Coordinator

enum AuthenticationStartScreenCoordinatorAction {
    case loginManually
    case loginWithQR
    case reportProblem
}

enum AuthenticationStartScreenViewModelAction {
    case loginManually
    case loginWithQR
    case reportProblem
}

struct AuthenticationStartScreenViewState: BindableState {
    var isQRCodeLoginEnabled = false
}

enum AuthenticationStartScreenViewAction {
    case loginManually
    case loginWithQR
    case reportProblem
}
