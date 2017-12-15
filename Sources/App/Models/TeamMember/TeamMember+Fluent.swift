import Fluent

extension TeamMember {
    public func teams()throws -> Query<Team> {
        let ids = try TeamMember.makeQuery().filter("userId", self.userID).all().map({ $0.teamID })
        return try Team.makeQuery().filter("id", in: ids)
    }
}
