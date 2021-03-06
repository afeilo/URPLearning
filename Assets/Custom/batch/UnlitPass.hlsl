#ifndef CUSTOM_UNLIT_PASS_INCLUDED
#define CUSTOM_UNLIT_PASS_INCLUDED

#include "../ShaderLibrary/Common.hlsl"

struct Attributes {
	float3 positionOS : POSITION;
	float2 uv : TEXCOORD0;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings {
	float4 positionCS : SV_POSITION;
	float2 uv : TEXCOORD0;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

sampler2D _BaseMap;

//TEXTURE2D(_BaseMap);
//SAMPLER(sampler_BaseMap);

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
UNITY_DEFINE_INSTANCED_PROP(float4, _BaseMap_ST)
UNITY_DEFINE_INSTANCED_PROP(float, _Cutoff)
//UNITY_DEFINE_INSTANCED_PROP(sampler2D, _BaseMap)
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

Varyings UnlitPassVertex(Attributes input) {
	Varyings output;
	UNITY_SETUP_INSTANCE_ID(input);
	UNITY_TRANSFER_INSTANCE_ID(input, output);
	float3 positionWS = TransformObjectToWorld(input.positionOS) ;
	output.positionCS = TransformWorldToHClip(positionWS);
	float4 baseST = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseMap_ST);
	output.uv = input.uv * baseST.xy + baseST.zw;
	return output;
}

float4 UnlitPassFragment(Varyings input):SV_TARGET {
	UNITY_SETUP_INSTANCE_ID(input);
	float4 color = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseColor);
	//float4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv);
	//sampler2D map = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseMap);
	float4 baseMap = tex2D(_BaseMap, input.uv);
	float cutOff = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _Cutoff);
	float4 base = color* baseMap;
#if defined(_CLIPPING)
	clip(base.a - cutOff);
#endif
	return base;
}

#endif