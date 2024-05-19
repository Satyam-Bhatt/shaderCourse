Shader "Unlit/HealthBar"
{
    Properties
    {
        _Health ("Health", Range(0, 1)) = 1
        _StartColor ("Start Color", Color) = (1, 1, 1, 1)
        _EndColor ("End Color", Color) = (1, 1, 1, 1)
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

            float _Health;
            float4 _StartColor;
			float4 _EndColor;

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;    
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 healthColor = lerp(_StartColor, _EndColor, _Health);

                if(i.uv.x > _Health)
                {
                    healthColor = float4(0,0,0,1);
                }

                float4 col = float4(i.uv,0,1);
                return healthColor;
            }
            ENDCG
        }
    }
}
