// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import BackgroundTasks
import FactoryKit
import Foundation

/// Protocol abstracting BGTask for unit testability without simulator traps.
public protocol BackgroundTaskRepresentable: AnyObject, Sendable {
    var expirationHandler: (() -> Void)? { get set }
    func setTaskCompleted(success: Bool)
}

extension BGTask: @retroactive @unchecked Sendable, BackgroundTaskRepresentable {}

/// Background data synchronization task using BGTaskScheduler.
public enum {{name.pascalCase()}}SyncTask {
    public static let identifier = "com.danhdue.{{name.snakeCase()}}.sync"

    /// Registers the background task identifier with the BGTaskScheduler.
    /// Must be invoked before application finishLaunching completes.
    public static func register(using scheduler: BGTaskScheduler = .shared) {
        scheduler.register(forTaskWithIdentifier: identifier, using: nil) { task in
            _ = handleTask(task)
        }
    }

    /// Handles execution of the background synchronization task.
    @discardableResult
    public static func handleTask(
        _ task: BackgroundTaskRepresentable,
        syncUseCase: SyncDataUseCase = {{name.pascalCase()}}Container.shared.syncDataUseCase()
    ) -> Task<Void, Never> {
        let workTask = Task {
            do {
                try Task.checkCancellation()
                try await syncUseCase.execute()
                try Task.checkCancellation()
                task.setTaskCompleted(success: true)
            } catch {
                task.setTaskCompleted(success: false)
            }
        }

        task.expirationHandler = {
            workTask.cancel()
            task.setTaskCompleted(success: false)
        }

        return workTask
    }
}
