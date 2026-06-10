using UnityEngine;
using UnityEngine.EventSystems;

public class ToiletMan : MonoBehaviour, IPointerClickHandler, IRoomResettable
{
    
   //on click, change animator parameter, opening to true
    private Animator animator;
    private bool isOpen = true;
    //create public animator called window
    public Animator windowAnimator;

    private void Start()
    {
        animator = GetComponent<Animator>();
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (!GameManager.InteractionEnabled) return;
        isOpen = !isOpen;
        animator.SetBool("Closed", isOpen);
    }

    //create public method called CloseWindow, which sets the animator parameter "Closed" to true
    public void CloseWindow()
    {
        isOpen = false;
        windowAnimator.SetBool("Closed", true);
    }

    public void ResetRoom()
    {
        StopAllCoroutines();
        isOpen = true;
        animator.Rebind();
        animator.Update(0f);
        if (windowAnimator != null)
        {
            windowAnimator.Rebind();
            windowAnimator.Update(0f);
        }
    }
}
