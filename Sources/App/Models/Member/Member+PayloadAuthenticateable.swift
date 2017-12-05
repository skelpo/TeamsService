import JWTProvider

extension Member: PayloadAuthenticatable {
    public typealias PayloadType = Member
    
    public static func authenticate(_ payload: Member) throws -> Member {
        return payload
    }
}
