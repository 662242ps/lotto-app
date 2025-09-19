import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// โมเดล Request ของคุณ
import 'package:flutter_application_2/model/request/Register_Request.dart';
// ไฟล์ config ของโปรเจกต์ (ต้องคืนค่า {"apiEndpoint": "..."} )
import 'package:flutter_application_2/config/config.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Controllers
  TextEditingController nameCtl = TextEditingController();
  TextEditingController birthCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  // คำนำหน้า (ถ้าต้องใช้ก็เปิดคอมเมนต์ส่วน radio ด้านล่าง)
  String? title;

  String? apiUrl; // base API endpoint จาก config
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // โหลดค่า config
    Configuration.getConfig().then((cfg) {
      setState(() => apiUrl = cfg['apiEndpoint']); // เช่น http://10.0.2.2:3000
    });
  }

  @override
  void dispose() {
    nameCtl.dispose();
    birthCtl.dispose();
    emailCtl.dispose();
    phoneCtl.dispose();
    passwordCtl.dispose();
    super.dispose();
  }

  // ================= REGISTER =================
  Future<void> register() async {
    if (apiUrl == null || apiUrl!.isEmpty) {
      _showAlert('ยังไม่ได้ตั้งค่า API URL');
      return;
    }

    // validate เบื้องต้น
    if (emailCtl.text.trim().isEmpty ||
        passwordCtl.text.isEmpty ||
        nameCtl.text.trim().isEmpty ||
        phoneCtl.text.trim().isEmpty ||
        birthCtl.text.trim().isEmpty) {
      _showAlert('กรุณากรอกข้อมูลให้ครบ');
      return;
    }

    DateTime? birth;
    try {
      birth = DateTime.parse(birthCtl.text.trim()); // รูปแบบ yyyy-MM-dd
    } catch (_) {
      _showAlert('รูปแบบวันเกิดไม่ถูกต้อง (yyyy-MM-dd)');
      return;
    }

    setState(() => loading = true);
    try {
      final req = RegisterRequest(
        email: emailCtl.text.trim(),
        password: passwordCtl.text.trim(),
        name: nameCtl.text.trim(),
        role: "user", // ปรับได้ตามต้องการ
        phone: phoneCtl.text.trim(),
        birthday: birth,
        wallet: 0,
      );

      final res = await http.post(
        Uri.parse("$apiUrl/register"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: registerRequestToJson(req),
      );

      log("Status: ${res.statusCode}");
      log("Body  : ${res.body}");

      if (!mounted) return;

      if (res.statusCode == 200 || res.statusCode == 201) {
        await _showAlert('สมัครสมาชิกเรียบร้อย', success: true);
        Navigator.pop(context); // กลับไปหน้าก่อนหน้า
      } else {
        await _showAlert('สมัครไม่สำเร็จ: ${res.body}');
      }
    } catch (e, st) {
      log('Error: $e');
      log('Stack: $st');
      if (!mounted) return;
      await _showAlert('เกิดข้อผิดพลาด: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _showAlert(String message, {bool success = false}) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? 'สำเร็จ' : 'แจ้งเตือน'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header สีฟ้า + back + ไอคอน
      appBar: AppBar(
        backgroundColor: const Color(0xFF98DBEB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'สมัครสมาชิก',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.app_registration_rounded, color: Colors.white),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- ถ้าต้องใช้คำนำหน้า เปิดส่วนนี้ ---
              // Row(
              //   children: [
              //     _label('คำนำหน้า', requiredMark: true),
              //     const SizedBox(width: 8),
              //     Expanded(
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           _RadioChip<String>(
              //             value: 'นาย',
              //             groupValue: title,
              //             label: 'นาย',
              //             onChanged: (v) => setState(() => title = v),
              //           ),
              //           _RadioChip<String>(
              //             value: 'นาง',
              //             groupValue: title,
              //             label: 'นาง',
              //             onChanged: (v) => setState(() => title = v),
              //           ),
              //           _RadioChip<String>(
              //             value: 'นางสาว',
              //             groupValue: title,
              //             label: 'นางสาว',
              //             onChanged: (v) => setState(() => title = v),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 18),

              _label('ชื่อ - นามสกุล'),
              const SizedBox(height: 8),
              TextField(controller: nameCtl, decoration: _input('')),
              const SizedBox(height: 18),

              _label('วันเกิด'),
              const SizedBox(height: 8),
              TextField(
                controller: birthCtl,
                readOnly: true,
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(now.year - 18, now.month, now.day),
                    firstDate: DateTime(1900),
                    lastDate: now,
                    helpText: 'เลือกวันเกิด',
                  );
                  if (picked != null) {
                    birthCtl.text =
                        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
                decoration: _input(''),
              ),
              const SizedBox(height: 18),

              _label('อีเมล', requiredMark: true),
              const SizedBox(height: 8),
              TextField(
                controller: emailCtl,
                keyboardType: TextInputType.emailAddress,
                decoration: _input(''),
              ),
              const SizedBox(height: 18),

              _label('เบอร์โทรศัพท์ (มือถือ)', requiredMark: true),
              const SizedBox(height: 8),
              TextField(
                controller: phoneCtl,
                keyboardType: TextInputType.phone,
                decoration: _input(''),
              ),
              const SizedBox(height: 18),

              _label('รหัสผ่าน', requiredMark: true),
              const SizedBox(height: 8),
              TextField(
                controller: passwordCtl,
                obscureText: true,
                decoration: _input(''),
              ),

              const SizedBox(height: 36),

              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 230,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: loading ? null : register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFFF00),
                        foregroundColor: const Color(0xFF333333),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        loading ? 'กำลังสมัคร...' : 'สมัครสมาชิก',
                        style: const TextStyle(fontWeight: FontWeight.w700),
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
      backgroundColor: Colors.white,
    );
  }

  // ================ helpers ================
  Widget _label(String text, {bool requiredMark = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (requiredMark)
          const Text(
            ' *',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8F9FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF93C5FD)),
      ),
    );
  }
}

// ปุ่มตัวเลือกแบบ radio เรียบ ๆ (ถ้าต้องใช้คำนำหน้า)
class _RadioChip<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String label;
  final ValueChanged<T?> onChanged;

  const _RadioChip({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          visualDensity: VisualDensity.compact,
        ),
        Text(label, style: const TextStyle(color: Colors.black87)),
        const SizedBox(width: 8),
      ],
    );
  }
}
