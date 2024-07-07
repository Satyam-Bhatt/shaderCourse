Shader "Unlit/LightingShader"
{
    Properties
    {
        _Gloss("Gloss", Range(0,1)) = 1
        _Color("Color", Color) = (1,1,1,1)
        _AmbientLight("Ambient Light", Color) = (0,0,0,0)
        _RockAlbedo ("RockAlbedo", 2D) = "white" {}
        [NoScaleOffset]_RockNormals ("Rock Normals", 2D) = "bump" {}
        [NoScaleOffset]_RockHeight ("Rock Height", 2D) = "gray" {}
        _NormalIntensity("Normal Intensity", Range(0,1)) = 1
        _HeightIntensity("Height Intensity", Range(0,0.2)) = 0
        [NoScaleOffset]_DiffuseIBL("Diffuse IBL", 2D) = "black" {}
        [NoScaleOffset]_SpecularIBL("Specular IBL", 2D) = "black" {}
        _SpecIBLIntensity("Spec IBL Intensity", Range(0,1)) = 1
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
            #define IS_IN_BASE_PASS
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
