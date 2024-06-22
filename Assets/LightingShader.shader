Shader "Unlit/LightingShader"
{
    Properties
    {
        _Gloss("Gloss", Range(0,1)) = 1
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        //Base Pass
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "CGinclude.cginc"
            
            ENDCG
        }

        //Add Pass
        Pass
        {
            Tags {"LightMode" = "ForwardAdd"}
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd

            #include "CGInclude.cginc"
            
            ENDCG
        }

    }
}
