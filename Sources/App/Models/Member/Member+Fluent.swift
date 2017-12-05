import Fluent

extension Member {
    public var teams: Siblings<Member, Team, Pivot<Team, Member>> {
        return siblings()
    }
}
