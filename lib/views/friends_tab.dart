import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/friend.dart';
import '../services/auth_service.dart';
import 'package:get/get.dart';
import '../controllers/friends_controller.dart';
import '../widgets/vrchat_network_image.dart';
import '../services/world_service.dart';

// 해당 파일 내에서만 사용하는: 오버스크롤 효과(바운스/글로우) 제거
class _NoGlowNoBounceBehavior extends ScrollBehavior {
  const _NoGlowNoBounceBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // Glow/Bounce 인디케이터 표시 안 함
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); // 끝에서 바운스 방지
  }
}

class FriendsTab extends StatefulWidget {
  final AuthService authService;

  const FriendsTab({super.key, required this.authService});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  final FriendsController c = Get.find<FriendsController>();
  late WorldService _worldService;

  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'Online'; // Online, Active, Ask Me, Offline
  final Map<String, String> _worldNameCache = {}; // worldId -> worldName 캐시

  // Future 캐싱을 위한 변수들
  final Map<String, Future<Map<String, dynamic>>> _locationFutureCache = {};

  // PageView 컨트롤러 추가
  late PageController _pageController;

  // 상태 칩 자동 가시화용 키/스크롤 관리
  final Map<String, GlobalKey> _chipKeys = {};

  // 상태 옵션 순서 정의
  final List<Map<String, String>> _statusOptions = [
    {'key': 'Online', 'label': 'Online'},
    {'key': 'Active', 'label': 'Active'},
    {'key': 'Ask Me', 'label': 'Ask Me'},
    {'key': 'Busy', 'label': 'Busy'},
    {'key': 'Offline', 'label': 'Offline'},
  ];

  // 정렬 방식 상태 변수 추가
  String _sortType = 'name'; // 'name'만 지원, 추후 확장 가능

  // 필터 칩 영역에서만 바운스/글로우 제거용 로컬 스크롤 비헤이비어
  static const _noGlowNoBounceBehavior = _NoGlowNoBounceBehavior();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFriends);

    // WorldService 초기화
    final authCookie = widget.authService.authCookie ?? '';
    print(
      '🍪 Auth Cookie: ${authCookie.isNotEmpty ? "Present (${authCookie.length} chars)" : "Missing"}',
    );

    _worldService = WorldService(
      baseUrl: 'https://api.vrchat.cloud/api/1',
      authCookie: authCookie,
    );

    // PageController 초기화
    _pageController = PageController(initialPage: 0);

    // 상태 칩 키 초기화
    for (final s in _statusOptions) {
      final key = s['key']!;
      _chipKeys[key] = GlobalKey();
    }

    // 초기 월드 이름 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadWorldNames();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    // 이미 로딩 중이거나 쿨다운 중이면 새로고침 하지 않음
    if (c.loading.value || !c.canRefresh.value) {
      // .value 추가
      print('새로고침이 불가능한 상태입니다.');
      return;
    }

    setState(() {});

    // 인스턴스 정보 캐시 초기화
    _locationFutureCache.clear();
    print('인스턴스 정보 캐시 초기화됨');

    print('새로고침 버튼으로 친구 목록 새로고침 실행');
    await c.refreshFriends();

    // 친구 목록 로드 후 월드 이름들을 백그라운드에서 캐시
    _preloadWorldNames();
  }

  /// 친구들의 월드 이름을 백그라운드에서 미리 로드
  void _preloadWorldNames() {
    final uniqueWorldIds = <String>{};

    // 모든 친구의 위치에서 월드 ID 추출
    for (final friend in c.friends) {
      final location = friend.location;
      if (location != null && location.startsWith('wrld_')) {
        String worldId;
        if (location.contains(':')) {
          worldId = location.split(':')[0];
        } else {
          worldId = location;
        }
        uniqueWorldIds.add(worldId);
      }
    }

    // 아직 캐시되지 않은 월드들만 로드
    for (final worldId in uniqueWorldIds) {
      if (!_worldNameCache.containsKey(worldId)) {
        _loadWorldNameInBackground(worldId);
      }
    }
  }

  /// 백그라운드에서 월드 이름 로드
  void _loadWorldNameInBackground(String worldId) {
    _worldService
        .getLocationDisplayText(worldId)
        .then((worldName) {
          if (mounted) {
            setState(() {
              _worldNameCache[worldId] = worldName;
            });
          }
        })
        .catchError((error) {
          print('월드 이름 로드 실패: $worldId - $error');
        });
  }

  void _filterFriends() {
    // 검색어 변경 시 리스트를 즉시 갱신하기 위해 리빌드
    if (!mounted) return;
    setState(() {});
  }

  // 특정 statusKey에 대해 친구가 매칭되는지 확인하는 함수
  bool _matchesStatusForKey(Friend friend, String statusKey) {
    final status = friend.status;
    final location = friend.location;

    if (status == null) return statusKey == 'Offline';

    // location이 wrld_로 시작하거나 private인지 확인 (실제 월드에 있는지)
    final isInWorld =
        location != null &&
        (location.startsWith('wrld_') || location == 'private');

    switch (statusKey) {
      case 'Online':
        // 월드에 있으면서 active 또는 join me
        return isInWorld &&
            (status.toLowerCase() == 'active' ||
                status.toLowerCase() == 'join me');
      case 'Active':
        // offline을 제외한 모든 상태이면서 location이 offline이거나 월드 정보가 없는 경우
        return status.toLowerCase() != 'offline' &&
            (location == 'offline' ||
                location == null ||
                (!location.startsWith('wrld_') && location != 'private'));
      case 'Ask Me':
        // 월드에 있으면서 ask me
        return isInWorld && status.toLowerCase() == 'ask me';
      case 'Busy':
        // 월드에 있으면서 busy
        return isInWorld && status.toLowerCase() == 'busy';
      case 'Offline':
        return status.toLowerCase() == 'offline';
      default:
        return true;
    }
  }

  Widget _buildStatusFilterAndSort() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 필터 버튼: 가로 스크롤
          Expanded(
            child: ScrollConfiguration(
              behavior: _noGlowNoBounceBehavior,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: Row(
                  children: _statusOptions.map((status) {
                    final isSelected = _selectedStatus == status['key'];
                    return GestureDetector(
                      onTap: () {
                        _onStatusFilterTapped(status['key']!);
                      },
                      child: Container(
                        key: _chipKeys[status['key']!],
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Text(
                          status['label']!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // 정렬 아이콘 및 드롭다운
          SizedBox(width: 12),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortType,
              icon: const Icon(Icons.sort, color: Colors.black),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              items: const [
                DropdownMenuItem(value: 'name', child: Text('이름순')),
                DropdownMenuItem(value: 'location', child: Text('위치순')),
                DropdownMenuItem(value: 'status', child: Text('상태순')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _sortType = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendCard(Friend friend) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            VRChatCircleAvatar(
              id: friend.id,
              radius: 25,
              imageUrl: friend.currentAvatarThumbnailImageUrl,
              child: const Icon(Icons.person),
            ),
            // 온라인 상태 표시
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getStatusColor(friend.status, friend.location),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          friend.displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _getTrustColor(friend.tags), // 닉네임 색상 적용
          ),
        ),
        subtitle: Text(
          _getLocationText(friend),
          style: const TextStyle(color: Colors.black54, fontSize: 12),
          maxLines: 1, // 한 줄로 제한
          overflow: TextOverflow.ellipsis, // 말줄임표 처리
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (friend.lastPlatform != null)
              Icon(
                _getPlatformIcon(friend.lastPlatform!),
                size: 16,
                color: Colors.black54,
              ),
            const SizedBox(height: 4),
            Text(
              _getStatusText(friend.status, friend.location),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        onTap: () {
          _showFriendDetails(friend);
        },
      ),
    );
  }

  Color _getStatusColor(String? status, String? location) {
    final isInWorld =
        location != null &&
        (location.startsWith('wrld_') || location == 'private');

    switch (status?.toLowerCase()) {
      case 'active':
        return isInWorld ? Colors.green : Colors.yellow[700]!;
      case 'join me':
        return isInWorld ? Colors.blue : Colors.yellow[700]!;
      case 'ask me':
        return isInWorld ? Colors.orange : Colors.yellow[700]!;
      case 'busy':
        return isInWorld ? Colors.red : Colors.yellow[700]!;
      case 'offline':
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status, String? location) {
    switch (status?.toLowerCase()) {
      case 'active':
      case 'join me':
        return 'Online';
      case 'ask me':
        return 'Ask Me';
      case 'busy':
        return 'Busy';
      case 'offline':
      default:
        return 'Offline';
    }
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'android':
        return Icons.phone_android;
      case 'standalonewindows':
        return Icons.desktop_windows;
      case 'ios':
        return Icons.phone_iphone;
      default:
        return Icons.device_unknown;
    }
  }

  String _getLocationText(Friend friend) {
    final location = friend.location;
    if (location == null || location.isEmpty) return '';

    // 위치 정보를 읽기 쉬운 형태로 변환
    return _getReadableLocationText(location);
  }

  /// 위치 정보를 읽기 쉬운 형태로 변환
  String _getReadableLocationText(String location) {
    if (location.isEmpty || location == 'offline') {
      return 'Offline';
    }
    if (location == 'private') {
      return 'Private';
    }

    // 월드 ID 형태라면 좀 더 읽기 쉽게 변환
    if (location.startsWith('wrld_')) {
      // 인스턴스 정보가 있는 경우 (wrld_xxx:12345~xxx)
      if (location.contains(':')) {
        final parts = location.split(':');
        final worldId = parts[0];
        final instanceInfo = parts.length > 1 ? parts[1] : '';

        // 인스턴스 타입 추출 (예: 12345~hidden(usr_xxx) -> hidden)
        String instanceType = '';
        if (instanceInfo.contains('~')) {
          final instanceParts = instanceInfo.split('~');
          if (instanceParts.length > 1) {
            final typeInfo = instanceParts[1];
            if (typeInfo.contains('(')) {
              instanceType = typeInfo.split('(')[0];
            } else {
              instanceType = typeInfo;
            }
          }
        }

        // 월드 이름이 캐시되어 있으면 사용
        if (_worldNameCache.containsKey(worldId)) {
          final worldName = _worldNameCache[worldId]!;
          return instanceType.isNotEmpty
              ? '$worldName ($instanceType)'
              : worldName;
        }

        // 캐시가 없으면 월드 ID와 인스턴스 타입 표시
        return instanceType.isNotEmpty ? '$worldId ($instanceType)' : worldId;
      }

      // 월드 이름이 캐시되어 있으면 사용
      if (_worldNameCache.containsKey(location)) {
        return _worldNameCache[location]!;
      }

      // 월드 ID만 있는 경우
      return location;
    }

    return location;
  }

  void _showFriendDetails(Friend friend) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 드래그 핸들
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            // 스크롤 가능한 컨텐츠
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 아바타와 이름
                    Center(
                      child: Column(
                        children: [
                          VRChatCircleAvatar(
                            id: friend.id,
                            radius: 50,
                            imageUrl: friend.currentAvatarImageUrl,
                            child: const Icon(Icons.person, size: 50),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            friend.displayName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            friend.id,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 18),
                          // 기능 버튼 Row 추가
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _circleIconButton(
                                icon: Icons.delete,
                                tooltip: '친구 삭제',
                                color: Colors.red,
                                onTap: () {
                                  // TODO: 친구 삭제 기능 연결
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('친구 삭제 기능 준비 중'),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              _circleIconButton(
                                icon: Icons.refresh,
                                tooltip: '정보 새로고침',
                                color: Colors.blue,
                                onTap: () {
                                  // TODO: 친구 정보 새로고침 기능 연결
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('새로고침 기능 준비 중'),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              _circleIconButton(
                                icon: Icons.star,
                                tooltip: '즐겨찾기',
                                color: Colors.amber,
                                onTap: () {
                                  // TODO: 즐겨찾기 기능 연결
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('즐겨찾기 기능 준비 중'),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              _circleIconButton(
                                icon: Icons.visibility,
                                tooltip: '아바타 크게 보기',
                                color: Colors.green,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Image.network(
                                          friend.currentAvatarImageUrl ?? '',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              _circleIconButton(
                                icon: Icons.report,
                                tooltip: '신고',
                                color: Colors.deepPurple,
                                onTap: () {
                                  // TODO: 신고 기능 연결
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('신고 기능 준비 중')),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bio 섹션
                    if (friend.bio != null && friend.bio!.isNotEmpty) ...[
                      const Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(friend.bio!),
                      const SizedBox(height: 20),
                    ],

                    // Details 섹션
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Status',
                      _getStatusText(friend.status, friend.location),
                    ),
                    if (friend.statusDescription != null &&
                        friend.statusDescription!.isNotEmpty)
                      _buildDetailRow(
                        'Status Message',
                        friend.statusDescription!,
                      ),
                    _buildDetailRow('Location', _getLocationText(friend)),
                    if (friend.lastPlatform != null)
                      _buildDetailRow('Platform', friend.lastPlatform!),
                    if (friend.lastLogin != null)
                      _buildDetailRow(
                        'Last Login',
                        _formatDateTime(friend.lastLogin!),
                      ),
                    _buildDetailRow('User ID', friend.id),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // 페이지 변경 처리 함수 추가
  void _onPageChanged(int index) {
    setState(() {
      _selectedStatus = _statusOptions[index]['key']!;
    });
    _filterFriends();
    // 선택된 상태 칩이 가려져 있다면 자동으로 보이도록 스크롤
    _scrollToSelectedStatusChip();
  }

  // 상태 필터 버튼 클릭 시 페이지도 함께 변경
  void _onStatusFilterTapped(String statusKey) {
    final index = _statusOptions.indexWhere(
      (status) => status['key'] == statusKey,
    );
    if (index != -1) {
      // 페이지 컨트롤러는 즉시 대상 페이지로 점프 (중간 페이지 노출 방지)
      if (_pageController.hasClients) {
        _pageController.jumpToPage(index);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(index);
          }
        });
      }
      // setState는 onPageChanged에서 처리됨
    }
  }

  // 선택된 상태 칩이 화면 안으로 들어오도록 보정
  void _scrollToSelectedStatusChip() {
    final key = _chipKeys[_selectedStatus];
    final ctx = key?.currentContext;
    if (ctx != null) {
      // 수평 스크롤뷰에서 해당 칩이 완전히 보이도록 애니메이션
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.5, // 중앙 근처로 위치
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // trust rank에 따라 닉네임 색상 반환 함수 (순서 상관없이 가장 높은 등급 적용)
  Color _getTrustColor(List<String>? tags) {
    if (tags == null || tags.isEmpty)
      return const Color(0xFFCCCCCC); // default gray
    if (tags.contains('system_trust_veteran'))
      return const Color(0xFFB18FFF); // purple
    if (tags.contains('system_trust_trusted'))
      return const Color(0xFFFF7B42); // orange
    if (tags.contains('system_trust_known'))
      return const Color(0xFF5ED061); // green
    if (tags.contains('system_trust_basic'))
      return const Color(0xFF1778FF); // blue
    return const Color(0xFFCCCCCC); // default gray
  }

  // 원형 아이콘 버튼 위젯 함수 추가
  Widget _circleIconButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '친구',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        actions: [
          Obx(() {
            final isLoading = c.loading.value;
            final canRefresh = c.canRefresh.value; // .value 추가
            final isEnabled = !isLoading && canRefresh;

            // 디버깅을 위한 로그
            if (!isEnabled) {
              print(
                '새로고침 버튼 비활성화: isLoading=$isLoading, canRefresh=$canRefresh, remainingSeconds=${c.remainingCooldownSeconds}',
              );
            }

            return Container(
              margin: const EdgeInsets.only(right: 12),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isEnabled ? Colors.black : Colors.grey,
                  width: 1.2,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 18,
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.refresh,
                        color: isEnabled ? Colors.black : Colors.grey,
                        size: 18,
                      ),
                onPressed: isEnabled ? _loadFriends : null,
                tooltip: isLoading
                    ? '로딩 중...'
                    : !canRefresh
                    ? '${c.remainingCooldownSeconds}초 후 사용 가능'
                    : '새로고침',
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // 검색창 (최신 모던 스타일, 포인트 컬러: 검정)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 18,
                ),
                hintText: '친구 이름, ID 검색',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 26,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 22,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: Color(0xFFF5F6FA),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              onChanged: (_) {},
            ),
          ),
          // 상태 필터 버튼 + 정렬 아이콘
          _buildStatusFilterAndSort(),
          // PageView 추가: 상태별 친구 목록 표시 (Obx는 ListView.builder에만 적용)
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _statusOptions.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, pageIndex) {
                final statusKey = _statusOptions[pageIndex]['key']!;
                final query = _searchController.text.toLowerCase();
                // Obx는 friends 필터링 결과를 사용하는 ListView.builder에만 적용
                return Obx(() {
                  final filtered = c.friends.where((friend) {
                    final matchesSearch =
                        query.isEmpty ||
                        friend.displayName.toLowerCase().contains(query) ||
                        friend.id.toLowerCase().contains(query);
                    final matchesStatus = _matchesStatusForKey(
                      friend,
                      statusKey,
                    );
                    return matchesSearch && matchesStatus;
                  }).toList();
                  // 정렬 방식에 따라 친구 목록 정렬
                  filtered.sort((a, b) {
                    if (_sortType == 'name') {
                      final aOnline = a.status != 'offline';
                      final bOnline = b.status != 'offline';
                      if (aOnline != bOnline) return bOnline ? 1 : -1;
                      return a.displayName.compareTo(b.displayName);
                    } else if (_sortType == 'location') {
                      final aLocation = a.location ?? 'offline';
                      final bLocation = b.location ?? 'offline';
                      final locationCompare = aLocation.compareTo(bLocation);
                      if (locationCompare != 0) return locationCompare;
                      return a.displayName.compareTo(b.displayName);
                    } else if (_sortType == 'status') {
                      final aStatus = a.status ?? 'offline';
                      final bStatus = b.status ?? 'offline';
                      final statusOrder = [
                        'active',
                        'join me',
                        'ask me',
                        'busy',
                        'offline',
                      ];
                      final aIndex = statusOrder.indexOf(aStatus.toLowerCase());
                      final bIndex = statusOrder.indexOf(bStatus.toLowerCase());
                      final aOrder = aIndex == -1 ? statusOrder.length : aIndex;
                      final bOrder = bIndex == -1 ? statusOrder.length : bIndex;
                      if (aOrder != bOrder) return aOrder.compareTo(bOrder);
                      return a.displayName.compareTo(b.displayName);
                    }
                    return 0;
                  });
                  if (filtered.isEmpty) {
                    return const Center(child: Text('친구가 없습니다.'));
                  }

                  // 위치순 정렬일 때만 위치별로 그룹화하여 헤더 표시
                  if (_sortType == 'location') {
                    // 위치별로 그룹화
                    final locationGroups = <String, List<Friend>>{};
                    for (final friend in filtered) {
                      final location = friend.location ?? 'offline';
                      locationGroups
                          .putIfAbsent(location, () => [])
                          .add(friend);
                    }

                    // 각 위치 그룹 내의 친구들 정렬 (이름순)
                    for (final entry in locationGroups.entries) {
                      entry.value.sort(
                        (a, b) => a.displayName.compareTo(b.displayName),
                      );
                    }

                    final locationEntries = locationGroups.entries.toList();

                    // 위치 그룹들 자체도 정렬
                    locationEntries.sort((a, b) {
                      final aLocation = a.key;
                      final bLocation = b.key;

                      // offline을 맨 마지막으로
                      if (aLocation == 'offline' && bLocation != 'offline')
                        return 1;
                      if (bLocation == 'offline' && aLocation != 'offline')
                        return -1;

                      // private를 offline 바로 앞으로
                      if (aLocation == 'private' &&
                          bLocation != 'private' &&
                          bLocation != 'offline')
                        return 1;
                      if (bLocation == 'private' &&
                          aLocation != 'private' &&
                          aLocation != 'offline')
                        return -1;

                      return aLocation.compareTo(bLocation);
                    });

                    return ListView.builder(
                      itemCount: locationEntries.length,
                      itemBuilder: (context, groupIndex) {
                        final entry = locationEntries[groupIndex];
                        final location = entry.key;
                        final friendsInLocation = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 위치 헤더
                            _buildLocationHeader(
                              location,
                              friendsInLocation.length,
                            ),
                            // 해당 위치의 친구들
                            ...friendsInLocation.map(
                              (friend) => _buildFriendCard(friend),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // 이름순, 상태순일 때는 일반 리스트 (헤더 없음)
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, idx) {
                        final friend = filtered[idx];
                        return _buildFriendCard(friend);
                      },
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 위치 헤더 위젯 생성 (위치 정보와 인스턴스 정보 표시)
  Widget _buildLocationHeader(String location, int friendCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE1E4E8), width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 위치 정보와 인스턴스 정보를 캐시된 Future로 로드
          FutureBuilder<Map<String, dynamic>>(
            future: _getCachedLocationInfo(location),
            builder: (context, snapshot) {
              final data = snapshot.data;
              final worldName =
                  data?['worldName'] ?? _getSimpleLocationText(location);
              final instanceType = data?['instanceType'] ?? '';
              final totalUsers = data?['totalUsers'] ?? 0;
              final instanceFriendCount = data?['friendCount'] ?? 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 월드 이름
                  Text(
                    worldName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a1a),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 인스턴스 정보와 인원수
                  Row(
                    children: [
                      if (instanceType.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getInstanceTypeColor(instanceType),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            instanceType,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A9EFF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          totalUsers > 0
                              ? '($totalUsers/${instanceFriendCount})'
                              : '$friendCount명',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4A9EFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// 인스턴스 타입별 색상
  Color _getInstanceTypeColor(String instanceType) {
    print(instanceType);
    switch (instanceType.toLowerCase()) {
      case 'public':
        return const Color(0xFF10B981); // 초록색
      case 'friends+':
      case 'hidden':
        return const Color(0xFFF59E0B); // 주황색
      case 'friends':
        return const Color(0xFF3B82F6); // 파란색
      case 'private':
      case 'invite only':
        return const Color(0xFFEF4444); // 빨간색
      case 'group':
      case 'group+':
      case 'grouppublic':
        return const Color(0xFF8B5CF6); // 보라색
      default:
        return const Color(0xFF6B7280); // 회색
    }
  }

  /// 캐시된 Future를 반환하여 중복 API 호출 방지
  Future<Map<String, dynamic>> _getCachedLocationInfo(String location) {
    // 이미 캐시된 Future가 있으면 재사용
    if (_locationFutureCache.containsKey(location)) {
      return _locationFutureCache[location]!;
    }

    // 새로운 Future 생성하고 캐시에 저장
    final future = _getLocationAndInstanceInfo(location);
    _locationFutureCache[location] = future;
    return future;
  }

  /// 위치와 인스턴스 정보를 함께 가져오는 메서드
  Future<Map<String, dynamic>> _getLocationAndInstanceInfo(
    String location,
  ) async {
    if (location.isEmpty || location == 'offline' || location == 'private') {
      return {
        'worldName': _getSimpleLocationText(location),
        'instanceType': '',
        'totalUsers': 0,
        'friendCount': 0,
      };
    }

    try {
      // 월드 ID와 인스턴스가 포함된 경우 - 인스턴스 정보만 가져오기
      if (location.startsWith('wrld_') && location.contains(':')) {
        print('🔍 Fetching instance info for: $location');

        try {
          final instance = await _worldService.getInstance(location);
          print('✅ Instance API call successful');

          // 인스턴스 정보에서 월드 이름과 기타 정보 추출
          final worldName =
              instance?.worldName ?? _getSimpleLocationText(location);
          final instanceType = instance?.displayType ?? '';
          final totalUsers = instance?.nUsers ?? 0;
          final friendCount = instance?.friendCount ?? 0;

          print('✅ Location: $location');
          print('📍 World: $worldName');
          print('🏷️ Instance Type: $instanceType (raw: ${instance?.type})');
          print('👥 Users: $totalUsers');
          print('👫 Friends: $friendCount');
          print('---');

          return {
            'worldName': worldName,
            'instanceType': instanceType,
            'totalUsers': totalUsers,
            'friendCount': friendCount,
          };
        } catch (instanceError) {
          print('❌ Instance API call failed: $instanceError');

          // 인스턴스 정보 조회 실패 시 기본값 반환
          return {
            'worldName': _getSimpleLocationText(location),
            'instanceType': '',
            'totalUsers': 0,
          };
        }
      }
      // 캐시된 정보가 있으면 사용 (인스턴스가 아닌 경우)
      else if (_worldNameCache.containsKey(location)) {
        final cachedInfo = _worldNameCache[location]!;
        return {'worldName': cachedInfo, 'instanceType': '', 'totalUsers': 0};
      }
      // 새로 로드
      else {
        final displayText = await _worldService.getLocationDisplayText(
          location,
        );
        _worldNameCache[location] = displayText;

        return {'worldName': displayText, 'instanceType': '', 'totalUsers': 0};
      }
    } catch (e) {
      print('Error loading location info for "$location": $e');
      print('Stack trace: ${StackTrace.current}');
      return {
        'worldName': _getSimpleLocationText(location),
        'instanceType': '',
        'totalUsers': 0,
      };
    }
  }

  /// 간단한 위치 텍스트 변환
  String _getSimpleLocationText(String location) {
    if (location.isEmpty || location == 'offline') {
      return 'Offline';
    }
    if (location == 'private') {
      return 'Private';
    }

    // 월드 ID 형태라면 좀 더 읽기 쉽게 변환
    if (location.startsWith('wrld_')) {
      // 인스턴스 정보가 있는 경우 (wrld_xxx:12345~xxx)
      if (location.contains(':')) {
        final worldId = location.split(':')[0];
        return 'World ($worldId)';
      }
      // 월드 ID만 있는 경우
      return 'World ($location)';
    }

    return location;
  }
}
