﻿
using UnityEngine;
using UnityEngine.Rendering;

public class Lighting
{
    static int dirLightColorId = Shader.PropertyToID("_DirectionalLightColor"),
               dirLightDirectionId = Shader.PropertyToID("_DirectionalLightDirection");

    const string bufferName = "Lighting";
    CommandBuffer buffer = new CommandBuffer()
    {
        name = bufferName
    };
    public void Setup(ScriptableRenderContext context)
    {
        buffer.BeginSample(bufferName);
        SetupDiretionalLight();
        buffer.EndSample(bufferName);
        context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }

    void SetupDiretionalLight()
    {
        Light light = RenderSettings.sun;
        buffer.SetGlobalVector(dirLightColorId, light.color.linear * light.intensity);
        buffer.SetGlobalVector(dirLightDirectionId, -light.transform.forward);
    }
}
