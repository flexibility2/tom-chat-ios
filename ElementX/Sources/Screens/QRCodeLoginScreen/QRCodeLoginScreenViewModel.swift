//
// Copyright 2022 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import AVFoundation
import Combine
import SwiftUI

typealias QRCodeLoginScreenViewModelType = StateStoreViewModel<QRCodeLoginScreenViewState, QRCodeLoginScreenViewAction>

class QRCodeLoginScreenViewModel: QRCodeLoginScreenViewModelType, QRCodeLoginScreenViewModelProtocol {
    private let qrCodeLoginService: QRCodeLoginServiceProtocol
    private let application: ApplicationProtocol
    
    private let actionsSubject: PassthroughSubject<QRCodeLoginScreenViewModelAction, Never> = .init()
    var actionsPublisher: AnyPublisher<QRCodeLoginScreenViewModelAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }

    init(qrCodeLoginService: QRCodeLoginServiceProtocol,
         application: ApplicationProtocol) {
        self.qrCodeLoginService = qrCodeLoginService
        self.application = application
        super.init(initialViewState: QRCodeLoginScreenViewState())
        
        context.$viewState
            // not using compactMap before remove duplicates because if there is an error, and the same code needs to be rescanned the transition to nil to clean the state would get ignored.
            .map(\.bindings.qrResult)
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] qrData in
                self?.state.state = .scan(.connecting)
                Task {
                    do {
                        MXLog.info("Scanning QR code: \(qrData)")
                        try await qrCodeLoginService.scan(data: qrData)
                    } catch {
                        MXLog.error("Failed to scan the QR code:\(error)")
                        self?.state.state = .scan(.invalid)
                    }
                }
            }
            .store(in: &cancellables)
        
        qrCodeLoginService.qrLoginProgressPublisher
            .sink { progress in
                MXLog.info("QR Login Progress changed to: \(progress)")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public
    
    override func process(viewAction: QRCodeLoginScreenViewAction) {
        switch viewAction {
        case .cancel:
            actionsSubject.send(.cancel)
        case .startScan:
            Task { await startScanIfPossible() }
        case .openSettings:
            application.openAppSettings()
        }
    }
    
    private func startScanIfPossible() async {
        state.bindings.qrResult = nil
        state.state = await qrCodeLoginService.requestAuthorizationIfNeeded() ? .scan(.scanning) : .error(.noCameraPermission)
    }
    
    /// Only for mocking initial states
    fileprivate init(state: QRCodeLoginState) {
        qrCodeLoginService = QRCodeLoginServiceMock(configuration: .init())
        application = ApplicationMock()
        super.init(initialViewState: .init(state: state))
    }
}

extension QRCodeLoginScreenViewModel {
    static func mock(state: QRCodeLoginState) -> QRCodeLoginScreenViewModel {
        QRCodeLoginScreenViewModel(state: state)
    }
}
