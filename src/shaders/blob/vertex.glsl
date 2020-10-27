precision highp float;

#pragma glslify: snoise4 = require(glsl-noise/simplex/4d)
#pragma glslify: map = require(glsl-map)

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform float uScale;
uniform float uScaleNoiseTime;
uniform float uScaleNoiseScale;
uniform float uScaleNoiseAmount;

uniform float uTranslateNoiseTime;
uniform float uTranslateNoiseScale;
uniform float uTranslateNoiseAmount;

uniform float uColorNoiseTime;
uniform float uColorNoiseScale;
uniform float uColorNoiseAmount;

uniform float uAlpha;
uniform float uAlphaNoiseTime;
uniform float uAlphaNoiseScale;
uniform float uAlphaNoiseAmount;
uniform float uAlphaNoisePow;

attribute vec3 position;
attribute vec2 uv;
attribute vec3 translate;

varying vec2 vUv;
varying float vScale;
varying float vColorMix;
varying float vAlpha;

void main() {
    vUv = uv;

    // We apply noise to the translate vec3 instead of the final position
    // because it won't affect the billboard effect
    float noiseX = snoise4(vec4(translate * uTranslateNoiseScale, uTranslateNoiseTime)) * uTranslateNoiseAmount;
    // Add an arbitrary offset to uTime so we can a different noise value
    float noiseY = snoise4(vec4(translate * uTranslateNoiseScale, uTranslateNoiseTime + 100.)) * uTranslateNoiseAmount;
    // Add an another arbitrary offset to uTime to get yet another noise value
    float noiseZ = snoise4(vec4(translate * uTranslateNoiseScale, uTranslateNoiseTime + 500.)) * uTranslateNoiseAmount;
    vec3 newTranslate = translate + vec3(noiseX, noiseY, noiseZ);

    // Modulate (or not) the scale using noise
    float particleScaleNoise = map(snoise4(vec4(translate * uScaleNoiseScale, uScaleNoiseTime)), -1., 1., 0., 1.);
    float scale = mix(uScale, uScale * particleScaleNoise, uScaleNoiseAmount);

    // Modulate (or not) the color using noise
    // We won't use this value here but send it to the fragment shader using a varying 
    float particleColorNoise = map(snoise4(vec4(translate * uColorNoiseScale, uColorNoiseTime)), -1., 1., 0., 1.);
    vColorMix = particleColorNoise * uColorNoiseAmount;

    // Modulate (or not) the a  alpha using noise
    // We won't use it within the vertex shader here but send it to the fragment shader using a varying 
    float particleAlphaNoise = map(snoise4(vec4(translate * uAlphaNoiseScale, uAlphaNoiseTime)), -1., 1., 0., 1.);
    vAlpha = mix(uAlpha, pow(particleAlphaNoise, uAlphaNoisePow) * uAlpha, uAlphaNoiseAmount);


    // -> https://threejs.org/examples/webgl_buffergeometry_instancing_billboards.html
    vec4 mvPosition = modelViewMatrix * vec4(newTranslate, 1.0);
    mvPosition.xyz += position * scale;

    gl_Position = projectionMatrix * mvPosition;
}