using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class MyPipeline : RenderPipeline
{
    CameraRender cameraRender;
    public MyPipeline() : base()
    {
        cameraRender = new CameraRender();
    }
   
    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        foreach (var camera in cameras)
        {
            cameraRender.Render(context, camera);
        }
    }
    public void Dispose()
    {

    }

}
