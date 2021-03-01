using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterControllerDog : MonoBehaviour
{
    public bool isIdle;

    // Start is called before the first frame update
    private void Start()
    {
        isIdle = true;
    }

    // Update is called once per frame
    private void Update()
    {
        if (isIdle == true)
        {
            IdleMe();
        }
    }

    public void IdleMe()
    {
        //idle
    }
}