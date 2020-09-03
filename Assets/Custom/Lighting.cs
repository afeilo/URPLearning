
using Unity.Collections;
using UnityEngine;
using UnityEngine.Rendering;

public class Lighting
{
    static int dirLightColorId = Shader.PropertyToID("_DirectionalLightColors"),
               dirLightCountId = Shader.PropertyToID("_DirectionalLightCount"),
               dirLightDirectionId = Shader.PropertyToID("_DirectionalLightDirections");


    const string bufferName = "Lighting";
    const int maxDirLightCount = 4;

    static Vector4[]
        dirLightColors = new Vector4[maxDirLightCount],
        dirLightDirection= new Vector4[maxDirLightCount];

    CommandBuffer buffer = new CommandBuffer()
    {
        name = bufferName
    };

    CullingResults cullingResults;
    public void Setup(ScriptableRenderContext context,CullingResults cullingResults)
    {
        this.cullingResults = cullingResults;
        buffer.BeginSample(bufferName);

        NativeArray<VisibleLight> visibleLights = cullingResults.visibleLights;
        int lightCount = 0;
        for (int i = 0; i < visibleLights.Length; i++)
        {
            if (visibleLights[i].lightType == LightType.Directional)
            {
                var visibleLight = visibleLights[i];
                SetupDiretionalLight(i, ref visibleLight);
                lightCount++;
                if (lightCount >= maxDirLightCount)
                {
                    break;
                }
            }
        }

        buffer.SetGlobalInt(dirLightCountId, lightCount);
        buffer.SetGlobalVectorArray(dirLightColorId, dirLightColors);
        buffer.SetGlobalVectorArray(dirLightDirectionId, dirLightDirection);

        buffer.EndSample(bufferName);
        context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }

    void SetupDiretionalLight(int index, ref VisibleLight visibleLight)
    {
        dirLightColors[index] = visibleLight.finalColor;
        dirLightDirection[index] = -visibleLight.localToWorldMatrix.GetColumn(2);

        //Light light = RenderSettings.sun;
        //buffer.SetGlobalVector(dirLightColorId, light.color.linear * light.intensity);
        //buffer.SetGlobalVector(dirLightDirectionId, -light.transform.forward);
    }
}
