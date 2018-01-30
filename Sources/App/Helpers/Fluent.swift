import Fluent

// TODO: These operators should be deleted when vapor/fluent PR #360 is merged.
// https://github.com/vapor/fluent/pull/360

public func == <Model, Value>(lhs: KeyPath<Model, Value>, rhs: Value) -> ModelFilterMethod<Model>
    where Model: Fluent.Model, Value: Encodable & Equatable
{
    return ModelFilterMethod<Model>(
        method: .compare(lhs.makeQueryField(), .equality(.equals), .value(rhs))
    )
}

/// Model.field? == value
public func == <Model, Value>(lhs: KeyPath<Model, Value?>, rhs: Value) -> ModelFilterMethod<Model>
    where Model: Fluent.Model, Value: Encodable & Equatable
{
    return ModelFilterMethod<Model>(
        method: .compare(lhs.makeQueryField(), .equality(.equals), .value(rhs))
    )
}

/// MARK: .notEquals

/// Model.field != value
public func != <Model, Value>(lhs: KeyPath<Model, Value>, rhs: Value) -> ModelFilterMethod<Model>
    where Model: Fluent.Model, Value: Encodable & Equatable
{
    return ModelFilterMethod<Model>(
        method: .compare(lhs.makeQueryField(), .equality(.notEquals), .value(rhs))
    )
}
