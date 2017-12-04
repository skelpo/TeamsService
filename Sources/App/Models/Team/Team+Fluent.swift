import Fluent

extension Team {
    public var members: Children<Team, Member> {
        return children()
    }
}
