using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RampTarget : MonoBehaviour
{
    public Renderer rampTar;
    public AudioSource rampSound;
    public GameObject explosion;
    public Transform explosionSpawnPoint;
    public GameObject rampPopUp;
    public Text rampText;

    // Start is called before the first frame update
    private void Start()
    {
    }

    // Update is called once per frame
    private void Update()
    {
    }

    private void RampyTarget()
    {
        Instantiate(explosion, explosionSpawnPoint.position, explosionSpawnPoint.rotation);
        rampSound.Play();
        rampText.color = Random.ColorHSV(0f, 1f, 1f, 1f, 0.5f, 1f);
        rampText.text = "Holy Dingus YA GOT URSELF A RAMP THERE BUD " + (RampTracker.ramps + 1) + " outta " + RampTracker.allRampsInWorld;
        rampPopUp.SetActive(true);
        rampTar.material.color = Color.magenta;
        this.gameObject.SetActive(false);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            RampyTarget();
        }
    }
}