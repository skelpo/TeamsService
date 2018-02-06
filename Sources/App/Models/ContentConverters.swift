struct Status: Codable {
    let status: Int
}

struct UserID: Codable {
    let id: Int
}

struct MemberData: Codable {
    let newStatus: Int
    let userId: Int
}
