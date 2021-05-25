//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Maintains list of query parameters.
public struct QueryParameters: Equatable {
    private let params: [QueryParameter]

    public init(_ params: [QueryParameter] = []) {
        self.params = params
    }

    /// Returns the first query parameter with the given name.
    ///
    /// - Parameters:
    ///   - name: Query parameter name.
    public func first(named parameterName: String) -> QueryParameter? {
        for parameter in params where parameter.name == parameterName {
            return parameter
        }
        return nil
    }

    /// Returns value of the first query parameter with the given name.
    ///
    /// - Parameters:
    ///   - name: Query parameter name.
    public func firstValue(named parameterName: String) -> String? {
        first(named: parameterName)?.value
    }

    /// Returns list of query parameters with the given name.
    ///
    /// - Parameters:
    ///   - name: Query parameter name.
    public func all(named parameterName: String) -> [QueryParameter] {
        var parameterList: [QueryParameter] = []
        for parameter in params where parameter.name == parameterName {
            parameterList.append(parameter)
        }
        return parameterList
    }

    /// Returns list of query parameter values with the given query parameter name.
    ///
    /// - Parameters:
    ///   - name: Query parameter name.
    public func allValues(named parameterName: String) -> [String] {
        var parameterValuesList: [String] = []
        for parameter in params where parameter.name == parameterName {
            parameterValuesList.append(parameter.value)
        }
        return parameterValuesList
    }

    /// Returns list of all query parameters.
    public func all() -> [QueryParameter] {
        params
    }

    /// Returns list of all query parameter values.
    public func allValues() -> [String] {
        params.map { $0.value }
    }

    /// Returns list of all query parameter names.
    public func allNames() -> [String] {
        params.map { $0.name }
    }
}

extension QueryParameters: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        self = QueryParameters(elements.map { QueryParameter(name: $0.0, value: $0.1) })
    }
}

extension QueryParameters: Sequence {
    public func makeIterator() -> QueryParametersIterator {
        QueryParametersIterator(self)
    }
}

public struct QueryParametersIterator: IteratorProtocol {
    private let paramsList: [QueryParameter]
    private var paramsListCurrentIndex: Int

    init(_ paramsList: QueryParameters) {
        self.paramsList = paramsList.all()
        paramsListCurrentIndex = zero
    }

    /// Returns the next header in the headers list; nil if none exist.
    public mutating func next() -> QueryParameter? {
        guard paramsListCurrentIndex < paramsList.count else {
            return nil
        }
        let nextParamIndex = paramsListCurrentIndex
        paramsListCurrentIndex += 1
        return paramsList[nextParamIndex]
    }
}

private let zero: Int = 0
