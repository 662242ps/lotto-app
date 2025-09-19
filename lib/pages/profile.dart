import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/pages/login.dart';
import 'package:flutter_application_2/widgets/app_footer.dart';
import 'package:flutter_application_2/config/config.dart';

// ---------- Model (ตามที่ให้มา) ----------
PorfileResponse porfileResponseFromJson(String str) =>
    PorfileResponse.fromJson(json.decode(str));

String porfileResponseToJson(PorfileResponse data) =>
    json.encode(data.toJson());

class PorfileResponse {
  String name;
  DateTime birthday;
  String email;
  String phone;

  PorfileResponse({
    required this.name,
    required this.birthday,
    required this.email,
    required this.phone,
  });

  factory PorfileResponse.fromJson(Map<String, dynamic> json) =>
      PorfileResponse(
        name: json["name"],
        birthday: DateTime.parse(json["birthday"]),
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "birthday": birthday.toIso8601String(),
    "email": email,
    "phone": phone,
  };
}

// ========== Profile Page ==========
class Profile extends StatefulWidget {
  final int userIdx;
  const Profile({super.key, required this.userIdx});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? apiUrl;
  PorfileResponse? data;
  bool loading = true;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    final cfg = await Configuration.getConfig();
    apiUrl = cfg['apiEndpoint'];
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (apiUrl == null || apiUrl!.isEmpty) {
      setState(() {
        loading = false;
        errorText = 'API URL ไม่ถูกต้อง';
      });
      return;
    }

    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      // TODO: ปรับ path ให้ตรงกับ backend ของคุณ
      // เช่น /users/{id} หรือ /users/{id}/profile
      final res = await http.get(Uri.parse('$apiUrl/users/${widget.userIdx}'));

      if (res.statusCode == 200) {
        final parsed = porfileResponseFromJson(res.body);
        setState(() {
          data = parsed;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          errorText = 'โหลดข้อมูลไม่สำเร็จ (${res.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorText = 'เกิดข้อผิดพลาด: $e';
      });
    }
  }

  String _formatDate(DateTime d) {
    // yyyy-MM-dd
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header
      appBar: AppBar(
        backgroundColor: const Color(0xFF98DBEB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'โปรไฟล์',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorText != null
          ? _ErrorView(message: errorText!, onRetry: _loadProfile)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: const Color(0xFFE6E6E6),
                      child: Icon(
                        Icons.account_circle_rounded,
                        size: 96,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ข้อมูลจากโมเดล
                    _ProfileRow(
                      label: 'ชื่อ - นามสกุล',
                      value: data?.name ?? '-',
                    ),
                    const SizedBox(height: 20),
                    _ProfileRow(
                      label: 'วัน / เดือนปี / เกิด',
                      value: data == null ? '-' : _formatDate(data!.birthday),
                    ),
                    const SizedBox(height: 20),
                    _ProfileRow(label: 'อีเมล', value: data?.email ?? '-'),
                    const SizedBox(height: 20),
                    _ProfileRow(
                      label: 'เบอร์โทรศัพท์',
                      value: data?.phone ?? '-',
                    ),

                    const SizedBox(height: 60),

                    // Logout button (ยังไม่ผูก)
                    SizedBox(
                      width: 240,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                            (route) => false, // ล้าง history ออกหมด
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C9EE4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'ออกจากระบบ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

      backgroundColor: Colors.white,

      // Footer: ส่ง userIdx ให้ด้วย
      bottomNavigationBar: AppFooter(activeIndex: 4, userIdx: widget.userIdx),
    );
  }
}

/// แถว label ซ้าย (เทา) + value ขวา (ดำตัวหนา)
class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB0B0B0),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

/// หน้าข้อผิดพลาดพร้อมปุ่มลองใหม่
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ).copyWith(top: 48, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }
}
