import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/friend.dart';
import '../services/auth_service.dart';
import '../widgets/vrchat_network_image.dart';

class FriendsTab extends StatefulWidget {
  final AuthService authService;

  const FriendsTab({super.key, required this.authService});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  List<Friend> _friends = [];
  List<Friend> _filteredFriends = [];
  bool _isLoading = true;
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

  @override
  void initState() {
    super.initState();
    _loadFriends();
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
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 온라인과 오프라인 친구 모두 가져오기
      final onlineResponse = await widget.authService.getAllFriends(
        includeOffline: false,
      );
      final offlineResponse = await widget.authService.getAllFriends(
        includeOffline: true,
      );

      if (onlineResponse.success && offlineResponse.success) {
        // 중복 제거를 위한 Map 사용
        final allFriendsMap = <String, Friend>{};

        // 온라인 친구들 추가
        for (final friend in onlineResponse.friends) {
          allFriendsMap[friend.id] = friend;
        }

        // 오프라인 친구들 추가 (온라인 친구와 중복되지 않은 것만)
        for (final friend in offlineResponse.friends) {
          allFriendsMap[friend.id] = friend;
        }

        setState(() {
          _friends = allFriendsMap.values.toList();
          _isLoading = false;
        });
        _filterFriends();
      } else {
        setState(() {
          _errorMessage =
              onlineResponse.message ??
              offlineResponse.message ??
              '친구목록을 가져올 수 없습니다';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _filterFriends() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFriends = _friends.where((friend) {
        final matchesSearch =
            query.isEmpty ||
            friend.displayName.toLowerCase().contains(query) ||
            (friend.id.toLowerCase().contains(query));

        final matchesStatusFilter = _matchesSelectedStatus(friend);

        return matchesSearch && matchesStatusFilter;
      }).toList();

      // 상태별 정렬 (온라인 상태가 먼저, 그 다음 이름순)
      _filteredFriends.sort((a, b) {
        final aOnline = a.status != 'offline';
        final bOnline = b.status != 'offline';

        if (aOnline && !bOnline) return -1;
        if (!aOnline && bOnline) return 1;
        return a.displayName.compareTo(b.displayName);
      });
    });
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

  Widget _buildFriendCard(Friend friend) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _getLocationText(friend),
          style: const TextStyle(color: Colors.black54, fontSize: 12),
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

  // 월드 이름을 비동기로 가져와서 캐시에 저장 - 비활성화
  Future<void> _fetchWorldName(String worldId) async {
    // 월드 정보 API 호출 비활성화
    // if (_worldNameCache.containsKey(worldId)) return;

    // try {
    //   final worldName = await widget.authService.getWorldName(worldId);
    //   if (worldName != null && mounted) {
    //     setState(() {
    //       _worldNameCache[worldId] = worldName;
    //     });
    //   }
    // } catch (e) {
    //   print('월드 이름 가져오기 실패: $e');
    // }
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFilterCount = _filteredFriends.length;
    final totalCount = _friends.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '친구 ($currentFilterCount/$totalCount) - $_selectedStatus',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
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
          // 로딩 중일 때는 스피너 표시, 아닐 때는 새로고침 버튼
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  onPressed: _loadFriends,
                ),
        ],
      ),
      body: Column(
        children: [
          // 검색 및 필터
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search friends...',
                    hintStyle: const TextStyle(color: Colors.black54),
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatusFilterButtons(),
              ],
            ),
          ),
          // 친구목록 - PageView로 감싸서 스와이프 가능하게 수정
          Expanded(
            child: _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          size: 64,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadFriends,
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _statusOptions.length,
                    itemBuilder: (context, index) {
                      // 각 페이지에서 해당 상태의 친구들만 표시
                      final statusKey = _statusOptions[index]['key']!;
                      final filteredFriends = _friends.where((friend) {
                        final matchesSearch =
                            _searchController.text.isEmpty ||
                            friend.displayName.toLowerCase().contains(
                              _searchController.text.toLowerCase(),
                            ) ||
                            friend.id.toLowerCase().contains(
                              _searchController.text.toLowerCase(),
                            );

                        final matchesStatus = _matchesStatusForKey(
                          friend,
                          statusKey,
                        );

                        return matchesSearch && matchesStatus;
                      }).toList();

                      // 정렬
                      filteredFriends.sort((a, b) {
                        final aOnline = a.status != 'offline';
                        final bOnline = b.status != 'offline';

                        if (aOnline && !bOnline) return -1;
                        if (!aOnline && bOnline) return 1;
                        return a.displayName.compareTo(b.displayName);
                      });

                      return filteredFriends.isEmpty && !_isLoading
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.people_outline,
                                    size: 64,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchController.text.isNotEmpty
                                        ? 'No friends found matching "${_searchController.text}"'
                                        : _friends.isEmpty
                                        ? '친구가 없습니다'
                                        : 'No ${statusKey.toLowerCase()} friends found',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadFriends,
                              child: ListView.builder(
                                itemCount: filteredFriends.length,
                                itemBuilder: (context, friendIndex) {
                                  return _buildFriendCard(
                                    filteredFriends[friendIndex],
                                  );
                                },
                              ),
                            );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
