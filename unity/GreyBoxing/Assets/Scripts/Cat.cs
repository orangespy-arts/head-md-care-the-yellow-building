using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CatController : MonoBehaviour
{
    [Header("窗台")]
    public Transform[] balconies;

    [Header("朝向参考点")]
    public Transform facingTarget;

    [Header("参数")]
    public float minStayTime = 2f;
    public float maxStayTime = 5f;
    public float jumpClipLength = 1f;
    public float arcHeight = 3f;
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
        transform.position = balconies[currentIndex].position + positionOffset;
        FaceTarget();
        StartCoroutine(JumpLoop());
    }

    private void FaceTarget()
    {
        if (facingTarget == null) return;
        Vector3 dir = facingTarget.position - transform.position;
        dir.y = 0;
        if (dir.sqrMagnitude > 0.001f)
            transform.rotation = Quaternion.LookRotation(dir);
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

            // 跳跃前转向目标窗台
            Vector3 jumpDir = balconies[nextIndex].position - transform.position;
            jumpDir.y = 0;
            if (jumpDir.sqrMagnitude > 0.001f)
                transform.rotation = Quaternion.LookRotation(jumpDir);

            animator.SetTrigger("DoJump");

            // 抛物线位移
            Vector3 startPos = transform.position;
            Vector3 endPos = balconies[nextIndex].position + positionOffset;
            float elapsed = 0f;

            while (elapsed < jumpClipLength)
            {
                elapsed += Time.deltaTime;
                float t = Mathf.Clamp01(elapsed / jumpClipLength);
                Vector3 flatPos = Vector3.Lerp(startPos, endPos, t);
                flatPos.y += arcHeight * Mathf.Sin(t * Mathf.PI);
                transform.position = flatPos;
                yield return null;
            }

            // 落地
            currentIndex = nextIndex;
            transform.position = endPos;
            FaceTarget();
        }
    }
}