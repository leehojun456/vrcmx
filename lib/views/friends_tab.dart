import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/friend.dart';
import '../services/auth_service.dart';
import 'package:get/get.dart';
import '../controllers/friends_controller.dart';
import '../widgets/vrchat_network_image.dart';

class FriendsTab extends StatefulWidget {
  final AuthService authService;

  const FriendsTab({super.key, required this.authService});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  final FriendsController c = Get.find<FriendsController>();

  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'Online'; // Online, Active, Ask Me, Offline
  final Map<String, String> _worldNameCache = {}; // worldId -> worldName 캐시

  // PageView 컨트롤러 추가
  late PageController _pageController;
  int _currentPageIndex = 0;

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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFriends);

    // PageController 초기화
    _pageController = PageController(initialPage: 0);
    _currentPageIndex = 0;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    setState(() {
      _errorMessage = '';
    });
    await c.refreshFriends();
  }

  void _filterFriends() {
    // 더 이상 필요 없음: Obx 내부에서 바로 필터링
  }

  bool _matchesSelectedStatus(Friend friend) {
    final status = friend.status;
    final location = friend.location;

    if (status == null) return _selectedStatus == 'Offline';

    // location이 wrld_로 시작하거나 private인지 확인 (실제 월드에 있는지)
    final isInWorld =
        location != null &&
        (location.startsWith('wrld_') || location == 'private');

    switch (_selectedStatus) {
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

  Widget _buildStatusFilterButtons() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: _statusOptions.map((status) {
          final isSelected = _selectedStatus == status['key'];
          return GestureDetector(
            onTap: () {
              _onStatusFilterTapped(status['key']!);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Text(
                status['label']!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusFilterAndSort() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 필터 버튼: 가로 스크롤
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusOptions.map((status) {
                  final isSelected = _selectedStatus == status['key'];
                  return GestureDetector(
                    onTap: () {
                      _onStatusFilterTapped(status['key']!);
                    },
                    child: Container(
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

  Widget _buildFriendCard(Friend friend, {bool showDivider = true}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: showDivider
            ? const Border(bottom: BorderSide(color: Colors.grey, width: 0.5))
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            VRChatCircleAvatar(
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

    // 월드 정보 API 호출 비활성화 - 원본 location 그대로 표시
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
  }

  // 상태 필터 버튼 클릭 시 페이지도 함께 변경
  void _onStatusFilterTapped(String statusKey) {
    final index = _statusOptions.indexWhere(
      (status) => status['key'] == statusKey,
    );
    if (index != -1) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 180), // 더 빠른 슬라이드
        curve: Curves.easeOutCubic, // 빠르고 부드러운 종료
      );
      // setState 제거: 버튼 상태는 onPageChanged에서만 변경
    }
  }

  // trust rank에 따라 닉네임 색상 반환 함수 (순서 상관없이 가장 높은 등급 적용)
  Color _getTrustColor(List<String>? tags) {
    if (tags == null || tags.isEmpty) return Colors.black;
    if (tags.contains('system_trust_veteran')) return Colors.purple;
    if (tags.contains('system_trust_trusted')) return Colors.orange;
    if (tags.contains('system_trust_known')) return Colors.green;
    if (tags.contains('system_trust_basic')) return Colors.blue;
    return Colors.black;
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
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blue),
            onPressed: _loadFriends,
            tooltip: '새로고침',
          ),
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
              onPageChanged: (index) {
                setState(() {
                  _selectedStatus = _statusOptions[index]['key']!;
                });
              },
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
                    }
                    // 추후 확장 가능
                    return 0;
                  });
                  if (filtered.isEmpty) {
                    return const Center(child: Text('친구가 없습니다.'));
                  }
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final friend = filtered[idx];
                      final showDivider = idx != filtered.length - 1;
                      return _buildFriendCard(friend, showDivider: showDivider);
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
