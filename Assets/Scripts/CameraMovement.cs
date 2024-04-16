using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class CameraMovement : MonoBehaviour
{
  Camera mainCamera;
  Vector4 worldV;
  public bool active;

  public const float ACCEL = 5.0f;
  public const float ROTATION_SPEED = 45.0f;
  public const float DAMPING = 0.1f;
  Vector4 initPos;
  // Start is called before the first frame update
  void Start()
    {
      mainCamera = Camera.main;
      active = true;
      initPos = mainCamera.transform.position;
    }

  // Update is called once per frame
  void Update()
  {
   if (active)
    {
      HandleMovement();
      HandleRotation();
      if (Input.GetKeyDown(KeyCode.R))
      {
        mainCamera.transform.position = initPos;
      }
    }

  }

  void HandleMovement()
  {
    float dt = Time.deltaTime;
    if (Input.GetKey(KeyCode.LeftArrow))
    {
      worldV += mainCamera.cameraToWorldMatrix * Vector3.left * ACCEL * dt;
    }
    if (Input.GetKey(KeyCode.RightArrow))
    {
      worldV += mainCamera.cameraToWorldMatrix * Vector3.right * ACCEL * dt;
    }
    if (Input.GetKey(KeyCode.Space))
    {
      worldV += mainCamera.cameraToWorldMatrix * Vector3.up * ACCEL * dt;
    }
    if (Input.GetKey(KeyCode.LeftShift))
    {
      worldV += mainCamera.cameraToWorldMatrix * Vector3.down * ACCEL * dt;
    }
    if (Input.GetKey(KeyCode.UpArrow))
    {
      worldV += mainCamera.cameraToWorldMatrix * Vector3.back * ACCEL * dt;
    }
    if (Input.GetKey(KeyCode.DownArrow))
    {
      worldV += mainCamera.cameraToWorldMatrix * Vector3.forward * ACCEL * dt;
    }

    // update position 
    Vector3 worldV3 = new Vector3(worldV.x, worldV.y, worldV.z);
    mainCamera.transform.position += worldV3 * dt;

    // velocity damping 
    float d_damp = Mathf.Pow(DAMPING, dt);
    worldV = worldV3 * d_damp;
  }

  void HandleRotation()
  {
    float dt = Time.deltaTime;
    if (Input.GetKey(KeyCode.W))
    {
      mainCamera.transform.Rotate(-ROTATION_SPEED * dt, 0, 0);
    }
    if (Input.GetKey(KeyCode.S))
    {
      mainCamera.transform.Rotate(ROTATION_SPEED * dt, 0, 0);
    }
    if (Input.GetKey(KeyCode.A))
    {
      mainCamera.transform.Rotate(0, -ROTATION_SPEED * dt, 0);
    }
    if (Input.GetKey(KeyCode.D))
    {
      mainCamera.transform.Rotate(0, ROTATION_SPEED * dt, 0);
    }
    // these get inverted because camera looks along negative z direction
    if (Input.GetKey(KeyCode.Q))
    {
      mainCamera.transform.Rotate(0, 0, ROTATION_SPEED * dt);
    }
    if (Input.GetKey(KeyCode.E))
    {
      mainCamera.transform.Rotate(0, 0, -ROTATION_SPEED * dt);
    }
  }
}
