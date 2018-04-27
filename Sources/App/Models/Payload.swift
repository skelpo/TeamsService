import Foundation
import JWT

/// A data type used to decode
/// the payload for a JWT token.
struct Payload: JWTPayload {
    let permissionLevel: Int
    let firstname: String
    let lastname: String
    let language: String
    let exp: Date
    let iat: Date
    let email: String
    let id: Int
    let teamIDs: [Int]?
    
    func verify() throws {
        try ExpirationClaim(value: exp).verify()
    }
}
