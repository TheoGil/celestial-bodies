#pragma glslify: snoise3 = require(glsl-noise/simplex/3d)
varying vec2 vUv;
uniform float u_time;
uniform float u_time_scale;

void main() {
    vUv = uv;

    vec3 newPosition = position;

    float u_noise_scale = 0.05;
    float u_noise_amount = 10.0;
    
    newPosition.z = position.z + snoise3(
        vec3(
            position.x * u_noise_scale, 
            position.y * u_noise_scale, 
            u_time * u_time_scale
        )
    ) * u_noise_amount;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0); 
}