/*
 * ShaderController.swift
 * MyKit
 *
 * Copyright (c) 2016 Hai Nguyen.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

final class ShaderController: UIViewController {

    private var nodeShader: SKShader?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(shaderNamed string: String) {
        self.nodeShader = SKShader(fileNamed: string)
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = SKView(frame: .zero).then {
            $0.showsFPS = true
            $0.showsDrawCount = true
            $0.ignoresSiblingOrder = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let size = UIScreen.mainScreen().bounds.size
        let vector = GLKVector2Make(Float(size.width * 2), Float(size.height * 2))

        nodeShader?.uniforms = [SKUniform(name: "size", floatVector2: vector)]

        let scene = SKScene().then { $0.scaleMode = .AspectFill }
        (view as? SKView)?.presentScene(scene)

        SKSpriteNode(color: .greenColor(), size: size)
            .then {
                $0.position = CGPointMake(size.width / 2, size.height / 2)
                $0.shader = nodeShader
            }.then(scene.addChild)
    }
}