//
//  Diff.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/27/16.
//  
//

public struct Diff<T: Equatable> {

    public typealias Step = (Int, T)

    public let deletion: [Step]
    public let insertion: [Step]

    public var isEmpty: Bool {
        return insertion.isEmpty && deletion.isEmpty
    }

    internal init(deletion: [Step] = [], insertion: [Step] = []) {
        self.deletion = deletion
        self.insertion = insertion
    }
}