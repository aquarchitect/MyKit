/*
 * Range+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

#if swift(>=3.0)
#else
public extension Range where Element: Comparable {

    func clampedTo(range: Range<Element>) -> Range<Element> {
        let startIndex = max(self.startIndex, range.endIndex)
        let endIndex = min(self.endIndex, range.endIndex)

        return startIndex..<endIndex
    }
}
#endif

