using UnityEngine;
public class _ColorMask_2 : MonoBehaviour {
	void Start () {
        // camera.depthTextureMode = DepthTextureMode.Depth;
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;

    }
}
