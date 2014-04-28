 // Vertex Shader
static const char* SnowShaderV = STRINGIFY
(

  // Attributes
  attribute vec3         a_pStartPosition;
  attribute float        a_PStartTime;
  attribute float        a_pDecayOffset;
  attribute float        a_pVelocityOffset;
  attribute float        a_pSizeOffset;
  attribute vec3         a_pColorOffset;
  
  // Uniforms
  uniform mat4        u_ProjectionMatrix;
  uniform vec3        u_Gravity;
  uniform float       u_Time;
  uniform float       u_eVelocity;
  uniform float       u_eDecay;
  uniform float       u_eSize;
  
  // Varying
  varying vec3       v_pColorOffset;
  varying float      v_pTime;
  
  void main(void)
{
    
    // Size
    float s = 1.0;
    vec3 position;
    float decay = u_eDecay + a_pDecayOffset;
    float time = (mod(u_Time, 15.0) - a_PStartTime)/decay;
    
    if (time < 0.0)
    {
        position = a_pStartPosition;
    }
    else
    {
        float x1 = a_pStartPosition.x + (u_Gravity.x * time);
        float y1 = a_pStartPosition.y + (u_Gravity.y * time);
        float z1 = a_pStartPosition.z + (u_Gravity.z * time);
        //s = mix(u_eSizeStart, u_eSizeEnd, time);
        if (y1 < - 1.0)
        {
            y1 = - 1.0;
            x1 = a_pStartPosition.x + (u_Gravity.x * (-1.0 - a_pStartPosition.y)/u_Gravity.y);
            z1 = a_pStartPosition.z + (u_Gravity.z * (-1.0 - a_pStartPosition.y)/u_Gravity.y);
        }
        position = vec3(x1,y1,z1);
    }
    
    gl_Position = u_ProjectionMatrix * vec4(position, 1.0);
    gl_PointSize = max(0.0, (u_eSize + a_pSizeOffset));
    
    // Fragment Shader outputs
    v_pColorOffset = a_pColorOffset;
    v_pTime = time;
}
);