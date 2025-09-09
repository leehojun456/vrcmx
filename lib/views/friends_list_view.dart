import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../services/auth_service.dart';

class FriendsListView extends StatefulWidget {
  final AuthService authService;
  
  const FriendsListView({
    super.key,
    required this.authService,
  });

  @override
  State<FriendsListView> createState() => _FriendsListViewState();
}

class _FriendsListViewState extends State<FriendsListView> {
  List<Friend> _friends = [];
  List<Friend> _filteredFriends = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  bool _showOnlineOnly = false;

  @override
  void initState() {
    super.initState();
    _loadFriends();
    _searchController.addListener(_filterFriends);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await widget.authService.getFriends();
      
      if (response.success) {
        setState(() {
          _friends = response.friends;
          _filteredFriends = response.friends;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? '친구목록을 가져올 수 없습니다';
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
        final matchesSearch = query.isEmpty ||
            friend.displayName.toLowerCase().contains(query) ||
            friend.username.toLowerCase().contains(query);
        
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
            CircleAvatar(
              radius: 25,
              backgroundImage: friend.currentAvatarImageUrl != null
                  ? NetworkImage(friend.currentAvatarImageUrl!)
                  : null,
              child: friend.currentAvatarImageUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            // 온라인 상태 표시
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getStatusColor(friend.status, friend.isOnline),
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
              '@${friend.username}',
              style: TextStyle(color: Colors.grey[600]),
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
            if (friend.platform != null)
              Icon(
                _getPlatformIcon(friend.platform!),
                size: 16,
                color: Colors.grey[600],
              ),
            const SizedBox(height: 4),
            Text(
              _getStatusText(friend.status),
              style: TextStyle(
                fontSize: 10,
                color: _getStatusColor(friend.status, friend.isOnline),
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

  Color _getStatusColor(String? status, bool isOnline) {
    if (!isOnline) return Colors.grey;
    
    switch (status?.toLowerCase()) {
      case 'online':
        return Colors.green;
      case 'busy':
        return Colors.orange;
      case 'ask me':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'online':
        return 'Online';
      case 'busy':
        return 'Busy';
      case 'ask me':
        return 'Ask Me';
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
    if (!friend.isOnline) return 'Offline';
    if (friend.location == 'private') return 'Private World';
    if (friend.location?.startsWith('wrld_') == true) return 'In VRChat';
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
                        '@${friend.username}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
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
                _buildDetailRow('Status', _getStatusText(friend.status)),
                if (friend.statusDescription != null && friend.statusDescription!.isNotEmpty)
                  _buildDetailRow('Status Message', friend.statusDescription!),
                _buildDetailRow('Location', _getLocationText(friend)),
                if (friend.platform != null)
                  _buildDetailRow('Platform', friend.platform!),
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[700]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadFriends,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    final onlineCount = _friends.where((f) => f.isOnline).length;
    final totalCount = _friends.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Friends ($onlineCount/$totalCount)'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFriends,
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
                        _filterFriends();
                      },
                    ),
                    const Text('Show online only'),
                  ],
                ),
              ],
            ),
          ),
          // 친구목록
          Expanded(
            child: _filteredFriends.isEmpty
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
                    onRefresh: _loadFriends,
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