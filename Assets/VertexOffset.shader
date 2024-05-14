Shader "Unlit/VertexOffset"
{
    Properties
    {
        // Input Data
        //_MainTex ("Texture", 2D) = "white" {}
        _ColorA("Color A", Color) = (1, 1, 1, 1)
        _ColorB("Color B", Color) = (1, 1, 1, 1)
        _Start("Start Position", Range(-1,1)) = 1
        _End("End Position", Range(-1,1)) = 0
        _WaveAmp("Wave Amplitude", Range(0,2)) = 0.1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "Queue"="Geometry"
            }

        Pass
        {

            Cull Off

            ZWrite On
            ZTest LEqual
            //Blend One One
            //Blend DstColor Zero

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            float _Start;
			float _End;
            float _WaveAmp;

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

                //float t = cos(v.uv0.x * 2.0 * 3.1415926 + _Time * 50);
                //v.vertex.y = t *_WaveAmp;

                float2 uv_Centered = v.uv0 * 2 - 1;
                float radialDistance = length(uv_Centered);
                float tt = cos(radialDistance * 4.0 * 3.1415926 - _Time * 50);
                v.vertex.y = tt * _WaveAmp;

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
                float2 uv_Centered = i.uv * 2 - 1;
                float radialDistance = length(uv_Centered);
                float tt = cos(radialDistance * 2.0 * 3.1415926 - _Time * 50) * 0.5 + 0.5;
                return float4(tt.xxx,1);

                float t = cos(i.uv.x * 2.0 * 3.1415926 + _Time * 50) * 0.5 + 0.5;
                //return float4(t.r,t.r,t.r,1);
            }
            ENDCG
        }
    }
}
