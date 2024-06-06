Shader "Unlit/SDFExample"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.y = v.uv.y;
                o.uv.x = v.uv.x * 8;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                //i.uv.x = i.uv.x * 8;
                float dis = frac(i.uv.x);
                float val = clamp(i.uv.x,0.5, 7.5);
                float dis2 = distance(float2(val, 0.5), float2(i.uv.x, i.uv.y));
                float dis3 = step(0.5, dis2);
                return float4(1 - dis3.xxx,1);
            }
            ENDCG
        }
    }
}
