using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DropOff : MonoBehaviour
{
    public AudioSource missionCompleteSound;
    public Image missionCompleteImage;

    // Start is called before the first frame update
    private void Start()
    {
    }

    // Update is called once per frame
    private void Update()
    {
    }

    private void OnTriggerEnter(Collider other)
    {
        MissionManager.missionsComplete++; //will have to add way to check if mission already completed before
    }
}