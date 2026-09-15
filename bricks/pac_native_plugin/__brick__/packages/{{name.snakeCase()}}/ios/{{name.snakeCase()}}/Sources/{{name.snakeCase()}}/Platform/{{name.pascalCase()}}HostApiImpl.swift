// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import FactoryKit
import Foundation
import UIKit

/// Implementation of Pigeon Host API delegating calls to Clean Architecture UseCases.
public final class {{name.pascalCase()}}HostApiImpl: {{name.pascalCase()}}HostApi, @unchecked Sendable {
    private let getDataUseCase: GetDataUseCase

    public init(getDataUseCase: GetDataUseCase = {{name.pascalCase()}}Container.shared.getDataUseCase()) {
        self.getDataUseCase = getDataUseCase
    }

    public func getPlatformVersion() throws -> String {
        MainActor.assumeIsolated {
            "iOS " + UIDevice.current.systemVersion
        }
    }

    public func getData(completion: @escaping @Sendable (Result<Pigeon{{name.pascalCase()}}Data, Error>) -> Void) {
        Task {
            do {
                let data = try await getDataUseCase.execute()
                let message = Pigeon{{name.pascalCase()}}Data(
                    id: data.id,
                    title: data.title,
                    timestamp: Int64(data.timestamp.timeIntervalSince1970 * 1000)
                )
                completion(.success(message))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
