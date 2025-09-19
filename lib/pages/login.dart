import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/model/request/Login_Request.dart';
import 'package:flutter_application_2/model/response/Login_Response.dart';
import 'package:flutter_application_2/pages/main_admin.dart';
import 'package:flutter_application_2/pages/main_user.dart';
import 'package:flutter_application_2/pages/register.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String url = '';
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  TextEditingController emailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg (2).png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // โลโก้ข้อความ LOTTERY
                      const Padding(
                        padding: EdgeInsets.only(left: 6.0, bottom: 24),
                        child: Text(
                          'LOTTERY',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      // วงกลม Avatar + ป้ายกุญแจ
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/4661334 1.png',
                          width: w * 0.6, // ปรับขนาดตามต้องการ
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // หัวข้อ เข้าสู่ระบบ
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ฟิลด์: อีเมล
                      const Text(
                        'อีเมล',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _ShadowField(
                        child: TextField(
                          controller: emailCtl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _roundedInput('อีเมล'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'รหัสผ่าน',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _ShadowField(
                        child: TextField(
                          controller: passwordCtl,
                          obscureText: true,
                          decoration: _roundedInput('รหัสผ่าน'),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ลิงก์ สมัครสมาชิก / ลืมรหัสผ่าน
                      // import หน้า Register ให้เรียบร้อย
                      // import 'package:your_app/pages/register.dart';
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _LinkButton(
                            icon: Icons.person_add_alt_1,
                            label: 'สมัครสมาชิก',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const Register(),
                                ),
                              );
                            },
                          ),
                          _LinkButton(
                            icon: Icons.help_outline,
                            label: 'ลืมรหัสผ่าน',
                            onPressed: () {
                              // ไปหน้าอื่น/โชว์ dialog ก็ได้
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ปุ่ม ลงชื่อเข้าใช้
                      Center(
                        child: _ShadowButton(
                          child: SizedBox(
                            width: 220,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFEB3B),
                                foregroundColor: const Color(0xFF0D47A1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'ลงชื่อเข้าใช้',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      // 1) เตรียม JSON request
      final req = LoginRequest(
        email: emailCtl.text,
        password: passwordCtl.text,
      );

      // 2) ยิง HTTP POST ไปยัง API
      final res = await http.post(
        Uri.parse("$url/users/login"), // ตรวจให้แน่ใจว่า url มีค่าแล้ว
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: loginRequestToJson(req), // แปลง object -> JSON string
      );

      final loginRes = loginResponseFromJson(res.body);

      final userIdx =
          loginRes.user.userId; // <-- ถ้าชื่อฟิลด์เป็น id ให้เปลี่ยนเป็น .id
      final role = loginRes.user.role;

      // ไปหน้า Showtrip พร้อมส่ง idx
      if (!mounted) return;
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainAdmin(userIdx: userIdx),
          ), // ← เปลี่ยนเป็นหน้าจริงของคุณ
        );
      } else if (role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainUser(userIdx: userIdx),
          ), // ← หน้าผู้ใช้ทั่วไป
        );
      } else {
        // role ไม่ตรงที่รองรับ
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('สิทธิ์ผู้ใช้ไม่ถูกต้อง')));
      }
    } catch (e) {
      if (!mounted) return;
      await showErrorPopup(
        context,
        'ไม่พบบัญชีผู้ใช้',
      ); // หรือ 'ล็อกอินไม่สำเร็จ'
    }
  }
}

// =================== Widgets/Helpers ภายในไฟล์ ===================

class _ShadowField extends StatelessWidget {
  final Widget child;
  const _ShadowField({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ShadowButton extends StatelessWidget {
  final Widget child;
  const _ShadowButton({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed; // ต้องรับ callback จากภายนอก

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed, // ส่งต่อให้ TextButton
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

// ฟังก์ชันสร้าง InputDecoration ทรงโค้ง
InputDecoration _roundedInput(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide.none,
    ),
  );
}

Future<void> showErrorPopup(BuildContext context, String message) {
  return showDialog(
    context: context,
    barrierDismissible: false, // ต้องกดปุ่มเท่านั้นถึงปิด
    builder: (_) {
      return Dialog(
        backgroundColor: const Color(0xFF75D0D2), // ฟ้า
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF49A83E), // เขียว
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
