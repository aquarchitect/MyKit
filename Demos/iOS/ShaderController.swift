/*
 * ShaderController.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
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
