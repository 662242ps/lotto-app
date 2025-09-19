import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/app_footer.dart';
import 'package:flutter_application_2/pages/top_up_page.dart';
import 'package:flutter_application_2/pages/withdraw_page.dart';

class WalletPage extends StatefulWidget {
  final int userIdx;
  const WalletPage({super.key, required this.userIdx});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  // สมมติเป็นค่าจากเซิร์ฟเวอร์
  double balance = 9999999;
  double creditLimit = 200000000;

  String _fmt(num n) {
    final s = n.toStringAsFixed(0);
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  }

  void _onTopup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TopUpPage(
          userIdx: widget.userIdx,
          balance: balance, // ส่งยอดปัจจุบันไปโชว์/ใช้ตรวจ
        ),
      ),
    );
  }

  void _onWithdraw() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WithdrawPage(userIdx: widget.userIdx, balance: balance),
      ),
    );
  }

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
                'assets/images/bg (2).png', // ใช้ภาพเดียวกับหน้าหลัก
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            // โทนฟ้าทับด้านบน
            Container(height: 320, color: const Color(0xAA55D6DD)),

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
                    // แถวหัว: LOTTERY + badge ยอดย่อ
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
                          child: Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '999',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF263238),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // การ์ดวอลเล็ต
                    Center(
                      child: Container(
                        width: w.clamp(0, 420),
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
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
                            // ไอคอนใหญ่ด้านบน
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF7FF),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.payments_rounded,
                                size: 44,
                                color: Color(0xFF3AA7C3),
                              ),
                            ),
                            const SizedBox(height: 14),

                            const Text(
                              'วอลเล็ต',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF222222),
                              ),
                            ),
                            const SizedBox(height: 6),

                            const Text(
                              'ยอดเงินคงเหลือ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7A7F87),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // ตัวเลขใหญ่ + บาท
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _fmt(balance),
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    'บาท',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF7A7F87),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),
                            const Divider(
                              thickness: 1.2,
                              color: Color(0xFFE5E7EB),
                            ),
                            const SizedBox(height: 8),

                            // วงเงินในวอลเล็ต
                            Row(
                              children: [
                                const Text(
                                  'วงเงินในวอลเล็ต',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF7A7F87),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _fmt(creditLimit),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1F2937),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ปุ่ม เติมเงิน / ถอนเงิน
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _ActionIcon(
                                  icon: Icons.add_card_rounded,
                                  label: 'เติมเงิน',
                                  onTap: _onTopup, // → ไปหน้าเติมเงิน
                                ),
                                _ActionIcon(
                                  icon: Icons.account_balance_wallet_outlined,
                                  label: 'ถอนเงิน',
                                  onTap: _onWithdraw, // → ไปหน้าถอนเงิน
                                ),
                              ],
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
      bottomNavigationBar: AppFooter(
        userIdx: widget.userIdx,
        activeIndex: 2,
      ), // <- ตามที่ขอ
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            width: 80,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: const Color(0xFF2B2B2B)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
