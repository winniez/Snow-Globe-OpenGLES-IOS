// Fragment Shader

static const char* SnowShaderF = STRINGIFY
(
 // Varying
 varying highp vec3      v_pColorOffset;
 varying highp float    v_pTime;
 
 // Uniforms
 uniform highp vec3      u_eColor;
 uniform sampler2D       u_Texture;
 
 void main(void)
{
    // texture
    highp vec4 texture = texture2D(u_Texture, gl_PointCoord);
    // Color
    highp vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
    if (v_pTime >= 0.0)
    {
        color.rgb = u_eColor;
        color.rgb += v_pColorOffset;
        //color.rgb = clamp(color.rgb, vec3(0.0), vec3(1.0));
    }
    // Required OpenGL ES 2.0 outputs
    gl_FragColor = texture * color;
}
);