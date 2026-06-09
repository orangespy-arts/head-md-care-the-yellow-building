using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CatController : MonoBehaviour
{
    [Header("窗台")]
    public Transform[] balconies;

    [Header("参数")]
    public float minStayTime = 2f;
    public float maxStayTime = 5f;
    public float jumpClipLength = 1f;
    public Vector3 positionOffset = Vector3.zero;

    private Animator animator;
    private int currentIndex = 2;

    private int[,] coords = new int[,]
    {
        {0, 0}, // A1
        {0, 1}, // A2
        {0, 2}, // A3
        {1, 0}, // B1
        {1, 1}, // B2
        {1, 2}, // B3
        {2, 0}, // C1
        {2, 1}, // C2
        {2, 2}, // C3
    };

    void Start()
    {
        animator = GetComponentInChildren<Animator>();
        currentIndex = 2;
        // transform.position = balconies[currentIndex].position + positionOffset;
        transform.rotation = balconies[currentIndex].rotation;
        StartCoroutine(JumpLoop());
    }

    private bool IsValidJump(int from, int to)
    {
        int colDiff = Mathf.Abs(coords[from, 0] - coords[to, 0]);
        int rowDiff = Mathf.Abs(coords[from, 1] - coords[to, 1]);
        return colDiff > 0 && rowDiff <= 1;
    }

    private IEnumerator JumpLoop()
    {
        while (true)
        {
            float stayTime = Random.Range(minStayTime, maxStayTime);
            yield return new WaitForSeconds(stayTime);

            List<int> validTargets = new List<int>();
            for (int i = 0; i < balconies.Length; i++)
            {
                if (i != currentIndex && IsValidJump(currentIndex, i))
                    validTargets.Add(i);
            }

            if (validTargets.Count == 0) continue;

            int nextIndex = validTargets[Random.Range(0, validTargets.Count)];

            animator.SetTrigger("DoJump");
            yield return new WaitForSeconds(jumpClipLength);

            currentIndex = nextIndex;
            transform.position = balconies[currentIndex].position + positionOffset;
            transform.rotation = balconies[currentIndex].rotation;
        }
    }
}