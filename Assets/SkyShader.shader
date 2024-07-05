Shader "Unlit/SkyShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            struct appdata
            {
                float4 vertex : POSITION;
                float3 viewDirection : TEXCOORD0;
            };

            #define TAU 6.28318530718

            struct v2f
            {
                float3 viewDirection : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.viewDirection = v.viewDirection;
                return o;
            }

            float2 DirToRectilinear(float3 dir)
            {
                float x = atan2(dir.z, dir.x) / TAU + 0.5 ; //range from 0 to 1
                float y = dir.y * 0.5 + 0.5; //range from 0 to 1
                return float2 (x,y);
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, DirToRectilinear(i.viewDirection));
                return col;
            }
            ENDCG
        }
    }
}
