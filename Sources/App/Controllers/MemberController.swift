import Vapor

public final class MemberController {
    public let builder: RouteBuilder
    
    public init(builder: RouteBuilder) {
        self.builder = builder.grouped("users")
    }
}
