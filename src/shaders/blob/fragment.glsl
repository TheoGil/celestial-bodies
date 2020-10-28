precision mediump float;

uniform vec3 uColor1;
uniform vec3 uColor2;

varying vec2 vUv;
varying float vColorMix;
varying float vAlpha;

float circle(vec2 pos, float maskRadius, float smoothness) {
    return 1. - smoothstep(
        maskRadius - (maskRadius * smoothness),
        maskRadius + (maskRadius * smoothness),
        length(pos)
    );
}

void main() {
    float radius = .3;
    float smoothness = 0.2;
    float alphaMask = circle(vUv - vec2(.5), radius, smoothness);
    if ( alphaMask < 0.1 ) discard;
    vec3 color = mix(uColor1, uColor2, vColorMix);
    gl_FragColor = vec4(color, alphaMask * vAlpha);
}