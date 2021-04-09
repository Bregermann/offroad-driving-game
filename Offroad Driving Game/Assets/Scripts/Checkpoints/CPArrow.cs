using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CPArrow : MonoBehaviour
{
    public Transform arrowGoHere;
    public static int whichCP;
    public int oldCP;
    public int offset;

    public Transform lookie;
    public Transform[] lookieLous;

    // Start is called before the first frame update
    private void Start()
    {
        transform.LookAt(lookie.transform.position);
    }

    // Update is called once per frame
    private void Update()
    {
        
       lookie.position = lookieLous[whichCP].position;
       transform.LookAt(lookie);
       transform.position = arrowGoHere.position;

    }
}