using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RemoveCracks : MonoBehaviour
{


    void Start()
    {
        Mesh mesh = new Mesh();
        GetComponent<MeshFilter>().mesh = mesh;
        Vector3[] vertices = mesh.vertices;
        Vector3[] normals = mesh.normals;
        Vector2[] uv = mesh.uv;
       
	for (int i = 0; i < vertices.Length; i++) {
	    vertices[i] = new Vector3(i, 1 - i, 1 + i);
	}
	
	mesh.vertices = vertices;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
