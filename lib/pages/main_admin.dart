import 'dart:math';
import 'package:flutter/material.dart';
// TODO: แก้ path ให้ตรงกับโปรเจกต์ของคุณ
import 'package:flutter_application_2/pages/login.dart';

class MainAdmin extends StatefulWidget {
  final int userIdx;
  const MainAdmin({super.key, required this.userIdx});

  @override
  State<MainAdmin> createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  final TextEditingController numberCtl = TextEditingController(text: '123454');

  int qty = 49;
  final int minQty = 1;
  final int maxQty = 99;

  // 8 ชุดเลขแสดงในกริด
  List<String> sets = List.generate(8, (_) => '123454');

  // แปลงเลข 6 หลักให้มีสเปซตรงกลางแบบ "123 456"
  String pretty(String six) {
    final s = six.padLeft(6, '0').substring(0, 6);
    return '${s.substring(0, 3)} ${s.substring(3)}';
  }

  // สุ่มเลข 6 หลัก
  String randomSix() => Random().nextInt(1000000).toString().padLeft(6, '0');

  void randomize() {
    setState(() {
      final base = numberCtl.text.trim();
      if (base.isNotEmpty && RegExp(r'^\d{1,6}$').hasMatch(base)) {
        sets = List.generate(8, (_) => base.padLeft(6, '0').substring(0, 6));
      } else {
        sets = List.generate(8, (_) => randomSix());
      }
    });
  }

  void resetAll() {
    setState(() {
      numberCtl.text = '123454';
      qty = 49;
      sets = List.generate(8, (_) => '123454');
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF9CE3F3), Color(0xFF7FD1EC), Color(0xFF6BC6EF)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const Text(
                        'LOTTERY',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // ออกจากระบบ -> ไปหน้า Login และล้าง stack
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                            (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text(
                      'ยินดีต้อนรับ Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Card กลาง
                  Center(
                    child: Container(
                      width: w < 420 ? w - 24 : 420,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'ลอตเตอรี่',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ช่องกรอกเลข
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'เพิ่มหมายเลขลอตเตอรี่',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: numberCtl,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: const Color(0xFFF3F6FA),
                              hintText: '123454',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE3E8EF),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // แถวไอคอน + ตัวเลข + ปุ่ม +/- + ปุ่มสุ่ม
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.casino_rounded,
                                  size: 42,
                                  color: Color(0xFF1769AA),
                                ),
                              ),

                              // ตัวเลข qty ตรงกลาง
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$qty',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    Container(
                                      height: 2,
                                      width: 70,
                                      color: const Color(0xFFB0BEC5),
                                    ),
                                  ],
                                ),
                              ),

                              // ปุ่ม + -
                              Row(
                                children: [
                                  _RoundIconButton(
                                    icon: Icons.add,
                                    onTap: () {
                                      setState(() {
                                        if (qty < maxQty) qty++;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  _RoundIconButton(
                                    icon: Icons.remove,
                                    onTap: () {
                                      setState(() {
                                        if (qty > minQty) qty--;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ปุ่มสุ่มเลข
                          SizedBox(
                            width: 120,
                            height: 38,
                            child: ElevatedButton(
                              onPressed: randomize,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8FB5E4),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'สุ่มเลข',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Grid ชุดเลข 8 ชุด (2 คอลัมน์)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 3.8,
                                ),
                            itemCount: sets.length,
                            itemBuilder: (_, i) {
                              return _NumberTile(
                                index: i + 1,
                                number: pretty(sets[i]),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ปุ่มด้านล่าง 2 ปุ่ม
                  Center(
                    child: Column(
                      children: [
                        _BigActionButton(
                          label: 'ออกรางวัล',
                          onPressed: () {
                            // TODO: ใส่ลอจิกออกรางวัล
                          },
                        ),
                        const SizedBox(height: 12),
                        _BigActionButton(
                          label: 'รีเซ็ต',
                          onPressed: resetAll,
                          alt: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Widgets ย่อย ----------------

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFC107),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }
}

class _NumberTile extends StatelessWidget {
  final int index;
  final String number;
  const _NumberTile({required this.index, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFE3E8EF)),
      ),
      child: Row(
        children: [
          Text(
            'ชุดที่ $index',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF7B8794),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            number,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BigActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool alt; // ปุ่มล่าง (โทนจางกว่า)
  const _BigActionButton({
    required this.label,
    required this.onPressed,
    this.alt = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: alt
                ? const Color(0xFFEAB308)
                : const Color(0xFFF59E0B),
            foregroundColor: const Color(0xFF1F2937),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
