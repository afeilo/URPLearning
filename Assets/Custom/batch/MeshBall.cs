using UnityEngine;

public class MeshBall : MonoBehaviour
{
	static int baseColorId = Shader.PropertyToID("_BaseColor");

	[SerializeField]
	Mesh mesh = default;

	[SerializeField]
	Material material = default;

	static MaterialPropertyBlock block;

	Matrix4x4[] matrices = new Matrix4x4[1023];
	Vector4[] colors = new Vector4[1023];
	private void Awake()
	{
		for (int i = 0; i < matrices.Length; i++)
		{
			matrices[i] = Matrix4x4.TRS(Random.insideUnitSphere * 10f, Quaternion.identity, Vector3.one);
			colors[i] = new Vector4(Random.value, Random.value, Random.value, 1);
		}
	}

	void Update()
	{
		if (null == block)
		{
			block = new MaterialPropertyBlock();
			block.SetVectorArray(baseColorId, colors);
		}
		Graphics.DrawMeshInstanced(mesh, 0, material, matrices, 1023, block);
	}
}
