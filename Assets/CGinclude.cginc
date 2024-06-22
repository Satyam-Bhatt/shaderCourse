#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"


float _Gloss;
float4 _Color;

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float3 normal : TEXCOORD1;
    float3 wPos : TEXCOORD2;
    LIGHTING_COORDS(3,4)
};

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
    TRANSFER_VERTEX_TO_FRAGMENT(o);
    return o;
}

float4 frag(v2f i) : SV_Target
{
    //diffuse Lighting

    float3 N = normalize(i.normal);
    float3 L = normalize(UnityWorldSpaceLightDir(i.wPos));

    float3 lambert = saturate(dot(N, L));

    float3 diffuseLight = lambert * _LightColor0.xyz;


    //Specular Lighting
    float3 V = normalize(_WorldSpaceCameraPos.xyz - i.wPos);
    //float3 R = reflect(-L,N);
    float3 H = normalize(V + L);
    float blinnPhong = max(0, dot(N, H));
    //float specularLight = max(0, dot(V,R));

    float3 specularExpoenent = exp2(_Gloss * 11) + 1;

    float3 specularLight = pow(blinnPhong, specularExpoenent) * (lambert > 0) * _Gloss;
    specularLight *= _LightColor0.xyz;
                 
    return float4(specularLight + diffuseLight * _Color, 1);

    //return float4(diffuseLight,1);
}
