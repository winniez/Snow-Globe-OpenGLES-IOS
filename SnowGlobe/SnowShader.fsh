// Fragment Shader

static const char* SnowShaderF = STRINGIFY
(
 // Varying
 varying highp vec3     v_pColorOffset;
 varying highp float    v_pTime;
 
 // Uniforms
 uniform highp vec3     u_eColor;
 uniform sampler2D      u_Texture;
 uniform highp float    u_Time;
 uniform highp float    u_StopTime;
 
 void main(void)
{
    // texture
    highp vec4 texture = texture2D(u_Texture, gl_PointCoord);
    // Color
    highp vec4 color = vec4(0.0, 0.0, 0.0, 0.7);
    if ((u_Time > u_StopTime) || (v_pTime < 0.0))
    {
        color.a = 0.0;
    }
    else
    {
        color.rgb = u_eColor;
        color.rgb += v_pColorOffset;
        //color.rgb = clamp(color.rgb, vec3(0.0), vec3(1.0));
    }
    // Required OpenGL ES 2.0 outputs
    gl_FragColor = texture * color;
}
);