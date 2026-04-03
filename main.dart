import 'package:flutter/material.dart';

void main() => runApp(const TaiPayApp());

class TaiPayApp extends StatefulWidget {
  const TaiPayApp({super.key});

  @override
  State<TaiPayApp> createState() => _TaiPayAppState();
}

class _TaiPayAppState extends State<TaiPayApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF2F4F6),
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF111111),
        cardColor: const Color(0xFF1C1C1E),
      ),
      home: RootScreen(
        onChangeTheme: _changeTheme,
        currentMode: _themeMode,
      ),
    );
  }
}

class RootScreen extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  final ThemeMode currentMode;

  const RootScreen({
    super.key,
    required this.onChangeTheme,
    required this.currentMode,
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      const HomeScreen(),
      const ReceiptScreen(),
      const StockScreen(),
      const CryptoScreen(),
      MyScreen(
        onChangeTheme: widget.onChangeTheme,
        currentMode: widget.currentMode,
      ),
    ];
  }

  @override
  void didUpdateWidget(covariant RootScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMode != widget.currentMode) {
      setState(() {
        _initializePages();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3182F6),
        unselectedItemColor: isDark ? Colors.grey[600] : const Color(0xFF9E9E9E),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '首頁'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: '載具'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: '證券'),
          BottomNavigationBarItem(icon: Icon(Icons.currency_bitcoin), label: '加密貨幣'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: '我的'),
        ],
      ),
    );
  }
}


// [1] 홈 화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F4F6),
        elevation: 0,
        title: const Text('TaiPay', style: TextStyle(color: Color(0xFF3182F6), fontWeight: FontWeight.w900, fontSize: 26)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: Row(children: [
              _quickMenu(context, Icons.send_rounded, "轉帳", const Color(0xFF3182F6), const TransferScreen()),
              _quickMenu(context, Icons.qr_code_scanner_rounded, "掃碼支付", const Color(0xFF3182F6), const PaymentScreen()),
              _quickMenu(context, Icons.history_rounded, "交易紀錄", const Color(0xFF4E5968), const HistoryScreen()),
            ]),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AccountListScreen())),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("我的帳戶", style: TextStyle(color: Color(0xFF6B7684), fontWeight: FontWeight.w600)),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFB0B8C1)),
                ]),
                SizedBox(height: 8),
                Text("NT\$ 125,430", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _quickMenu(BuildContext context, IconData icon, String label, Color color, Widget page) {
    return Expanded(child: InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => page)),
      child: Column(children: [Icon(icon, color: color, size: 32), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]),
    ));
  }
}

// [2] 상세 계좌 목록
class AccountListScreen extends StatelessWidget {
  const AccountListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("已連結帳戶", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildBankItem("822", "中國信託 (CTBC)", "NT\$ 12,000", Colors.green),
          _buildBankItem("013", "國泰世華 (Cathay)", "NT\$ 5,400", Colors.lightGreen),
          _buildBankItem("012", "台北富邦 (Fubon)", "NT\$ 85,200", Colors.blue),
          _buildBankItem("700", "中華郵政 (Post)", "NT\$ 1,200", Colors.green[800]!),
          _buildBankItem("812", "台新銀行 (Taishin)", "NT\$ 21,630", Colors.red[900]!),
          const SizedBox(height: 30),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("連結新帳戶"),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankItem(String code, String name, String bal, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Text(code, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(bal),
      trailing: const Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}

class AccountDetailScreen extends StatelessWidget {
  final String bankName;
  final String balance;
  const AccountDetailScreen({super.key, required this.bankName, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: Text(bankName)),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(bankName, style: const TextStyle(color: Colors.grey)),
          Text(balance, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          // 송금 버튼 (클릭 시 기존 TransferScreen으로 이동)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TransferScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3182F6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.send, size: 16), SizedBox(width: 8), Text("轉帳")]),
            ),
          ),
          const SizedBox(height: 30),
          const Divider(thickness: 8, color: Color(0xFFF2F4F6)),
          Expanded(
            child: ListView(
              children: [
                const Padding(padding: EdgeInsets.all(20), child: Text("交易紀錄", style: TextStyle(fontWeight: FontWeight.bold))),
                _historyTile("2026/04/03", "全家便利商店", "- NT\$ 85", false),
                _historyTile("2026/04/02", "薪資입금", "+ NT\$ 50,000", true),
                _historyTile("2026/04/01", "ATM 출금", "- NT\$ 1,000", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyTile(String date, String title, String amount, bool isPlus) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(date),
      trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: isPlus ? Colors.blue : Colors.black)),
    );
  }
}

// [3] 송금 (轉帳)
class TransferScreen extends StatefulWidget {
  final String? initialBank; // 계좌 상세에서 넘어올 경우 대비
  const TransferScreen({super.key, this.initialBank});

  @override State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int step = 1;
  String? bank;
  String myAcc = "TaiPay 主帳戶";
  double myBalance = 125430.0; // 현재 선택된 계좌의 잔액 (예시)

  final TextEditingController _accController = TextEditingController();
  final TextEditingController _amtController = TextEditingController();

  // 버튼 활성화 로직
  bool get isStep1Valid => bank != null && _accController.text.length == 10;

  // 금액 입력 시: 비어있지 않음 + 숫자임 + 잔액보다 작거나 같음
  bool get isStep3Valid {
    if (_amtController.text.isEmpty) return false;
    double? inputAmt = double.tryParse(_amtController.text);
    return inputAmt != null && inputAmt > 0 && inputAmt <= myBalance;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialBank != null) bank = widget.initialBank;

    // 입력할 때마다 UI 갱신 (버튼 색상 변경용)
    _accController.addListener(() => setState(() {}));
    _amtController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _accController.dispose();
    _amtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => step > 1 ? setState(() => step--) : Navigator.pop(context),
        ),
      ),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: _buildFlow()),
    );
  }

  Widget _buildFlow() {
    if (step == 1) return _step1();
    if (step == 2) return _step2();
    if (step == 3) return _step3();
    return _step4(); // 확인 화면
  }

  // 1단계: 입금처 정보
  Widget _step1() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text("想轉帳給誰？", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
    const SizedBox(height: 30),
    DropdownButtonFormField<String>(
      value: bank,
      decoration: _inputDeco(label: "選擇銀行"),
      items: const [
        DropdownMenuItem(value: "822 中國信託", child: Text("822 中國信託")),
        DropdownMenuItem(value: "013 國泰世華", child: Text("013 國泰世華")),
        DropdownMenuItem(value: "012 台北富邦", child: Text("012 台北富邦")),
      ],
      onChanged: (v) => setState(() => bank = v),
    ),
    const SizedBox(height: 16),
    TextField(
      controller: _accController,
      maxLength: 10,
      decoration: _inputDeco(label: "輸入帳號 (10碼)"),
      keyboardType: TextInputType.number,
    ),
    const Spacer(),
    _actionBtn("下一步", isStep1Valid, () => setState(() => step = 2)),
  ]);

  // 2단계: 출금 계좌 선택
  Widget _step2() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text("從哪個帳戶扣款？", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
    const SizedBox(height: 20),
    _radioTile("TaiPay 主帳戶", 125430),
    _radioTile("中國信託", 12000),
    const Spacer(),
    _actionBtn("下一步", true, () => setState(() => step = 3)),
  ]);

  // 3단계: 금액 입력 (잔액 리밋 체크)
  Widget _step3() {
    double? currentInput = double.tryParse(_amtController.text) ?? 0;
    bool isOver = currentInput > myBalance;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("餘額: NT\$ ${myBalance.toStringAsFixed(0)}", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      const Text("請輸入金額", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 40),
      TextField(
        controller: _amtController,
        autofocus: true,
        style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: isOver ? Colors.red : Colors.black),
        decoration: const InputDecoration(suffixText: "NTD", border: InputBorder.none, hintText: "0"),
        keyboardType: TextInputType.number,
      ),
      if (isOver) const Text("輸入金額已超過餘額", style: TextStyle(color: Colors.red, fontSize: 14)),
      const Spacer(),
      _actionBtn("下一步", isStep3Valid, () => setState(() => step = 4)),
    ]);
  }

  // 4단계: 최종 확인 화면
  Widget _step4() => Column(children: [
    const SizedBox(height: 40),
    Text("是否轉帳\n${_amtController.text} 元給鄭聖雨 ?", textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 40),
    _rowInfo("出款帳戶", myAcc),
    _rowInfo("入款帳戶", "$bank / ${_accController.text}"),
    const Spacer(),
    _actionBtn("轉帳", true, () {
      // 완료 팝업 후 홈으로 이동
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("轉帳已完成")));
      Navigator.popUntil(context, (route) => route.isFirst);
    }),
  ]);

  Widget _radioTile(String title, double bal) {
    String fullTitle = "$title (NT\$ $bal)";
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("餘額: NT\$ $bal"),
      leading: Radio<String>(
          value: title,
          groupValue: myAcc,
          onChanged: (v) => setState(() { myAcc = v!; myBalance = bal; })
      ),
      onTap: () => setState(() { myAcc = title; myBalance = bal; }),
    );
  }

  Widget _rowInfo(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l, style: const TextStyle(color: Colors.grey, fontSize: 16)),
      Text(v, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    ]),
  );

  InputDecoration _inputDeco({required String label}) => InputDecoration(
      labelText: label, filled: true, fillColor: const Color(0xFFF2F4F6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
  );

  Widget _actionBtn(String label, bool active, VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: active ? const Color(0xFF3182F6) : Colors.grey[300],
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 0
        ),
        onPressed: active ? onPressed : null,
        child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
    ),
  );
}

// [4] 결제 (掃碼支付)
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override State<PaymentScreen> createState() => _PaymentScreenState();
}
class _PaymentScreenState extends State<PaymentScreen> {
  String selectedAcc = "TaiPay 主帳戶 (NT\$ 50,430)";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text("TaiPay", style: TextStyle(fontWeight: FontWeight.bold)), bottom: const TabBar(indicatorColor: Color(0xFF3182F6), labelColor: Color(0xFF3182F6), tabs: [Tab(text: "條碼/QR碼"), Tab(text: "掃描")])),
      body: TabBarView(children: [
        _barcodeView(),
        const Center(child: Text("Camera")),
      ]),
    ));
  }
  Widget _barcodeView() => Padding(padding: const EdgeInsets.all(32), child: Column(children: [
    Container(height: 80, width: double.infinity, color: const Color(0xFFF2F4F6), child: const Center(child: Text("|||||||||||||||||||||||", style: TextStyle(letterSpacing: 5)))),
    const SizedBox(height: 30),
    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFF2F4F6)), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.qr_code_2, size: 150)),
    const Spacer(),
    DropdownButton<String>(isExpanded: true, value: selectedAcc, items: ["TaiPay 主帳戶 (NT\$ 50,430)", "中國信託 (NT\$ 12,000)"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => selectedAcc = v!)),
  ]));
}

// [5] 거래 기록 (交易紀錄)
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("交易紀錄"), backgroundColor: Colors.white),
      body: ListView(children: [
        _historyTile("2026/04/03 08:30", "7-ELEVEN 德陽門市", "- NT\$ 125", false),
        _historyTile("2026/04/02 12:00", "轉帳收入 (王小明)", "+ NT\$ 1,000", true),
      ]),
    );
  }
  Widget _historyTile(String d, String t, String a, bool p) => ListTile(
    title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(d),
    trailing: Text(a, style: TextStyle(fontWeight: FontWeight.bold, color: p ? Colors.red : Colors.black)),
  );
}

// [6] 자이쮜 관리 (載具管理)
class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});
  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F4F6),
        elevation: 0,
        title: const Text("載具管理", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Color(0xFF4E5968))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          // 1. 메인 자이쮜 바코드 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(children: [
              const Row(children: [
                Icon(Icons.qr_code_2, color: Color(0xFF3182F6), size: 20),
                SizedBox(width: 8),
                Text("手機條碼", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4E5968))),
              ]),
              const SizedBox(height: 20),
              // 바코드 이미지 영역 (실제로는 바코드 폰트나 이미지를 넣음)
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("/ABC-1234", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  SizedBox(height: 8),
                  Text("|||| ||| || ||||| || ||| ||||", style: TextStyle(fontSize: 30, letterSpacing: 1)),
                ]),
              ),
              const SizedBox(height: 16),
              const Text("請在付款前出示給店員", style: TextStyle(color: Color(0xFF8B95A1), fontSize: 13)),
            ]),
          ),

          const SizedBox(height: 16),

          // 2. 당첨 확인 섹션 (대만의 발표일에 맞춰 강조)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("3-4月統一發票中獎查詢", style: TextStyle(fontSize: 15, color: Color(0xFF4E5968))),
                SizedBox(height: 4),
                Text("尚未公布", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2F4F6),
                  foregroundColor: const Color(0xFF4E5968),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("查看"),
              ),
            ]),
          ),

          const SizedBox(height: 16),

          // 3. 최근 영수증 목록
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("最新發票", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _receiptTile("2026/04/03", "7-ELEVEN", "NT\$ 45"),
              _receiptTile("2026/04/02", "FamilyMart", "NT\$ 120"),
              _receiptTile("2026/04/01", "Starbucks", "NT\$ 165"),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text("查看全部紀錄", style: TextStyle(color: Color(0xFF6B7684))),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _receiptTile(String date, String store, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(store, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          Text(date, style: const TextStyle(color: Color(0xFF8B95A1), fontSize: 13)),
        ]),
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ]),
    );
  }
}

// [7] 증권 (證券 - 상세 구현)
class StockScreen extends StatefulWidget {
  const StockScreen({super.key});
  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F4F6),
        elevation: 0,
        title: const Text("證券", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Color(0xFF4E5968))),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Color(0xFF4E5968))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 1. 내 주식 자산 요약
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("投資資產", style: TextStyle(color: Color(0xFF6B7684), fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text("NT\$ 852,400", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(children: [
                const Text("+ NT\$ 12,400 (1.47%)", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                Text("今天", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              ]),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _stockActionBtn(Icons.account_balance_wallet_outlined, "帳戶明細"),
                _stockActionBtn(Icons.auto_graph_outlined, "投資報酬率"),
                _stockActionBtn(Icons.notifications_none_outlined, "通知"),
              ]),
            ]),
          ),

          const SizedBox(height: 24),
          const Text("關注標的", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4E5968))),
          const SizedBox(height: 12),

          // 2. 관심 종목 리스트 (대만 주요 주식 예시)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: Column(children: [
              _interestStockTile("TSMC (2330)", "780.00", "+2.4%", true),
              _interestStockTile("鴻海 (2317)", "155.50", "-0.3%", false),
              _interestStockTile("聯發科 (2454)", "1,120.00", "+1.2%", true),
              _interestStockTile("NVIDIA (NVDA)", "903.60", "+0.8%", true), // 미국주식 포함 가능
              const Divider(indent: 20, endIndent: 20),
              TextButton(
                onPressed: () {},
                child: const Text("更多", style: TextStyle(color: Color(0xFF6B7684))),
              ),
            ]),
          ),

          const SizedBox(height: 24),
            const Text("今日指數", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4E5968))),
          const SizedBox(height: 12),

          // 3. 시장 지수 카드 (가로 스크롤)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _marketIndexCard("加權指數 (TWII)", "20,330.5", "+0.9%"),
              _marketIndexCard("納斯達克 (NASDAQ)", "16,396.8", "+1.1%"),
              _marketIndexCard("S&P 500", "5,254.3", "+0.4%"),
            ]),
          ),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _stockActionBtn(IconData icon, String label) {
    return Column(children: [
      Icon(icon, color: const Color(0xFF4E5968)),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF4E5968))),
    ]);
  }

  Widget _interestStockTile(String name, String price, String change, bool isUp) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF2F4F6),
        child: Text(name[0], style: const TextStyle(color: Color(0xFF3182F6))),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(change, style: TextStyle(color: isUp ? Colors.red : Colors.blue, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _marketIndexCard(String title, String index, String change) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7684))),
        const SizedBox(height: 10),
        Text(index, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(change, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// [8] 가상화폐 (虛擬貨幣 - 상세 구현)
class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});
  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F4F6),
        elevation: 0,
        title: const Text("虛擬貨幣", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Color(0xFF4E5968))),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Color(0xFF4E5968))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 1. 총 가상자산 요약
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("虛擬資產總額", style: TextStyle(color: Color(0xFF6B7684), fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text("NT\$ 42,500", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("+ NT\$ 3,120 (7.91%)", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              Row(children: [
                _cryptoMenuBtn("充值"),
                const SizedBox(width: 12),
                _cryptoMenuBtn("轉出"),
              ]),
            ]),
          ),

          const SizedBox(height: 24),
          const Text("市場行情", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4E5968))),
          const SizedBox(height: 12),

          // 2. 코인 리스트
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: Column(children: [
              // CryptoScreen의 _coinTile 호출부 수정
              _coinTile("比特幣", "BTC", "2,145,300", "+1.2%", true, Icons.currency_bitcoin),
              _coinTile("以太幣", "ETH", "112,400", "+0.8%", true, Icons.diamond_outlined),
// WbSunnyOutlined -> wb_sunny_outlined (소문자로 변경)
              _coinTile("索拉納", "SOL", "5,420", "-2.1%", false, Icons.wb_sunny_outlined),
// WavesOutlined -> water_drop_outlined (존재하는 아이콘으로 변경)
              _coinTile("瑞波幣", "XRP", "19.5", "+0.4%", true, Icons.water_drop_outlined),              const Divider(indent: 20, endIndent: 20),
              TextButton(
                onPressed: () {},
                child: const Text("新增資產", style: TextStyle(color: Color(0xFF3182F6), fontWeight: FontWeight.w600)),
              ),
            ]),
          ),

          const SizedBox(height: 24),
          // 3. 간단한 팁/배너
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF3182F6), Color(0xFF0048B3)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("第一次投資加密貨幣遇到困難嗎？", style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 4),
                Text("查看比特幣購買指南", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ]),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ]),
          ),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _cryptoMenuBtn(String label) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF2F4F6),
          foregroundColor: const Color(0xFF4E5968),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _coinTile(String name, String symbol, String price, String change, bool isUp, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF2F4F6),
        child: Icon(icon, color: const Color(0xFF3182F6), size: 20),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(symbol, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text("NT\$ $price", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(change, style: TextStyle(color: isUp ? Colors.red : Colors.blue, fontWeight: FontWeight.w600, fontSize: 13)),
      ]),
    );
  }
}

// [9] 마이 화면 (我的 - 다크모드 설정 포함 상세 구현)
class MyScreen extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  final ThemeMode currentMode;

  const MyScreen({
    super.key,
    required this.onChangeTheme,
    required this.currentMode
  });

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    // 현재 테마가 다크인지 확인
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 테마에 따라 배경색 자동 조절
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings_outlined, color: isDark ? Colors.white : const Color(0xFF4E5968))
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // 1. 프로필 섹션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                child: const Icon(Icons.person, size: 40, color: Color(0xFFB0B8C1)),
              ),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("鄭聖雨", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: const Text("編輯個人資料 >", style: TextStyle(fontSize: 12, color: Color(0xFF6B7684))),
                ),
              ]),
            ]),
          ),

          const SizedBox(height: 20),

          // 2. 테마 설정 섹션 (추가됨)
          _buildMenuSection([
            ListTile(
              leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode,
                  color: isDark ? Colors.amber : Colors.orange),
              title: const Text("夜間模式", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: Switch(
                value: isDark,
                activeColor: const Color(0xFF3182F6),
                onChanged: (val) {
                  widget.onChangeTheme(val ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
          ], context),

          const SizedBox(height: 12),

          // 3. 주요 메뉴 그룹
          _buildMenuSection([
            _menuTile(Icons.notifications_none_rounded, "通知設定", context),
            _menuTile(Icons.security_rounded, "認證與安全", context),
            _menuTile(Icons.account_balance_wallet_outlined, "我的付款方式", context),
          ], context),

          const SizedBox(height: 12),

          // 4. 서비스 지원 및 로그아웃
          _buildMenuSection([
            _menuTile(Icons.headset_mic_outlined, "客服中心", context),
            _menuTile(Icons.card_giftcard_rounded, "邀請好友活動", context, color: Colors.red),
            ListTile(
              onTap: () => _showLogoutDialog(context),
              leading: const Icon(Icons.logout_rounded, color: Color(0xFFF04452)),
              title: const Text("登出", style: TextStyle(color: Color(0xFFF04452), fontWeight: FontWeight.w600)),
            ),
          ], context),

          const SizedBox(height: 40),
          const Text("版本資訊 1.0.0", style: TextStyle(color: Color(0xFFB0B8C1), fontSize: 12)),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _buildMenuSection(List<Widget> children, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        // 테마에 따라 카드 색상 변경
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(22)
      ),
      child: Column(children: children),
    );
  }

  Widget _menuTile(IconData icon, String title, BuildContext context, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : const Color(0xFF4E5968))),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFB0B8C1)),
      onTap: () {},
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("登出", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("確定要登出嗎？"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("取消", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("登出", style: TextStyle(color: Color(0xFFF04452), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}