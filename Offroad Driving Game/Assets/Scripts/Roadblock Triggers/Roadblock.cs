using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Roadblock : MonoBehaviour
{
    public bool chase;
    public AudioSource roadBlockSound;
    public GameObject cop;
    public GameObject roadBlock;
    public Transform copTrans;
    public Transform roadBlockTrans;

    public GameObject rock;
    public Transform[] rockSpawns;

    public GameObject roadBlockTriggers;

    public GameObject chaseIsOnEffect;
    public GameObject chaseIsOnEffect2;
    public Transform chaseIsOnEffectTrans;
    public Transform chaseIsOnEffectTrans2;

    // Start is called before the first frame update
    private void Start()
    {
    }

    // Update is called once per frame
    private void Update()
    {
    }

    public void ToggleChase()
    {
        if (chase == true)
        {
            chase = false;
            Debug.Log("false now");
        }
        else if (chase == false)
        {
            ChaseIsOn();
        }
    }

    public void ChaseIsOn()
    {
        roadBlockTriggers.SetActive(true);
        chase = true;
        Instantiate(chaseIsOnEffect, chaseIsOnEffectTrans.position, chaseIsOnEffectTrans.rotation);
        Instantiate(chaseIsOnEffect2, chaseIsOnEffectTrans2.position, chaseIsOnEffectTrans2.rotation);
        Debug.Log("is true");
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player" && chase == true)
        {
            roadBlockSound.Play();
            Instantiate(cop, copTrans.position, copTrans.rotation);
            Instantiate(roadBlock, roadBlockTrans.position, roadBlockTrans.rotation);
            for (int i = 0; i < 10; i++)
            {
                Instantiate(rock, rockSpawns[i].position, rockSpawns[i].rotation);
            }
            roadBlockTriggers.SetActive(false);
        }
    }
}