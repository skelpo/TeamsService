import HTTP
import JWT
import AuthProvider

/// `Request` helpers for getting data for JWT authentication.
extension Request {
    
    /// Get the JWT token from the 'Authorization` header in the request.
    func parseJWT() throws -> JWT {
        guard let authHeader = auth.header else {
            throw AuthenticationError.noAuthorizationHeader
        }
        
        guard let bearer = authHeader.bearer else {
            throw AuthenticationError.invalidBearerAuthorization
        }
        
        return try JWT(token: bearer.string)
    }
}
