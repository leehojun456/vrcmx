import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/friend.dart';
import '../services/auth_service.dart';
import '../widgets/vrchat_network_image.dart';
import '../providers/websocket_provider.dart';

class FriendsListView extends ConsumerStatefulWidget {
  final AuthService authService;
  
  const FriendsListView({
    super.key,
    required this.authService,
  });

  @override
  ConsumerState<FriendsListView> createState() => _FriendsListViewState();
}

class _FriendsListViewState extends ConsumerState<FriendsListView> {
  List<Friend> _filteredFriends = [];
  final TextEditingController _searchController = TextEditingController();
  bool _showOnlineOnly = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final friends = ref.read(realtimeFriendsProvider);
      _filterFriends(friends);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _filterFriends(List<Friend> friends) {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFriends = friends.where((friend) {
        final matchesSearch = query.isEmpty ||
            friend.displayName.toLowerCase().contains(query) ||
            (friend.id.toLowerCase().contains(query));
        
        final matchesOnlineFilter = !_showOnlineOnly || friend.isOnline;
        
        return matchesSearch && matchesOnlineFilter;
      }).toList();

      // 온라인 친구를 맨 위로 정렬
      _filteredFriends.sort((a, b) {
        if (a.isOnline && !b.isOnline) return -1;
        if (!a.isOnline && b.isOnline) return 1;
        return a.displayName.compareTo(b.displayName);
      });
    });
  }

  Widget _buildFriendCard(Friend friend) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              friend.id,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            if (friend.statusDescription != null && friend.statusDescription!.isNotEmpty)
              Text(
                friend.statusDescription!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              _getLocationText(friend),
              style: TextStyle(
                color: friend.isOnline ? Colors.green[700] : Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (friend.lastPlatform != null)
              Icon(
                _getPlatformIcon(friend.lastPlatform!),
                size: 16,
                color: Colors.grey[600],
              ),
            const SizedBox(height: 4),
            Text(
              _getStatusText(friend.status, friend.location),
              style: TextStyle(
                fontSize: 10,
                color: _getStatusColor(friend.status, friend.location),
                fontWeight: FontWeight.bold,
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
    switch (status?.toLowerCase()) {
      case 'online':
      case 'join me':
        // online/join me는 location이 있어야 함
        if (location == 'offline' || location == null) return Colors.grey;
        return Colors.green;
      case 'active':
        // active는 location이 없어도 됨 (VRChat 밖에서도 온라인)
        return Colors.yellow[700]!;
      case 'ask me':
        // ask me는 location이 있어야 함
        if (location == 'offline' || location == null) return Colors.grey;
        return Colors.orange;
      case 'busy':
        // busy는 location이 있어야 함
        if (location == 'offline' || location == null) return Colors.grey;
        return Colors.red;
      case 'offline':
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status, String? location) {
    switch (status?.toLowerCase()) {
      case 'online':
      case 'join me':
        // online/join me는 location이 있어야 함
        if (location == 'offline' || location == null) return 'Offline';
        return 'Online';
      case 'active':
        // active는 location이 없어도 됨 (VRChat 밖에서도 온라인)
        return 'Active';
      case 'ask me':
        // ask me는 location이 있어야 함
        if (location == 'offline' || location == null) return 'Offline';
        return 'Ask Me';
      case 'busy':
        // busy는 location이 있어야 함
        if (location == 'offline' || location == null) return 'Offline';
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
    // active 상태는 location이 없어도 "Active"로 표시
    if (friend.status?.toLowerCase() == 'active') {
      if (friend.location == null || friend.location == 'offline') return 'Active';
    }
    
    if (friend.location == 'offline' || friend.location == null) return 'Offline';
    if (friend.location == 'private') return 'Private World';
    if (friend.worldId != null) return friend.worldId!;
    return friend.location ?? 'Online';
  }

  void _showFriendDetails(Friend friend) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: friend.currentAvatarImageUrl != null
                        ? NetworkImage(friend.currentAvatarImageUrl!)
                        : null,
                    child: friend.currentAvatarImageUrl == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Text(
                        friend.displayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                if (friend.bio != null && friend.bio!.isNotEmpty) ...[
                  const Text(
                    'Bio',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(friend.bio!),
                  const SizedBox(height: 16),
                ],
                const Text(
                  'Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Status', _getStatusText(friend.status, friend.location)),
                if (friend.statusDescription != null && friend.statusDescription!.isNotEmpty)
                  _buildDetailRow('Status Message', friend.statusDescription!),
                _buildDetailRow('Location', _getLocationText(friend)),
                if (friend.lastPlatform != null)
                  _buildDetailRow('Platform', friend.lastPlatform!),
                if (friend.lastLogin != null)
                  _buildDetailRow('Last Login', _formatDateTime(friend.lastLogin!)),
                _buildDetailRow('User ID', friend.id),
                const SizedBox(height: 32),
              ],
            ),
          ),
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
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final friends = ref.watch(realtimeFriendsProvider);
    final isConnected = ref.watch(webSocketConnectionProvider);
    
    // 친구 목록이 업데이트될 때마다 필터링
    if (friends.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _filterFriends(friends);
      });
    }

    final onlineCount = friends.where((f) => f.isOnline).length;
    final totalCount = friends.length;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Friends ($onlineCount/$totalCount)'),
            const SizedBox(width: 8),
            // 웹소켓 연결 상태 표시
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              size: 20,
              color: isConnected ? Colors.green : Colors.red,
            ),
          ],
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final friendsNotifier = ref.read(realtimeFriendsProvider.notifier);
              await friendsNotifier.refresh();
            },
          ),
          // 웹소켓 연결/해제 버튼
          IconButton(
            icon: Icon(isConnected ? Icons.pause : Icons.play_arrow),
            onPressed: () async {
              final connectionNotifier = ref.read(webSocketConnectionProvider.notifier);
              if (isConnected) {
                await connectionNotifier.disconnect();
              } else {
                await connectionNotifier.connect();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 및 필터
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search friends...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _showOnlineOnly,
                      onChanged: (value) {
                        setState(() {
                          _showOnlineOnly = value ?? false;
                        });
                        _filterFriends(friends);
                      },
                    ),
                    const Text('Show online only'),
                    const Spacer(),
                    // 실시간 업데이트 상태 표시
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isConnected ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isConnected ? Colors.green : Colors.red,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isConnected ? Icons.circle : Icons.circle_outlined,
                            size: 8,
                            color: isConnected ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isConnected ? 'Live' : 'Offline',
                            style: TextStyle(
                              fontSize: 12,
                              color: isConnected ? Colors.green[700] : Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 친구목록
          Expanded(
            child: friends.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading friends...'),
                      ],
                    ),
                  )
                : _filteredFriends.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'No friends found matching "${_searchController.text}"'
                                  : 'No friends found',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          final friendsNotifier = ref.read(realtimeFriendsProvider.notifier);
                          await friendsNotifier.refresh();
                        },
                        child: ListView.builder(
                          itemCount: _filteredFriends.length,
                          itemBuilder: (context, index) {
                            return _buildFriendCard(_filteredFriends[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}