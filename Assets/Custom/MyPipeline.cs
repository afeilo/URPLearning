using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class MyPipeline : RenderPipeline
{
    CameraRender cameraRender;
    bool useDynamicBatching, useGPUInstancing;
    public MyPipeline(bool useDynamicBatching, bool useGPUInstancing, bool useSRPBatcher) : base()
    {
        this.useDynamicBatching = useDynamicBatching;
        this.useGPUInstancing = useGPUInstancing;
        cameraRender = new CameraRender();
        GraphicsSettings.useScriptableRenderPipelineBatching = useSRPBatcher;
    }
   
    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        foreach (var camera in cameras)
        {
            cameraRender.Render(context, camera, useDynamicBatching, useGPUInstancing);
        }
    }
    public void Dispose()
    {

    }

}
