import Foundation

public class {{name.pascalCase()}}DataSource: {{name.pascalCase()}}Repository {
    public init() {}

    public func getStatus() async throws -> String {
        return "Active"
    }
}
