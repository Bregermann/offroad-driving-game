using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RampBoost : MonoBehaviour
{
    public AudioSource boostSound;
    public GameObject player;
    private Rigidbody playerBody;
    public float gravityOffTimer;

    public float thrust;

    // Start is called before the first frame update
    private void Start()
    {
        playerBody = player.GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    private void Update()
    {
    }

    private void FixedUpdate()
    {
        if (gravityOffTimer > -1)
        {
            gravityOffTimer--;
        }
        if (gravityOffTimer < 0)
        {
            playerBody.useGravity = true;
            MSVehicleControllerFree.gravityOff = false;
        }
        if (gravityOffTimer > 50)
        {
            playerBody.velocity = transform.TransformDirection(new Vector3(0, thrust, thrust));
        }
    }

    private void RampyBoost()
    {
        boostSound.Play();
        gravityOffTimer = 100;
        playerBody.useGravity = false;
        MSVehicleControllerFree.gravityOff = true;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            RampyBoost();
        }
    }
}