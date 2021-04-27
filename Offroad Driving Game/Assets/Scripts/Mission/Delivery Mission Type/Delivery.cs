using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Delivery : MonoBehaviour
{
    public GameObject package;
    public Transform packageSpawn;

    // Start is called before the first frame update
    private void Start()
    {
        Instantiate(package, packageSpawn);
    }

    // Update is called once per frame
    private void Update()
    {
    }
}