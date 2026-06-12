using UnityEngine;

public class CameraController : MonoBehaviour
{
    [Header("Screensaver 相机推进")]
    public Vector3 screensaverOffset = new Vector3(-6.46f, 0, 0);
    public float enterTransitionSpeed = 2f;

    [Header("猫跟随")]
    public Transform catTarget;
    public float followSpeed = 3f;

    [Header("Ending zoom out（朝向不变，沿后退方向拉远）")]
    [Tooltip("相机往后退的距离（沿默认朝向的反方向）")]
    public float endingPullbackDistance = 5f;
    public float endingTransitionSpeed = 1.5f;

    private Vector3    defaultPosition;
    private Quaternion defaultRotation;

    void Start()
    {
        defaultPosition = transform.position;
        defaultRotation = transform.rotation;
    }

    void Update()
    {
        if (GameManager.Instance == null) return;
        GameState state = GameManager.Instance.State;

        if (state == GameState.Ending)
        {
            // 沿默认朝向的反方向后退 → 纯 zoom out，朝向保持默认
            Vector3 back = defaultRotation * Vector3.back;
            Vector3 endingPos = defaultPosition + back * endingPullbackDistance;
            transform.position = Vector3.Lerp(transform.position, endingPos,
                Time.deltaTime * endingTransitionSpeed);
            transform.rotation = Quaternion.Slerp(transform.rotation, defaultRotation,
                Time.deltaTime * endingTransitionSpeed);
            return;
        }

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
            targetPos = defaultPosition;
        }

        transform.position = Vector3.Lerp(transform.position, targetPos, Time.deltaTime * followSpeed);
        // Ending 结束后平滑转回默认朝向
        transform.rotation = Quaternion.Slerp(transform.rotation, defaultRotation, Time.deltaTime * followSpeed);
    }
}