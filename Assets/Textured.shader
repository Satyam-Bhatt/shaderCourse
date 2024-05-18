Shader "Unlit/Textured"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Pattern ("Pattern", 2D) = "white" {}
        _Raw ("Raw", 2D) = "white" {}
        _Offset ("Offset", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _Pattern;
            sampler2D _Raw;
            float4 _MainTex_ST;
            float _Offset;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPosition : TEXCOORD1;
            };


            v2f vert (MeshData v)
            {
                v2f o;
				o.worldPosition = mul(UNITY_MATRIX_M, float4(v.vertex.xyz,1));
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float GetWave(float coord){
                float wave = cos((coord - _Time.y *0.1) * 3.1415 * 5) * 0.5 + 0.5;
                //wave *= 1 - coord;
                return wave;
            }

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float2 topDownWorldPos = i.worldPosition.xz;
                //return float4(topDownWorldPos,0,1);
                float4 col = tex2D(_MainTex, topDownWorldPos);
                float4 raw = tex2D(_Raw, topDownWorldPos);
                float pattern = tex2D(_Pattern, i.uv).r;

                float4 show = lerp(raw,col,pattern);

                //return GetWave(pattern);
                //return GetWave(i.uv);
                return show;
            }
            ENDCG
        }
    }
}
