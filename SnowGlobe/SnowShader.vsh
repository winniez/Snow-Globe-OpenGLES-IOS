 // Vertex Shader
static const char* SnowShaderV = STRINGIFY
(

  // Attributes
  attribute vec3         a_pStartPosition;
  attribute float        a_pStartTime;
  attribute float        a_pDecayOffset;
  attribute float        a_pVelocityOffset;
  attribute float        a_pSizeOffset;
  attribute vec3         a_pColorOffset;
  
  // Uniforms
  uniform mat4          u_ProjectionMatrix;
  uniform mat4          u_ModelViewMatrix;
  uniform vec3          u_Gravity;
  uniform float         u_Time;
  uniform float         u_StopTime;
  uniform float         u_eDecay;
  uniform float         u_eSize;
  uniform float         u_eStopPlaneY;
 
  // Varying
  varying vec3          v_pColorOffset;
  varying float         v_pTime;
  void main(void)
{
    
    // Size
    float s = 1.0;
    vec3 position;
    float decay = u_eDecay + a_pDecayOffset;
    float time = (u_Time - a_pStartTime)/decay;
    
    if (u_Time > u_StopTime)
    {
        position = vec3(0.0, -0.5, 0.0);
    }
    else
    {
        
        if (time > 0.0)
        {
            position = a_pStartPosition;
            position.x += (u_Gravity.x * time);
            position.y += (u_Gravity.y * time);
            position.z += (u_Gravity.z * time);
        }
        else
        {
            position = vec3(0.0, -0.5, 0.0);
        }
    }
    
    /*
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

        if (y1 < u_eStopPlaneY)
        {
            y1 = u_eStopPlaneY;
            x1 = 0.0;
            z1 = 0.0;
        }
        position = vec3(x1,y1,z1);
    }
    */
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(position, 1.0);
    gl_PointSize = max(0.0, (u_eSize + a_pSizeOffset));
    
    // Fragment Shader outputs
    v_pColorOffset = a_pColorOffset;
    v_pTime = time;
}
);