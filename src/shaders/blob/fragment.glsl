precision highp float;

uniform sampler2D uTexture;
uniform vec3 uColor1;
uniform vec3 uColor2;

varying vec2 vUv;
varying float vColorMix;
varying float vAlpha;

void main() {
    vec4 texture = texture2D(uTexture, vUv);
    if ( texture.a < 0.5 ) discard;
    vec3 color = mix(uColor1, uColor2, vColorMix);
    gl_FragColor = vec4(texture.rgb * color, texture.a * vAlpha);
}