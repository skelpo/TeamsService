import Fluent

extension Member {
    public var parent: Parent<Member, Team> {
        return parent(id: self.teamID)
    }
}
