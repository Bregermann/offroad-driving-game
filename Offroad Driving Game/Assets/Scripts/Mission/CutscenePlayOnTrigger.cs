using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CutscenePlayOnTrigger : MonoBehaviour
{
    public GameObject videoPlayer;
    public GameObject cutsceneVideo;

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
        videoPlayer.SetActive(true);
        cutsceneVideo.SetActive(true);
    }
}