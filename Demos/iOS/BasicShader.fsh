/*
 * BasicShader.fsh
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

void main(void) {
    vec2 uv = gl_FragCoord.xy / size;
    gl_FragColor = vec4(vec3(uv.x * uv.y), 1.);
}
