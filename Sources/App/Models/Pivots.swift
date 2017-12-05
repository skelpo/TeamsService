import Vapor
import Fluent

public typealias MemberTeam = Pivot<Team, Member>

extension Config {
    public func preparePivots() {
        self.preparations.append(MemberTeam.self)
    }
}
