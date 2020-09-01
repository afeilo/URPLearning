Shader "Custom RP/Lit"
{
    Properties
    {
        _BaseMap("Texture",2D) = "white" {}
        _BaseColor("Color",Color) = (1.0,1.0,1.0,1.0)
        _Cutoff("Cutoff",Range(0.0, 1.0)) = 0.2
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend", Float) = 0
        [Enum(Off, 0, On, 1)] _ZWrite("Z Write", Float) = 1
        [Toggle(_CLIPPING)] _Clipping("Alpha Clipping", Float) = 0
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "LightMode" = "CustomLit"
        }
        LOD 100

        Pass
        {
            Blend[_SrcBlend][_DstBlend]
            ZWrite [_ZWrite]
            HLSLPROGRAM
            #pragma multi_compile_instancing
            #pragma shader_feature _CLIPPING
            #pragma vertex LitPassVertex
            #pragma fragment LitPassFragment
            #include "LitPass.hlsl"
            ENDHLSL
        }
    }
}
