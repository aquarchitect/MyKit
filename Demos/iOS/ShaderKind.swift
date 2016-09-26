/*
 * ShaderKind.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

enum ShaderKind: String {

    case Basic = "Basic Shader"
}

extension ShaderKind {

    var fileName: String {
        switch self {
        case .Basic: return "BasicShader.fsh"
        }
    }
}
