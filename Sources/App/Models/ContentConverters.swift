import Vapor

/// These models are used to convert a `Request` body to a readable type. Example:
///
///     try request.content.decode(Status.self).map(to: Void.self, { (body) in }
///
/// The types property names have to match the body's value keys, as data encoding is
/// used to convert to the given type.
///
/// Some of these types are used to return data from a route. Theses types conform to `Content`.

// ==---------

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

/// A response's body for a successful DELETE request.
struct ModelDeletedResponse: Content {
    
    /// The status code of the response. According to [RFC 7231](http://devdocs.io/http/rfc7231#section-6.3.5), this should be 204 (No Content) for a deletion.
    let status: HTTPStatus = .noContent
    
    /// An optional human readable message, confirming a successful deletion.
    let message: String?
}

/// The response's body when a new team is created.
/// We have this type because we need to send a message to the client that they shoudl re-authenticate.
struct TeamCreatedResponse: Content {
    
    /// A human readable message instructing the client to do something.
    let message: String
    
    /// The team that was created.
    let team: Team
}
