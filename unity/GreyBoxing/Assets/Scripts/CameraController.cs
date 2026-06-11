using UnityEngine;

public class CameraController : MonoBehaviour
{
    [Header("Screensaver 相机推进")]
    public Vector3 screensaverOffset = new Vector3(-6.46f, 0, 0);
    public float enterTransitionSpeed = 2f;

    [Header("猫跟随")]
    public Transform catTarget;
    public float followSpeed = 3f;

    private Vector3 defaultPosition;

    void Start()
    {
        defaultPosition = transform.position;
    }

    void Update()
    {
        if (GameManager.Instance == null) return;
        GameState state = GameManager.Instance.State;

        Vector3 targetPos;
        if (state == GameState.Screensaver)
        {
            targetPos = defaultPosition + screensaverOffset;

            // Y 和 Z 跟猫，X 只推进不跟猫
            if (catTarget != null)
            {
                targetPos.y = catTarget.position.y;
                targetPos.z = catTarget.position.z;
            }
        }
        else
        {
            // Interactive/Dissolving/Ending 都先用默认机位（Ending 专属机位在阶段4实装）
            targetPos = defaultPosition;
        }

        transform.position = Vector3.Lerp(transform.position, targetPos, Time.deltaTime * followSpeed);
    }
}