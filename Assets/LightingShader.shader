Shader "Unlit/LightingShader"
{
    Properties
    {
        _Gloss("Gloss", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            float _Gloss;

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
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                //diffuse Lighting

                float3 N = normalize(i.normal);
                float3 L = _WorldSpaceLightPos0.xyz;

                float3 diffuseLight = max(0, dot(N,L)) * _LightColor0.xyz;


                //Specular Lighting
                float3 V = normalize(_WorldSpaceCameraPos.xyz - i.wPos);
                float3 R = reflect(-L,N);
                float specularLight = max(0, dot(V,R));

                specularLight = pow(specularLight, _Gloss);

                return float4(specularLight.xxx,1);

                return float4(diffuseLight,1);
            }
            ENDCG
        }
    }
}
