using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TerrainManager : MonoBehaviour
{
    public Terrain titties;
    public float drawDistance;

    // Start is called before the first frame update
    private void Start()
    {
        titties.detailObjectDistance = drawDistance;
    }
}