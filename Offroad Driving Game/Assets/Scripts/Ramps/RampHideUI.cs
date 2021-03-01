using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RampHideUI : MonoBehaviour
{
    public GameObject background;
    public Text text;
    public AudioSource yay;

    // Start is called before the first frame update
    private void Start()
    {
    }

    // Update is called once per frame
    private void Update()
    {
    }

    private void HideUI()
    {
        yay.Play();
        text.text = "";
        background.SetActive(false);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            HideUI();
        }
    }
}