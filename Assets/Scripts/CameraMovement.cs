using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class CameraMovement : MonoBehaviour
{
	Camera mainCamera;
	Vector4 worldV;
	public bool active;

	public const float ACCEL = 5.0f;
	public const float ROTATION_SPEED = 45.0f;
	public const float OrbitSpeed = 45.0f;
	public const float DAMPING = 0.1f;
	Vector4 initPos;

	private enum MovementMode { Orbit = 1, Free = 2 }
    private Text text;
	private MovementMode movement = MovementMode.Free;
	private GameObject sun;
	// Start is called before the first frame update
	void Start()
	{
		mainCamera = Camera.main;
		active = true;
		initPos = mainCamera.transform.position;
		sun = GameObject.Find("Sun");

		// Load the Arial font from the Unity Resources folder.
		Font arial;
		arial = (Font)Resources.GetBuiltinResource(typeof(Font), "LegacyRuntime.ttf");

		// Create Canvas GameObject.
		GameObject canvasGO = new GameObject();
		canvasGO.name = "Canvas";
		canvasGO.AddComponent<Canvas>();
		canvasGO.AddComponent<CanvasScaler>();
		canvasGO.AddComponent<GraphicRaycaster>();

		// Get canvas from the GameObject.
		Canvas canvas;
		canvas = canvasGO.GetComponent<Canvas>();
		canvas.renderMode = RenderMode.ScreenSpaceOverlay;

		// Create the Text GameObject.
		GameObject textGO = new GameObject();
		textGO.transform.parent = canvasGO.transform;
		textGO.AddComponent<Text>();

		// Set Text component properties.
		text = textGO.GetComponent<Text>();
		text.font = arial;
		text.text = "Free Movement";
		text.fontSize = 24;
		text.alignment = TextAnchor.UpperLeft;

		// Provide Text position and size using RectTransform.
		RectTransform rectTransform;
		rectTransform = text.GetComponent<RectTransform>();
		rectTransform.localPosition = new Vector3(0, 0, 0);
		rectTransform.sizeDelta = new Vector2(Screen.width - 20, Screen.height - 20);
	}

	// Update is called once per frame
	void Update()
	{
		if (active)
		{
			if (movement == MovementMode.Free) {
				HandleMovement();
				HandleRotation();
			} else {
				HandleOrbit();
			}
			if (Input.GetKeyDown(KeyCode.R))
			{
				mainCamera.transform.position = initPos;
			}
			if (Input.GetKeyDown(KeyCode.Tab)) {
				if (movement == MovementMode.Free) {
					movement = MovementMode.Orbit;
					text.text = "Orbit Movement";
				} else {
					movement = MovementMode.Free;
					text.text = "Free Movement";
				}
			}
		}
	}

	void HandleOrbit() {
		float dt = Time.deltaTime;
		if (Input.GetKey(KeyCode.LeftArrow))
		{
			mainCamera.transform.RotateAround(sun.transform.position, Vector3.up, OrbitSpeed * Time.deltaTime);
		}
		if (Input.GetKey(KeyCode.RightArrow))
		{
			mainCamera.transform.RotateAround(sun.transform.position, Vector3.down, OrbitSpeed * Time.deltaTime);
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
