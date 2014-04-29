// FRAGMENT SHADER

static const char* ShaderF = STRINGIFY
(

 // Input from Vertex Shader
 varying mediump vec3   vNormal;
 varying mediump vec2   vTexture;
 varying mediump vec3   vOriNormal;
 
 // MTL Data
 uniform lowp vec3      uAmbient;
 uniform lowp vec3      uDiffuse;
 uniform lowp vec3      uSpecular;
 uniform highp float    uExponent;
 
 uniform lowp vec3      uColor;
 uniform sampler2D      uTexture;
 
 // Time
 uniform highp float    uTime;
 uniform highp float    uStopTime;
 
 uniform highp float    uMode;
 
 
 lowp vec3 materialDefault(highp float df, highp float sf)
{
    lowp vec3 ambient = vec3(0.5);
    lowp vec3 diffuse = vec3(0.5);
    lowp vec3 specular = vec3(0.0);
    highp float exponent = 1.0;
    
    sf = pow(sf, exponent);
    
    return (ambient + (df * diffuse) + (sf * specular));
}
 
 lowp vec3 material(highp float df, highp float sf)
{
    sf = pow(sf, uExponent);

    return (uAmbient + (df * uDiffuse) + (sf * uSpecular));
}
 
 lowp vec3 modelColor(void)
{
    highp vec3 N = normalize(vNormal);
    highp vec3 L = vec3(1.0, 1.0, 0.5);
    highp vec3 E = vec3(0.0, 0.0, 1.0);
    highp vec3 H = normalize(L + E);
    
    highp float df = max(0.0, dot(N, L));
    highp float sf = max(0.0, dot(N, H));
    
    return (material(df, sf) * vec3(texture2D(uTexture, vTexture)));
}
 
void main(void)
{
    // lighting calculation
    highp vec3 N = normalize(vNormal);
    highp vec3 L = vec3(1.0, 1.0, 0.5);
    highp vec3 E = vec3(0.0, 0.0, 1.0);
    highp vec3 H = normalize(L + E);
    highp float df = max(0.0, dot(N, L));
    highp float sf = max(0.0, dot(N, H));
    lowp vec3 lighting = material(df, sf);
    
    lowp vec4 color = vec4(1.0, 1.0, 1.0, 0.0);
    if (uMode < 1.0)
    {
        color.rgb = lighting * vec3(texture2D(uTexture, vTexture));
        color.a = 1.0;
    }
    else
    {// snow accumulation
        highp float a = uTime / uStopTime;
        highp float alpha = 1.0;
        if (a < 1.0)
        {
            alpha = min((a+0.15)*1.2, 1.0);
        }
        if (vOriNormal.y > 0.1)
        {
            color.a = alpha;
        }
        color.rgb = lighting;
    }
    gl_FragColor = color;
}

);