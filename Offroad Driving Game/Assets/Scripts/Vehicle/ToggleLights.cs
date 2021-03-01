using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToggleLights : MonoBehaviour
{
    public GameObject leftLight;
    public GameObject rightLight;
    public int onOff;

    // Start is called before the first frame update
    private void Start()
    {
        onOff = 2;
    }

    // Update is called once per frame
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.K))
        {
            if (onOff == 1)
            {
                onOff++;
            }
            else if (onOff == 2)
            {
                onOff--;
            }
        }
        if (onOff == 1)
        {
            leftLight.SetActive(true);
            rightLight.SetActive(true);
        }
        if (onOff == 2)
        {
            leftLight.SetActive(false);
            rightLight.SetActive(false);
        }
    }
}