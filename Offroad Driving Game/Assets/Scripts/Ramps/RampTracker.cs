using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RampTracker : MonoBehaviour
{
    private int totalRamps;
    public static int allRampsInWorld;
    private int regionOneRamps;
    private int regionTwoRamps;
    private int regionThreeRamps;
    private int regionFourRamps;
    private int regionFiveRamps;
    private int regionSixRamps;
    public Text rampCountText;
    public static int ramps;

    // Start is called before the first frame update
    private void Start()
    {
        allRampsInWorld = 64;
    }

    // Update is called once per frame
    private void Update()
    {
    }

    private void RampCountUp()
    {
        totalRamps++;
        ramps = totalRamps;
        rampCountText.text = "Ramps Yeeted " + totalRamps;
        if (this.gameObject.tag == "RegionOne")
        {
            regionOneRamps++;
        }
        if (this.gameObject.tag == "RegionTwo")
        {
            regionTwoRamps++;
        }
        if (this.gameObject.tag == "RegionThree")
        {
            regionThreeRamps++;
        }
        if (this.gameObject.tag == "RegionFour")
        {
            regionFourRamps++;
        }
        if (this.gameObject.tag == "RegionFive")
        {
            regionFiveRamps++;
        }
        if (this.gameObject.tag == "RegionSix")
        {
            regionSixRamps++;
        }
        if (totalRamps == allRampsInWorld)
        {
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            RampCountUp();
        }
    }
}