Shader "Unlit/HealthBar"
{
    Properties
    {
        _Health ("Health", Range(0, 1)) = 1
        _StartColor ("Start Color", Color) = (1, 1, 1, 1)
        _EndColor ("End Color", Color) = (1, 1, 1, 1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Radius ("Radius", Range(0, 2)) = 0
    }
    SubShader
    {
        Tags {
            "RenderType"="Opaque"
            //"RenderType"="Transparent"
            //"Queue"="Transparent"
            }

        Pass
        {
            //ZWrite Off
            //ZTest LEqual
            //Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Health;
            float4 _StartColor;
			float4 _EndColor;
            float _Radius;
            sampler2D _MainTex;

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
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float InverseLerp(float a, float b, float v){
				return (v - a) / (b - a);
            }

            float4 storeFunction(v2f i)
            {
                                //float4 healthColor_Value = lerp(_StartColor, _EndColor, _Health);
                float t_Valuse = InverseLerp(0.2, 0.8, _Health);
                float4 healthColor = lerp(_StartColor, _EndColor, t_Valuse);
                float4 health_Tex = tex2D(_MainTex, float2(_Health, i.uv.y));

                if(i.uv.x > _Health)
                {
                    discard;
                    //healthColor_Value = float4(0,0,0,0.5);
                }
                else if(_Health == 1)
                {
                    health_Tex = tex2D(_MainTex, float2(_Health - 0.1, i.uv.y));
                }

                if(_Health <= 0.2)
                {
                    health_Tex = health_Tex * saturate(cos(_Time.y * 10) * 0.5 + 0.8);
                }

                float4 col = float4(i.uv,0,1);
                return health_Tex;
                //return healthColor;
            }

            float4 frag (v2f i) : SV_Target
            {
                i.uv = i.uv * 2 - 1;
                float dis = length(i.uv);

                if(_Radius-dis < 0){
                    discard;
                    }

				return float4(dis,0,0,1);
            }
            ENDCG
        }
    }
}
