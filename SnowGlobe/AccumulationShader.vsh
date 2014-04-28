// VERTEX SHADER

static const char* AccumulationShaderV = STRINGIFY
(
 
 // OBJ Data
 attribute vec4 aVertex;
 attribute vec3 aNormal;
 attribute vec2 aTexture;
 
 // View Matrices
 uniform mat4 uProjectionMatrix;
 uniform mat4 uModelViewMatrix;
 uniform mat3 uNormalMatrix;
 uniform float uTime;
 // Output to Fragment Shader
 varying vec3 vNormal;
 varying vec2 vTexture;
 
 void main(void)
{
    vNormal     = uNormalMatrix * aNormal;
    
    if (vNormal.y > 0.0)
    {
        aVertex.y
    }
    
    vTexture    = aTexture;
    
    gl_Position = uProjectionMatrix * uModelViewMatrix * aVertex;
}
 
 );