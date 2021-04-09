using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CPTrigger : MonoBehaviour
{
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
        if (other.tag == "Player")
        {
            CPArrow.whichCP++;
            Debug.Log("work? play? sex! " + CPArrow.whichCP);
            Destroy(gameObject);
        }
    }
}