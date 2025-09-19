import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/widgets/app_footer.dart';

class TopUpPage extends StatefulWidget {
  final int userIdx;
  final double balance; // ยอดปัจจุบัน (โชว์ในการ์ด)
  const TopUpPage({super.key, required this.userIdx, required this.balance});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController amountCtl = TextEditingController(text: '500');

  String _fmt(num n) => n
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  Future<void> _submit() async {
    final raw = amountCtl.text.trim();
    final amt = double.tryParse(raw) ?? 0;
    if (amt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกจำนวนเงินให้ถูกต้อง')),
      );
      return;
    }

    // TODO: เรียก API เติมเงินจริงที่นี่ เช่น POST /wallet/topup {amount}
    // success demo:
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('เติมเงินสำเร็จ +${_fmt(amt)} บาท')));
    Navigator.pop(context); // กลับไปหน้า Wallet
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                'assets/images/bg (2).png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Container(height: 320, color: const Color(0xAA55D6DD)),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back + Title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'LOTTERY',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Center(
                      child: Container(
                        width: w.clamp(0, 420),
                        padding: const EdgeInsets.fromLTRB(18, 20, 18, 26),
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
                            // โลโก้ด้านบน
                            Image.asset(
                              'assets/images/lottery_logo.png',
                              height: 88,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.confirmation_number_rounded,
                                size: 64,
                                color: Color(0xFF3AA7C3),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // การ์ดวอลเล็ตเล็ก
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Color(0xFFFFF3E0),
                                    child: Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'วอลเล็ต',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _fmt(widget.balance),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            // label
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'จำนวนเงินที่จะเติม',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3A3A3A),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ช่องกรอกจำนวน
                            TextField(
                              controller: amountCtl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: false,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: '0',
                                filled: true,
                                fillColor: const Color(0xFFF7F7F7),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ปุ่มเติมเงิน
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE0A007),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'เติมเงิน',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppFooter(userIdx: widget.userIdx, activeIndex: 2),
    );
  }
}
