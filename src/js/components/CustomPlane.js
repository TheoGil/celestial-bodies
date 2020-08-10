import { PlaneGeometry, ShaderMaterial, Mesh } from "three";
import vertexShader from "../../shaders/customplane/vertex.vert";
import fragmentShader from "../../shaders/customplane/fragment.frag";

class CustomPlane {
  constructor() {
    this.initGeometry();
    this.initMaterial();
    this.initMesh();
  }

  initGeometry() {
    this.geometry = new PlaneGeometry(100, 100, 50, 50);
  }

  initMaterial() {
    this.material = new ShaderMaterial({
      vertexShader,
      fragmentShader,
      uniforms: {
        u_time: {
          value: 0.0,
        },
        u_time_scale: {
          value: 0.01,
        },
      },
      wireframe: true,
    });
  }

  initMesh() {
    this.mesh = new Mesh(this.geometry, this.material);
  }
}

export default CustomPlane;
