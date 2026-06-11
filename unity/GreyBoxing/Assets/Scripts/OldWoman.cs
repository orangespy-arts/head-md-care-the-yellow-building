using UnityEngine;
using UnityEngine.EventSystems;
using System.Collections;

public class OldWomanTalk : MonoBehaviour, IPointerClickHandler, IRoomResettable
{
    private Animator animator;
    private bool hasCompleted = false;
    private bool isPlaying = false;

    private void Start()
    {
        animator = GetComponent<Animator>();
        GameManager.RegisterInteractive("B2");
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (!GameManager.InteractionEnabled) return;
        if (isPlaying) return;

        isPlaying = true;
        animator.SetTrigger("Trigger");
        StartCoroutine(WaitForSequence());
    }

    private IEnumerator WaitForSequence()
    {
        // 等序列真正开始（进入 02-PickUpPhone）
        yield return new WaitUntil(() =>
            animator.GetCurrentAnimatorStateInfo(0).IsName("02-PickUpPhone"));

        // 等序列走完，回到 01-Sit
        yield return new WaitUntil(() =>
            animator.GetCurrentAnimatorStateInfo(0).IsName("01-Sit"));

        if (!hasCompleted)
        {
            hasCompleted = true;
            GameManager.ReportCompletion("B2");
        }

        isPlaying = false;
    }

    public void ResetRoom()
    {
        StopAllCoroutines();
        isPlaying = false;
        hasCompleted = false;
        animator.Rebind();
        animator.Update(0f);
    }
}