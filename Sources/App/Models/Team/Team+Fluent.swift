import Fluent

extension Team {
    var members: Siblings<Team, Member, Pivot<Team, Member>> {
        return siblings()
    }
}
