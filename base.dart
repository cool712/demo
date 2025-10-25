

/**
 * 基础控制器
 * 
 * 功能特性：
 * 1. 日志管理 - 统一的日志记录
 * 2. 国际化支持 - 多语言支持
 * 3. 页面刷新 - 页面数据刷新控制
 * 4. 状态管理 - 页面状态统一管理
 * 5. 加载提示 - 统一的加载状态展示
 * 6. 消息提示 - 统一的提示框管理
 */
 
abstract class BaseController extends GetxController {
  // =============== 基础服务 ===============
  /// 安全存储服务实例
  final storage = SecureStorageService.instance;

  /// 日志服务实例
  final Logger logger = LoggerSingleton.getInstance();

  // =============== 页面状态管理 ===============
  /// 页面状态控制器
  final Rx<PageState> _pageStateController = PageState.DEFAULT.obs;

  /// 对外暴露的页面状态
  PageState get pageState => _pageStateController.value;

  /// 状态队列
  final Queue<PageState> _stateQueue = Queue<PageState>();

  /// 是否正在处理状态队列
  bool _isProcessingStateQueue = false;

  /// 页面刷新控制器
  final RxBool _refreshController = false.obs;

  /// 触发页面刷新
  refreshPage(bool refresh) => _refreshController(refresh);

  // =============== 加载状态管理 ===============
  /// 加载提示信息控制器
  final Rx<String> _loadingMessage = ''.obs;

  /// 获取当前加载提示信息
  String get loadingMessage => _loadingMessage.value;

  // =============== 消息提示管理 ===============
  /// 显示消息
  void showMessage(String message) {
    // _showToast(() => ToastUtil.showInfo(Get.context!, message));
  }

  /// 显示成功消息
  void showSuccessMessage(String message) {
    // _showToast(() => ToastUtil.showSuccess(Get.context!, message));
  }

  /// 显示错误消息
  void showErrorMessage(String message) {
    // _showToast(() => ToastUtil.showError(Get.context!, message));
  }

  /// 显示警告消息
  void showWarningMessage(String message) {
    // _showToast(() => ToastUtil.showWarning(Get.context!, message));
  }

  /// 统一的消息显示处理
  void _showToast(VoidCallback showToast) {
    // 将当前状态加入队列
    _stateQueue.add(_pageStateController.value);
    // 设置消息状态
    _updatePageState(PageState.MESSAGE);

    // 显示消息
    showToast();
    if (_stateQueue.isNotEmpty) {
      final previousState = _stateQueue.removeLast();
      _updatePageState(previousState);
    }
  }

  /// 处理下一个状态
  void _processNextState() {
    if (_stateQueue.isEmpty) {
      _isProcessingStateQueue = false;
      return;
    }

    _isProcessingStateQueue = true;
    final nextState = _stateQueue.removeLast();
    _updatePageState(nextState);
  }

  /// 更新页面状态
  void _updatePageState(PageState state) {
    _pageStateController.value = state;
    logger.d('Page state updated to: $state');
  }

  // =============== 页面状态操作方法 ===============
  /// 重置页面状态为默认状态
  void resetPageState() => _updatePageState(PageState.DEFAULT);

  /// 更新页面状态
  void updatePageState(PageState state) => _updatePageState(state);

  // =============== 加载状态操作方法 ===============
  /// 显示加载状态
  /// [message] 可选的加载提示信息
  showLoading([String? message]) {
    // 将当前状态加入队列
    _stateQueue.add(_pageStateController.value);
    // 设置loading状态
    _updatePageState(PageState.LOADING);
    logger.d('showLoading: ${_pageStateController.value}');
    _loadingMessage.value = message ?? '';
  }

  /// 隐藏加载状态
  hideLoading() {
    if (_stateQueue.isNotEmpty) {
      final previousState = _stateQueue.removeLast();
      _updatePageState(previousState);
    }
    _loadingMessage.value = '';
  }

  // =============== 生命周期方法 ===============
  @override
  void onClose() {
    _loadingMessage.close();
    _pageStateController.close();
    _stateQueue.clear();
    super.onClose();
  }
}
