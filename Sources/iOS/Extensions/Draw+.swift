/*
 * Draw+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

/**
Return an image from rendering block.

```
// render an image from UILabel

let label = UILabel()
label.text = "+"
label.textAlignmnet = .Center

renderInContext(label.bounds.size, opaque: true, render: label.layer.renderInContext)

```

- parameter size: The size of output image.
- parameter opaque: The bit-map opaque flag.
- parameter render: Custom rendering block within a graphic context.

- returns: An image object from rendering block
*/
public func render(size: CGSize, opaque: Bool, handle: (CGContext) -> Void) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)

    if let context = UIGraphicsGetCurrentContext() { handle(context) }
    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()
    
    return image
}
