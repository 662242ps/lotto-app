import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_2/widgets/app_footer.dart';
import '../config/config.dart'; // Configuration.getConfig()
import '../model/response/Lotto_response.dart'; // lottoResponseFromJson, LottoResponse

class MainUser extends StatefulWidget {
  final int userIdx;
  const MainUser({super.key, required this.userIdx});

  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  final TextEditingController searchCtl = TextEditingController();
  double wallet = 999.0;

  Future<List<LottoResponse>>? _future;
  List<LottoResponse> _all = [];
  List<LottoResponse> _filtered = [];

  String pretty(String six) {
    final s = six.padLeft(6, '0').substring(0, 6);
    return '${s.substring(0, 3)} ${s.substring(3)}';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final config = await Configuration.getConfig();
    final base = config['apiEndpoint']; // เช่น http://10.160.49.197:3000
    final url = '$base/lotto';

    setState(() {
      _future = http.get(Uri.parse(url)).then((res) {
        if (res.statusCode != 200) {
          throw Exception('โหลดรายการ lotto ไม่สำเร็จ (${res.statusCode})');
        }
        final list = lottoResponseFromJson(res.body);
        _all = list;
        _filtered = list;
        return list;
      });
    });
  }

  void _filter() {
    final q = searchCtl.text.trim();
    if (q.isEmpty) {
      setState(() => _filtered = _all);
      return;
    }
    setState(() {
      _filtered = _all.where((e) => e.number.contains(q)).toList();
    });
  }

  // ---------- Dialog ยืนยันซื้อ โชว์เลขที่กด ----------
  void _showConfirm(String shownNumber) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF9BE2EA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'คำเตือน',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'คุณตกลงที่จะซื้อหรือไม่',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F5F7),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    shownNumber, // เช่น "123 555"
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5A623),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'ไม่',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF51B05A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'ใช่',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result == true) {
      // TODO: เรียก API ซื้อ/เพิ่มเข้าตะกร้าตามต้องการ
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ยืนยันซื้อเลข $shownNumber (ตัวอย่าง)')),
      );
    }
  }
  // -----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // พื้นหลัง
            SizedBox.expand(
              child: Image.asset(
                'assets/images/bg (2).png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            // โทนฟ้าทับด้านบน
            Container(
              height: 320,
              decoration: const BoxDecoration(color: Color(0xAA55D6DD)),
            ),

            // เนื้อหา
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // แถวหัว: LOTTERY + กระเป๋าเงิน
                    Row(
                      children: [
                        const Text(
                          'LOTTERY',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.3,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.orange,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              _WalletText(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'ยินดีต้อนรับ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // การ์ดกลาง
                    Center(
                      child: Container(
                        width: w.clamp(0, 420),
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
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
                          children: [
                            const Text(
                              'ลอตเตอรี่',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF222222),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // กล่องด้านใน
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7FAFC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // แถวค้นหา + รีเฟรช
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: searchCtl,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          onChanged: (_) => _filter(),
                                          decoration: InputDecoration(
                                            hintText: 'พิมพ์เลขเพื่อค้นหา',
                                            filled: true,
                                            fillColor: const Color(0xFFF0F2F7),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 10,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E6ED),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        height: 42,
                                        child: ElevatedButton(
                                          onPressed: _load,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF7C9EE4,
                                            ),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            'รีเฟรช',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // โหลดและแสดงรายการจาก API
                                  FutureBuilder<List<LottoResponse>>(
                                    future: _future,
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 24,
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      if (snap.hasError) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                'โหลดข้อมูลไม่สำเร็จ: ${snap.error}',
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              OutlinedButton(
                                                onPressed: _load,
                                                child: const Text('ลองใหม่'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      final items = _filtered;
                                      if (items.isEmpty) {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 24,
                                          ),
                                          child: Text(
                                            'ไม่พบรายการ',
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        );
                                      }

                                      return GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 12,
                                              crossAxisSpacing: 12,
                                              mainAxisExtent: 92,
                                            ),
                                        itemCount: items.length,
                                        itemBuilder: (_, i) {
                                          final item = items[i];
                                          return _TicketCard(
                                            number: pretty(item.number),
                                            price: item
                                                .price, // ในโมเดลเป็น String
                                            status: item.status,
                                            onTap: () => _showConfirm(
                                              pretty(item.number),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppFooter(userIdx: widget.userIdx, activeIndex: 0),
    );
  }
}

// แสดงยอดเงิน
class _WalletText extends StatelessWidget {
  const _WalletText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '999.00',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Color(0xFF263238),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final String number;
  final String price; // ให้ตรงกับโมเดล
  final String status;
  final VoidCallback? onTap;

  const _TicketCard({
    required this.number,
    required this.price,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = status.toLowerCase() == 'available';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap, // กดที่กล่องเลข
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF8AD0EC), width: 1.4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                number,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              '$price บาท',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isAvailable
                    ? const Color(0xFFE6F8F0)
                    : const Color(0xFFFFEFEF),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                isAvailable ? 'ว่าง' : status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isAvailable
                      ? const Color(0xFF0B8F55)
                      : const Color(0xFFD93D3D),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
