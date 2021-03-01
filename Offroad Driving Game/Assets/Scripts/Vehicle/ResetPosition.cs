using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetPosition : MonoBehaviour
{
    public Transform carT;
    public GameObject car;

    // Start is called before the first frame update
    private void Start()
    {
        car = this.gameObject;
    }

    // Update is called once per frame
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.L))
        {
            ResetCar();
        }
    }

    private void ResetCar()
    {
        transform.rotation = Quaternion.Euler(0, 0, 0);
    }
}