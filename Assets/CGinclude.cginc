#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#define USE_LIGHTING

sampler2D _RockAlbedo;
float4 _RockAlbedo_ST;
sampler2D _RockNormals;
float _Gloss;
float4 _Color;

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
    float4 tangent : TANGENT; //xyz = tangent direction, w = tangent sign
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float3 normal : TEXCOORD1;
    float3 wPos : TEXCOORD2;
    float3 tangent : TEXCOORD3;
    float3 bitangent : TEXCOORD4;
    LIGHTING_COORDS(5,6)
};

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _RockAlbedo);
    o.normal = UnityObjectToWorldNormal(v.normal);
    
    o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
    o.bitangent = cross(o.normal, o.tangent);
    o.bitangent *= v.tangent.w * unity_WorldTransformParams.w; // correctly handle flipping/mirroring
    
    o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
   
    
    TRANSFER_VERTEX_TO_FRAGMENT(o);
    return o;
}

float4 frag(v2f i) : SV_Target
{
    float3 rock = tex2D(_RockAlbedo, i.uv).rgb;
    float3 surfaceColor = rock * _Color.rgb;
   
    float3 tangentSpaceNormal = UnpackNormal(tex2D(_RockNormals, i.uv));
    
    float3x3 mtxTangentToWorld =
    {
        i.tangent.x, i.bitangent.x, i.normal.x,
        i.tangent.y, i.bitangent.y, i.normal.y,
        i.tangent.z, i.bitangent.z, i.normal.z
    }; //Tangent space itself with tangent direction, bitangent and normal
    
    float3 N = mul(mtxTangentToWorld, tangentSpaceNormal).xyz; //This is the world space normal

    
    #ifdef USE_LIGHTING
        //float3 N = normalize(i.normal);
        float3 L = normalize(UnityWorldSpaceLightDir(i.wPos));
        float attenuation = LIGHT_ATTENUATION(i);
        float3 lambert = saturate(dot(N, L));

        float3 diffuseLight = (attenuation * lambert) * _LightColor0.xyz;


        //Specular Lighting
        float3 V = normalize(_WorldSpaceCameraPos.xyz - i.wPos);
        //float3 R = reflect(-L,N);
        float3 H = normalize(V + L);
        float blinnPhong = max(0, dot(N, H));
        //float specularLight = max(0, dot(V,R));

        float3 specularExpoenent = exp2(_Gloss * 11) + 1;

        float3 specularLight = pow(blinnPhong, specularExpoenent) * (lambert > 0) * _Gloss * attenuation;
        specularLight *= _LightColor0.xyz;
                 
        return float4(specularLight + diffuseLight * surfaceColor, 1);
    #else
        return surfaceColor;
    #endif
    
    //diffuse Lighting



    //return float4(diffuseLight,1);
}