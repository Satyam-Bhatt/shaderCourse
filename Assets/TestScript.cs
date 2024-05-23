using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestScript : MonoBehaviour
{
    public Transform target;                // The target object the camera will rotate around
    public float distanceHorizontal = 10.0f; // Distance from the target when the camera is horizontal
    public float distanceVertical = 5.0f;    // Distance from the target when the camera is vertical
    public float rotationSpeed = 40.0f;      // Speed of rotation based on mouse movement
    public float smoothTime = 5.0f;          // Smoothing factor for the rotation

    private float x = 0.0f;                  // Current X rotation angle
    private float y = 0.0f;                  // Current Y rotation angle

    void Start()
    {
        if (target == null)
        {
            Debug.LogError("Target is not assigned. Please assign a target object.");
            return;
        }

        Vector3 angles = transform.eulerAngles;
        x = angles.y;
        y = angles.x;
    }

    void LateUpdate()
    {
        if (Input.GetMouseButton(0))
        {
            x += Input.GetAxis("Mouse X") * rotationSpeed * Time.deltaTime;
            y -= Input.GetAxis("Mouse Y") * rotationSpeed * Time.deltaTime;
        }

        Quaternion targetRotation = Quaternion.Slerp(transform.rotation, Quaternion.Euler(y, x, 0.0f), smoothTime * Time.deltaTime);
        Debug.Log(x);
        float distance = Mathf.Lerp(distanceHorizontal, distanceVertical, Mathf.Abs(x / 90f));
        Vector3 offset = new Vector3(0.0f, 0.0f, -distance);

        Vector3 position = targetRotation * offset + target.position;
        transform.position = position;
        transform.rotation = targetRotation;
    }
}
