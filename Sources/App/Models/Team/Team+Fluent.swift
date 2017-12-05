import Fluent

extension Team {
    public var members: Siblings<Team, Member, Pivot<Team, Member>> {
        return siblings()
    }
    
    public func add(members: [Int])throws {
        try Member.makeQuery().filter("id", in: members).all().forEach({ member in
            try self.members.add(member)
        })
    }
}
