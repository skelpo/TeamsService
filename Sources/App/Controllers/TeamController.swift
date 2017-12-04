import Vapor

public final class TeamController {
    let builder: RouteBuilder
    
    public init(drop: Droplet) {
        self.builder = drop.grouped("teams")
    }
    
    public func configureRoutes() {
        
    }
}
