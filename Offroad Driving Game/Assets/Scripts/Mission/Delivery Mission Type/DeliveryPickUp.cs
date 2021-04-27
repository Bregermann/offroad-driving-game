using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DeliveryPickUp : MonoBehaviour
{
    public GameObject dropOff;
    public Image packageImage;
    public AudioSource pickUpSound;

    // Start is called before the first frame update
    private void Start()
    {
        dropOff.SetActive(false);
        packageImage.gameObject.SetActive(false);
    }

    // Update is called once per frame
    private void Update()
    {
    }

    private void OnTriggerEnter(Collider other)
    {
        pickUpSound.Play();
        dropOff.SetActive(true);
        packageImage.gameObject.SetActive(true);
        CPArrow.whichCP++;
        Destroy(gameObject, 1);
    }
}