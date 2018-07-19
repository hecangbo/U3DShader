using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class PlaneShadowCaster : MonoBehaviour {
    public Transform reciever;
	void Update () {
        //renderer.sharedMaterial.SetMatrix("_World2Ground",reciever.renderer.worldToLocalMatrix);
        //renderer.sharedMaterial.SetMatrix("_Ground2World", reciever.renderer.localToWorldMatrix);
        GetComponent<Renderer>().sharedMaterial.SetMatrix("_World2Ground", reciever.GetComponent<Renderer>().worldToLocalMatrix);
        GetComponent<Renderer>().sharedMaterial.SetMatrix("_Ground2World", reciever.GetComponent<Renderer>().localToWorldMatrix);
    }
}
