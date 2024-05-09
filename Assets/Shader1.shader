Shader "Unlit/Shader1"
{
    Properties
    {
        // Input Data
        //_MainTex ("Texture", 2D) = "white" {}
        _ColorA("Color A", Color) = (1, 1, 1, 1)
        _ColorB("Color B", Color) = (1, 1, 1, 1)
        _Start("Start Position", Range(0,1)) = 1
        _End("End Position", Range(0,1)) = 0
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

            float4 _ColorA;
            float4 _ColorB;
            float _Start;
			float _End;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float2 uv0 : TEXCOORD0;
                //float2 uv1 : TEXCOORD1;
                //float2 uv2 : TEXCOORD2;
                //float4 color : COLOR0;
                //float4 tangent : TANGENT;
            };

            struct v2f
            {
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                //float4 joke : TEXCOORD4;
                float4 vertex : SV_POSITION;
            };

           // sampler2D _MainTex;
           // float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0; //(v.uv0 + _Offest) * _Scale;
                return o;
            }

            float InverseLerp(float a, float b, float v){
				return (v - a) / (b - a);
           }

            float4 frag (v2f i) : SV_Target
            {
                //float2 x = cos(i.uv.xy * 2 * 3.14) * 0.5 + 0.5;
                //return float4(x,0,1);
                
                float offset = cos(i.uv.y * 8 * 2 * 3.14) * 0.01;

                float x = cos((i.uv.x * _Time * 4 + offset) * 8 * 3.14) * 0.5 + 0.5;
                return x;
            }
            ENDCG
        }
    }
}
