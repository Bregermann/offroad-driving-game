using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollideWithWoman : MonoBehaviour
{
    public AudioSource womanSound;

    // Start is called before the first frame update
    private void Start()
    {
    }

    // Update is called once per frame
    private void Update()
    {
    }

    private void OnCollisionEnter(Collision collision)
    {
        womanSound.Play();
    }
}