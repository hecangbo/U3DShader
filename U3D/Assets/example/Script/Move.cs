using System.Collections;
using UnityEngine;

public class Move : MonoBehaviour
{
    public int speed = 10;

    public Transform obj;
    // public float speed = 2;
    private bool _mouseDown = false;
    GameObject go;
    Transform tr;
    public Camera ca;
    // Use this for initialization
    void Start()
    {
        // go = GameObject.Find("Capsule_DiffuseVertexLevel");
        ca = GetComponent<Camera>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButton(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            Transform trans1;
            if (Physics.Raycast(ray, out hit))
            {
                Debug.Log("选中对象的名字:" + hit.collider.name);
                float posZ = GameObject.Find(hit.collider.name).transform.position.z;
                // Debug.Log("==============================:" + posZ);
                trans1 = hit.collider.gameObject.transform;
                trans1.position = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, trans1.position.z)); //hit.collider.gameObject.transform.position.z

                // Debug.Log("==============================:" + hit.collider.gameObject.transform.position.x + ";y=" + hit.collider.gameObject.transform.position.y + ";z=" + hit.collider.gameObject.transform.position.z);
                trans1.position = new Vector3(trans1.position.x, trans1.position.y, posZ);

                //旋转
                if (Input.GetMouseButtonDown(0))
                    _mouseDown = true;
                else if (Input.GetMouseButtonUp(0))
                    _mouseDown = false;

                if (_mouseDown)
                {
                    float fMouseX = Input.GetAxis("Mouse X");
                    float fMouseY = Input.GetAxis("Mouse Y");
                    //Debug.Log("fMouseX=" + fMouseX + "   fMouseY=" + fMouseY);
                    //transform.Rotate(Vector3.up, -fMouseX * speed, Space.World);
                    // transform.Rotate(Vector3.right, fMouseY * speed, Space.World);
                    trans1.Rotate(Vector3.up, -fMouseX * speed, Space.World);
                    trans1.Rotate(Vector3.right, fMouseY * speed, Space.World);
                }
            }
            else
            {
                Debug.Log("没选中物体:error");
            }
        }
        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow)) //上移 
        {
            //transform.Translate(Vector3.up * speed * Time.deltaTime);
            transform.Translate(Vector3.up * speed * Time.deltaTime);
            //transform.Translate(new Vector3(0, 0, speed * Time.deltaTime));
        }
        if (Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.DownArrow)) //下移 
        {
            transform.Translate(Vector3.down * speed * Time.deltaTime);
        }
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow)) //左移 
        {
            transform.Translate(Vector3.left * speed * Time.deltaTime);
        }
        if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow)) //右移 
        {
            transform.Translate(Vector3.right * speed * Time.deltaTime);
        }
        if (Input.GetKey(KeyCode.E)) //前移 
        {
            transform.Translate(Vector3.forward * speed * Time.deltaTime);
        }
        if (Input.GetKey(KeyCode.R)) //后移 
        {
            transform.Translate(Vector3.back * speed * Time.deltaTime);
        }

        //移动摄像机
        if(Input.GetKey(KeyCode.Q))
        {
        	transform.Rotate(0, -25*Time.deltaTime,0,Space.Self);
        }
        if(Input.GetKey(KeyCode.E))
        {
        	transform.Rotate(0, 25*Time.deltaTime,0,Space.Self);
        }
        if(Input.GetKey(KeyCode.Z))
        {
        	transform.Rotate(-25*Time.deltaTime,0,0,Space.Self);
        }
        if(Input.GetKey(KeyCode.C))
        {
        	transform.Rotate(25*Time.deltaTime,0,0,Space.Self);
        }
        if(Input.GetKey(KeyCode.H))
        {
        	transform.Rotate(0, 0, 25*Time.deltaTime,Space.Self);
        }
        if(Input.GetKey(KeyCode.N))
        {
        	transform.Rotate(0, 0, -25*Time.deltaTime,Space.Self);
        }

        //旋转
        //if (Input.GetMouseButtonDown(0))
        //    _mouseDown = true;
        //else if (Input.GetMouseButtonUp(0))
        //    _mouseDown = false;

        //if (_mouseDown)
        //{
        //    float fMouseX = Input.GetAxis("Mouse X");
        //    float fMouseY = Input.GetAxis("Mouse Y");
        //    Debug.Log("fMouseX=" + fMouseX + "   fMouseY=" + fMouseY);
        //    //transform.Rotate(Vector3.up, -fMouseX * speed, Space.World);
        //   // transform.Rotate(Vector3.right, fMouseY * speed, Space.World);
        //    hit.collider.gameObject.transform.Rotate(Vector3.up, -fMouseX * speed, Space.World);
        //    hit.collider.gameObject.transform.Rotate(Vector3.right, fMouseY * speed, Space.World);
        //}

        float mouseX = Input.GetAxis("Mouse X") * speed / 4;
        float mouseY = Input.GetAxis("Mouse Y") * speed / 4;
        Camera.main.transform.localRotation = Camera.main.transform.localRotation * Quaternion.Euler(-mouseY, 0, 0);
        transform.localRotation = transform.localRotation * Quaternion.Euler(0, mouseX, 0);

    }
}