import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/constants.dart';

class PartnerListingScreen extends StatefulWidget {
  const PartnerListingScreen({super.key});

  @override
  State<PartnerListingScreen> createState() => _PartnerListingScreenState();
}

class _PartnerListingScreenState extends State<PartnerListingScreen> {
  final _businessNameController =
      TextEditingController(text: 'فندق الأوراسي');
  final _descriptionController = TextEditingController(
    text:
        'فندق فاخر يقع في قلب الجزائر العاصمة مع إطلالة بانورامية على خليج الجزائر. يوفر خدمات عالية الجودة ومرافق متنوعة.',
  );
  String _selectedCategory = 'فندق';
  String _selectedWilaya = 'الجزائر العاصمة';
  String _selectedPriceRange = 'مريحة';

  final List<String> _categories = [
    'فندق',
    'مطعم',
    'موقع سياحي',
    'نشاط ترفيهي',
  ];

  final List<String> _priceRanges = [
    'اقتصادية',
    'مريحة',
    'مميزة',
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppConstants.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppConstants.primaryGreen,
          title: Text(
            'ملفي التجاري',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.primaryGreen.withValues(alpha: 0.8),
                      AppConstants.primaryGreenLight.withValues(alpha: 0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppConstants.accentGold,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.store,
                        color: AppConstants.primaryGreenDark,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'فندق الأوراسي',
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'الجزائر العاصمة • فندق',
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Business name
              _buildLabel('اسم النشاط التجاري'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _businessNameController,
                style: GoogleFonts.cairo(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.business,
                      color: AppConstants.primaryGreen),
                  hintStyle: GoogleFonts.cairo(color: AppConstants.textLight),
                ),
              ),
              const SizedBox(height: 20),

              // Category
              _buildLabel('التصنيف'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstants.divider),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    prefixIcon: const Icon(Icons.category,
                        color: AppConstants.primaryGreen),
                    hintStyle:
                        GoogleFonts.cairo(color: AppConstants.textLight),
                  ),
                  style: GoogleFonts.cairo(
                    color: AppConstants.textDark,
                    fontSize: 16,
                  ),
                  dropdownColor: Colors.white,
                  items: _categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat, style: GoogleFonts.cairo()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Wilaya
              _buildLabel('الولاية'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstants.divider),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedWilaya,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    prefixIcon: const Icon(Icons.location_on,
                        color: AppConstants.primaryGreen),
                    hintStyle:
                        GoogleFonts.cairo(color: AppConstants.textLight),
                  ),
                  style: GoogleFonts.cairo(
                    color: AppConstants.textDark,
                    fontSize: 16,
                  ),
                  dropdownColor: Colors.white,
                  items: AppConstants.supportedWilayas.map((w) {
                    return DropdownMenuItem(
                      value: w,
                      child: Text(w, style: GoogleFonts.cairo()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedWilaya = value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Description
              _buildLabel('الوصف'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                style: GoogleFonts.cairo(),
                decoration: InputDecoration(
                  hintText: 'اكتب وصفاً لنشاطك التجاري',
                  hintStyle: GoogleFonts.cairo(color: AppConstants.textLight),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              // Price range
              _buildLabel('فئة الأسعار'),
              const SizedBox(height: 12),
              Row(
                children: _priceRanges.map((range) {
                  final isSelected = _selectedPriceRange == range;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedPriceRange = range),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppConstants.primaryGreen
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppConstants.primaryGreen
                                : AppConstants.divider,
                          ),
                        ),
                        child: Text(
                          range,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppConstants.textDark,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 36),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم الحفظ',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: AppConstants.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save, size: 20),
                  label: Text(
                    'حفظ التغييرات',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppConstants.textDark,
      ),
    );
  }
}
