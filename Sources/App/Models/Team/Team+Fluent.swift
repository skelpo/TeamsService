import Fluent

extension Team {
    public func members()throws -> Query<TeamMember> {
        return try TeamMember.makeQuery().filter("team_id", self.id)
    }
}
