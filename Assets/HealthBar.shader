Shader "Unlit/HealthBar"
{
    Properties
    {
        _Health ("Health", Range(0, 1)) = 1
        _StartColor ("Start Color", Color) = (1, 1, 1, 1)
        _EndColor ("End Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset] _MainTex ("MainTex", 2D) = "white" {}
        _Radius ("Radius", Range(0, 4)) = 0
    }
    SubShader
    {
        Tags {
            //"RenderType"="Opaque"
            "RenderType"="Transparent"
            "Queue"="Transparent"
            }

        Pass
        {
            ZWrite Off
            ZTest LEqual
            Blend SrcAlpha OneMinusSrcAlpha

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

            float4 frag (v2f i) : SV_Target
            {
                float3 helthcolor = lerp(float3(1,0,0), float3(0,1,0), _Health);

                float mask = _Health < i.uv.x;

                float3 colorthing = lerp(helthcolor, float3(0,0,0), mask);

                return float4(colorthing,1);



                float disx = distance (i.uv.x, 0.5);
                float disy = distance(i.uv.y, 0.5);
                float4 col2 = float4(0,0,0,0);

                if(i.uv.x < 0.02 || i.uv.x > 0.98 || i.uv.y < 0.15 || i.uv.y > 0.85)
				{
					disx = 1 + disx;
                    disy = 1 + disy;
				}
                else
                {
                    disx = disy = 0;
                }

                float t_Valuse = InverseLerp(0.2, 0.8, _Health);
                float4 healthColor = lerp(_StartColor, _EndColor, t_Valuse);
                float4 health_Tex = tex2D(_MainTex, float2(_Health, i.uv.y));

                if(_Health <= 0.2)
                {
                    health_Tex = health_Tex * saturate(cos(_Time.y * 10) * 0.5 + 0.8);
                    health_Tex = float4(health_Tex.rgb,1);
                }

                if(i.uv.x > _Health)
                {
                    //discard;
                    health_Tex = float4(0,0,0,0);
                }
                else if(_Health == 1)
                {
                    health_Tex = tex2D(_MainTex, float2(_Health - 0.1, i.uv.y));
                }



                float4 col = float4(i.uv,0,1);
                //return health_Tex;

                if(disx + disy <= 0)
                {
                    col2 = health_Tex;
                }
                else
                {
                    col2 = float4(disy.xxx + disx.xxx,1);
                }

                //return col2;

                float2 coord = i.uv;
                coord.x *= 8;

                float2 points = float2(clamp(coord.x, 0.5, 7.5), 0.5);
                float dist = 1 - distance(points, coord) * _Radius;

                if(dist < 0) discard;

                return health_Tex;
            }
            ENDCG
        }
    }
}
