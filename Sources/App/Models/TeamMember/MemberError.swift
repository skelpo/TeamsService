import Vapor

/// Errors that can occur when interacting with the `TeamMember` model.
struct MemberError: Debuggable, AbortError {
    
    ///
    var identifier: String
    
    /// An API friendly versions of the error.
    /// `APIErrorMiddleware` uses this property to generate the error JSON.
    var reason: String
    
    /// The HTTP status to use when the
    /// error is caught by the `APIErrorMiddleware`.
    var status: HTTPResponseStatus
}
