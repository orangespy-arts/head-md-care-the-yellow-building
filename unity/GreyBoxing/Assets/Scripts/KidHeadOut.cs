using UnityEngine;
using UnityEngine.EventSystems;

public class KidHeadOut : MonoBehaviour, IPointerClickHandler
{
    public GameObject kid;

    private Vector3 originalPos;
    private bool isHeadOut;

    private void Awake()
    {
        if (kid != null)
        {
            originalPos = kid.transform.position;
        }
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (kid == null || isHeadOut)
        {
            return;
        }

        isHeadOut = true;
        kid.transform.position = new Vector3(originalPos.x, originalPos.y + 0.7f, originalPos.z);
        StartCoroutine(ResetPosition());
    }

    private System.Collections.IEnumerator ResetPosition()
    {
        yield return new WaitForSeconds(3f);
        if (kid != null)
        {
            kid.transform.position = originalPos;
        }

        isHeadOut = false;
    }
}
