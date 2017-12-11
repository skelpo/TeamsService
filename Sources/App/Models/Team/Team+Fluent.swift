import Fluent

extension Team {
    public func members()throws -> Query<TeamMember> {
        return try TeamMember.makeQuery().filter("team_id", self.id)
    }
    
    public func add(members: [Int])throws {
        try Member.makeQuery().filter("id", in: members).all().forEach({ member in
            try self.members.add(member)
        })
    }
}
