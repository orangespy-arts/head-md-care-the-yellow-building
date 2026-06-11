using UnityEngine;
using UnityEngine.EventSystems;

public class ToiletMan : MonoBehaviour, IPointerClickHandler
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
        isOpen = !isOpen;
        animator.SetBool("Closed", isOpen);
    }

    //create public method called CloseWindow, which sets the animator parameter "Closed" to true
    public void CloseWindow()
    {
        isOpen = false;
        windowAnimator.SetBool("Closed", true);
    }
}
