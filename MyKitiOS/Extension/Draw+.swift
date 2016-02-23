//
//  Draw+.swift
//  Essential
//
//  Created by Hai Nguyen on 7/23/15.
//
//

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
public func renderInContext(size: CGSize, opaque: Bool, render: Render) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)

    if let context = UIGraphicsGetCurrentContext() { render(context) }
    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()
    
    return image
}