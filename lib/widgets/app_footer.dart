import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/main_user.dart';
import 'package:flutter_application_2/pages/profile.dart';
import 'package:flutter_application_2/pages/wallet.dart';

// FooterItem class
class _FooterItem {
  final String iconPath;
  final String label;
  const _FooterItem({required this.iconPath, required this.label});
}

class AppFooter extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onTap;
  final int userIdx; // ✅ รับ userIdx เข้ามา

  const AppFooter({
    super.key,
    this.activeIndex = 0,
    this.onTap,
    required this.userIdx, // ✅ ต้องการ userIdx ทุกครั้ง
  });

  @override
  Widget build(BuildContext context) {
    final items = <_FooterItem>[
      _FooterItem(iconPath: 'assets/Icons/Home.png', label: 'หน้าหลัก'),
      _FooterItem(iconPath: 'assets/Icons/serch.png', label: 'ลอตเตอรี่ของฉัน'),
      _FooterItem(iconPath: 'assets/Icons/Vector.png', label: 'กระเป๋าเงิน'),
      _FooterItem(iconPath: 'assets/Icons/lottery.png', label: 'ตรวจรางวัล'),
      _FooterItem(iconPath: 'assets/Icons/posona.png', label: 'สมาชิก'),
    ];

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF35588A),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final bool active = i == activeIndex;

            return Expanded(
              child: InkWell(
                onTap: () {
                  // ✅ ส่ง userIdx ตอนเปลี่ยนหน้า
                  if (i == 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MainUser(userIdx: userIdx),
                      ),
                    );
                  } else if (i == 1) {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => MyLotto(userIdx: userIdx),
                    //   ),
                    // );
                  } else if (i == 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WalletPage(userIdx: userIdx),
                      ),
                    );
                  } else if (i == 3) {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => CheckReward(userIdx: userIdx),
                    //   ),
                    // );
                  } else if (i == 4) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Profile(userIdx: userIdx),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      item.iconPath,
                      width: 32,
                      height: 32,
                      color: active ? const Color(0xFFFFD54F) : Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
