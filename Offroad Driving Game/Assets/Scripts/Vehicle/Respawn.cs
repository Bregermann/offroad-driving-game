using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Respawn : MonoBehaviour
{
    public Vector3[] spawns;
    public GameObject player;
    public int whichSpawn;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            BringMeBack();
        }
    }

    private void BringMeBack()
    {
        player.transform.position = spawns[whichSpawn];
    }
}