import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PaymentChoosePrice();
  }
}

class _PaymentChoosePrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          mouseCursor: SystemMouseCursors.click,
        ),
        title: Text('Payment Method'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Choose Price Of Class',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 16),
            _PriceOption(title: 'For One Subject', price: '400 ETB / Year'),
            SizedBox(height: 12),
            _PriceOption(title: 'For Full Class', price: '2000 ETB / Year'),
            Spacer(),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => Get.to(() => _PaymentMethodPage()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceOption extends StatelessWidget {
  final String title;
  final String price;
  const _PriceOption({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.black54)),
        SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: Text(price, style: TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }
}

class _PaymentMethodPage extends StatefulWidget {
  @override
  State<_PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<_PaymentMethodPage> {
  String _selected = 'bank';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          mouseCursor: SystemMouseCursors.click,
        ),
        title: Text('Payment Method'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _RadioTile(
              title: 'Bank Transfer',
              value: 'bank',
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v),
            ),
            _RadioTile(
              title: 'Telebirr',
              value: 'telebirr',
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v),
            ),
            _RadioTile(
              title: 'Mobile Banking',
              value: 'mobile',
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Get.to(() => _PaymentOptionPage()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Next'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 18)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  const _RadioTile({required this.title, required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: (v) => onChanged(v!),
        title: Text(title),
      ),
    );
  }
}

class _PaymentOptionPage extends StatefulWidget {
  @override
  State<_PaymentOptionPage> createState() => _PaymentOptionPageState();
}

class _PaymentOptionPageState extends State<_PaymentOptionPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _account = TextEditingController();
  String? _bank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          mouseCursor: SystemMouseCursors.click,
        ),
        title: Text('Payment Option'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Choose the payment Option'),
            SizedBox(height: 8),
            _DropdownField(
              hint: 'Choose your bank',
              value: _bank,
              items: [
                'Commercial Bank of Ethiopia',
                'Abay Bank',
                'Dashen Bank',
                'Abyssinia Bank',
                'Awash Bank',
                'Amhara Bank',
              ],
              onChanged: (v) => setState(() => _bank = v),
            ),
            SizedBox(height: 16),
            Text('Full Name'),
            SizedBox(height: 6),
            _TextField(controller: _name),
            SizedBox(height: 12),
            Text('Account'),
            SizedBox(height: 6),
            _TextField(controller: _account, keyboardType: TextInputType.number),
            SizedBox(height: 16),
            Text('Upload Receipt'),
            SizedBox(height: 6),
            _UploadPlaceholder(),
            SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _showSuccess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Enroll Now'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 18)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccess() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.blue, size: 56),
              SizedBox(height: 12),
              Text('Payment Success', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('Your successfully Sent, please wait till you receive Approval from Admin.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField({required this.hint, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint),
          value: value,
          onChanged: onChanged,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  const _TextField({required this.controller, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue.shade700)),
      ),
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade600),
            SizedBox(height: 6),
            Text('Click or drag file to this area to upload', style: TextStyle(color: Colors.black54, fontSize: 12)),
            SizedBox(height: 6),
            Text('Formats accepted are .jpg,.png and .pdf', style: TextStyle(color: Colors.black45, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
