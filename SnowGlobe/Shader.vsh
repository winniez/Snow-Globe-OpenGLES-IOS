// VERTEX SHADER

static const char* ShaderV = STRINGIFY
(

 // OBJ Data
 attribute vec4     aVertex;
 attribute vec3     aNormal;
 attribute vec2     aTexture;
 
 // View Matrices
 uniform mat4       uProjectionMatrix;
 uniform mat4       uModelViewMatrix;
 uniform mat3       uNormalMatrix;
 
 // Time
 uniform float      uTime;
 uniform float      uStopTime;
 
 // Mode
 uniform float      uMode;
 uniform float      uDeltaY;
 
 // Output to Fragment Shader
 varying vec3       vNormal;
 varying vec2       vTexture;
 varying vec3       vOriNormal;
 
 void main(void)
{
    vec4 finalPos;
    // Output to Fragment Shader
    vOriNormal  = aNormal;
    vNormal     = uNormalMatrix * aNormal;
    vTexture    = aTexture;
    if (uMode < 1.0)
    {
        finalPos = uProjectionMatrix * uModelViewMatrix * aVertex;
    }
    else
    {// snow accumulation
        vec4 curpos = aVertex;
        float a = uTime / uStopTime;
        float deltaY = uDeltaY;
        if (a < 1.0)
        {
            deltaY = a * uDeltaY;
        }
        if (aNormal.y > 0.1) curpos.y += deltaY;
        finalPos = uProjectionMatrix * uModelViewMatrix * curpos;
    }
    gl_Position = finalPos;
}
 
);