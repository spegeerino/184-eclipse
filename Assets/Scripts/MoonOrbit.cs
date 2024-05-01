using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class MoonMovement : MonoBehaviour
{
	Camera mainCamera;
	Vector4 worldV;
	public bool active;
	public float OrbitSpeed = 25f;

	public const float ACCEL = 5.0f;
	public const float ROTATION_SPEED = 45.0f;
	public const float DAMPING = 0.1f;
	Vector4 initPos;
	Quaternion initRot;

	private enum MovementMode { Play = 1, Pause = 2 }
    private Text text;
	private MovementMode movement = MovementMode.Pause;
	private GameObject sun, moon;
	// Start is called before the first frame update
	void Start()
	{
		moon = GameObject.Find("Moon");
		sun = GameObject.Find("Sun");

		// Load the Arial font from the Unity Resources folder.
		Font arial;
		arial = (Font)Resources.GetBuiltinResource(typeof(Font), "LegacyRuntime.ttf");

		// Create Canvas GameObject.
		GameObject canvasGO = new GameObject();
		canvasGO.name = "Canvas2";
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
		text.text = "Moon Paused";
		text.fontSize = 24;
		text.alignment = TextAnchor.UpperRight;

		// Provide Text position and size using RectTransform.
		RectTransform rectTransform;
		rectTransform = text.GetComponent<RectTransform>();
		rectTransform.localPosition = new Vector3(0, 0, 0);
		rectTransform.sizeDelta = new Vector2(Screen.width - 20, Screen.height - 20);
	}

	// Update is called once per frame
	void Update()
	{
		updateSpeed();
		handleToggle();
		if (movement == MovementMode.Play)
		{
			moon.transform.RotateAround(sun.transform.position, Vector3.up, OrbitSpeed * Time.deltaTime);
		}
	}

	void updateSpeed() {
		if (Input.GetKey(KeyCode.L))
		{
			if (OrbitSpeed < 25f) {
				OrbitSpeed += 0.5f * Time.deltaTime;
			} if (OrbitSpeed >= 25f) {
				OrbitSpeed = 25f;
			}
		}
		if (Input.GetKey(KeyCode.K))
		{
			if (OrbitSpeed > -25f) {
				OrbitSpeed -= 0.5f* Time.deltaTime;
			} else {
				OrbitSpeed = -25f;
			}
		}
		if (movement == MovementMode.Pause) {
			text.text="Moon Paused\nSpeed: " + OrbitSpeed;
		} else {
			text.text="Moon Orbiting\nSpeed: " + OrbitSpeed;
		}
	}

	void handleToggle() {
		if (Input.GetKeyDown(KeyCode.P)) {
			if (movement == MovementMode.Pause) {
				movement = MovementMode.Play;
			} else {
				movement = MovementMode.Pause;
			}
		}
	}

}
