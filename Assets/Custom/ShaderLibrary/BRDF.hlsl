#ifndef CUSTOM_BRDF_INCLUDED
#define CUSTOM_BRDF_INCLUDED
struct BRDF {
	float3 diffuse;
	float3 specular;
	float roughness;
};

#define MIN_REFLECTIVITY 0.04 //绝缘体最小反射率

//根据金属性 来确定反射率 1 - 反射率
float OneMinusReflectivity(float metallic) {
	float range = 1.0 - MIN_REFLECTIVITY;
	return range - metallic * range;
}

BRDF GetBRDF(Surface surface, bool applyAlphaToDiffuse = false) {
	BRDF brdf;
	float oneMinusReflectivity = OneMinusReflectivity(surface.metallic);
	brdf.diffuse = oneMinusReflectivity * surface.color;
	brdf.specular = lerp(MIN_REFLECTIVITY, surface.color, surface.metallic);

	float perceptualRoughness =
		PerceptualSmoothnessToPerceptualRoughness(surface.smoothness);
	brdf.roughness = PerceptualRoughnessToRoughness(perceptualRoughness); //粗糙度 神秘算法

	return brdf;
}
//根据brdf计算反射 公式见https://catlikecoding.com/unity/tutorials/custom-srp/directional-lights/
float SpecularStrength(Surface surface, BRDF brdf, Light light) {
	float3 h = SafeNormalize(light.direction + surface.viewDirection);
	float lh2 = Square(saturate(dot(light.direction, h)));
	float nh2 = Square(saturate(dot(surface.normal, h)));
	float r2 = Square(brdf.roughness);
	float d2 = Square(nh2 * (r2 - 1) + 1.0001); // d = nh2 * (r2 - 1) + 1.0001
	float n = 4 * brdf.roughness + 2; //n = 4r + 2

	return r2 /(d2 * max(0.1,lh2) * n);
}

float3 DirectBRDF(Surface surface, BRDF brdf, Light light) {
	return SpecularStrength(surface, brdf, light) * brdf.specular + brdf.diffuse;
}


#endif