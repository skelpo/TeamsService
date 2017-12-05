import Fluent

extension Team {
    public var members: Siblings<Team, Member, Pivot<Team, Member>> {
        return siblings()
    }
}
