import Fluent

extension Team {
    public func members()throws -> Query<TeamMember> {
        return try TeamMember.makeQuery().filter("teamId", self.id)
    }
}
