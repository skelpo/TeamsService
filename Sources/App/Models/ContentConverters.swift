/// These models are used to convert a `Request` body to a readable type. Example:
///     try request.content.decode(Status.self).map(to: Void.self, { (body) in }
/// The types propertie's names have to match the body's value keys, as data encoding is
/// used to convert to the given type.

// ==---------

/// Gets the `status` value from a request's body.
struct Status: Codable {
    let status: Int
}

/// Get the `id` property from the request's body.
struct UserID: Codable {
    let id: Int
}

/// Get the data from a request's body to create a `TeamMember` that is `admin`.
/// Gets the `user_id` and `new_status` values.
struct MemberData: Codable {
    let newStatus: Int
    let userId: Int
    
    /// Custom coding keys, becuase we accept a request body
    /// with snake_case keys.
    ///
    /// We could use `decoder.keyDecodingStrategy = .convertFromSnakeCase`,
    /// but since we only have 2 properties, I like this solution better.
    enum CodingKeys: String, CodingKey {
        case newStatus = "new_status"
        case userId = "user_id"
    }
}
