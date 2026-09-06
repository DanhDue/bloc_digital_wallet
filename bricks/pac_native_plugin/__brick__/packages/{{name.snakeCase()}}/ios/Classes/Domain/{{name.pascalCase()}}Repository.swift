import Foundation

public protocol {{name.pascalCase()}}Repository {
    func getStatus() async throws -> String
}
