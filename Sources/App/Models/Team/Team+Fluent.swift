import Fluent

extension Team {
    var members: Children<Team, Member> {
        return children()
    }
}
