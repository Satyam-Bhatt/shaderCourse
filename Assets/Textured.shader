Shader "Unlit/Textured"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
				o.worldPosition = mul(UNITY_MATRIX_M, v.vertex.xyz);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture
                return float4(i.worldPosition,1);
                float4 col = tex2D(_MainTex, i.uv);
                //return col;
            }
            ENDCG
        }
    }
}
