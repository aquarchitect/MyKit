<!--Generic Interface-->

## Generic Interface

> Generic classes API has a lot of common shared codes, which are designed intentionally for the sake of subclassing and also reinforcing declarative view programming.

#### Rejected Protocol Implementation Reasons

Protocol for rendering implementation had been carefully considered as followed:

```swift
public protocol GenericInterfaceProtocol: class {

    associatedtype Item
    var items: [Item] { get }
    func reloadData()
}

extension GenericInterfaceProtocol {

    /*
     * Xcode will prompt `mutating` error for `items`.
     */
    func renderStatically(items: [Item]) {
        self.items = items
        self.reloadData()
    }
}
```

Unfortunately, with Swift current version protocol requirements with specific scope cannot be specified.
