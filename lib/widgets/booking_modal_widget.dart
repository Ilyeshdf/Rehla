import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../models/booking_model.dart';
import '../providers/partner_provider.dart';

class BookingModalWidget extends StatefulWidget {
  final String placeName;
  final String category;
  final Function(Booking) onConfirm;
  final String bookingType;
  final String? partnerId;
  final String? placeId;

  const BookingModalWidget({
    super.key,
    required this.placeName,
    required this.category,
    required this.onConfirm,
    this.bookingType = 'place',
    this.partnerId,
    this.placeId,
  });

  @override
  State<BookingModalWidget> createState() => _BookingModalWidgetState();
}

class _BookingModalWidgetState extends State<BookingModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _numberOfGuests = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppConstants.accentTeal,
              onPrimary: AppConstants.backgroundDark,
              surface: AppConstants.backgroundCard,
              onSurface: AppConstants.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppConstants.backgroundCard,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppConstants.backgroundCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: AppConstants.divider, width: 0.5)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppConstants.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstants.accentTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(widget.bookingType == 'guide' ? Icons.explore : Icons.bookmark_add, color: AppConstants.accentTeal, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookingType == 'guide' ? 'BOOK GUIDE' : 'RESERVE YOUR SPOT',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppConstants.accentTeal,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          widget.placeName,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _buildLabel('FULL NAME', 'الاسم الكامل'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                hint: 'Enter your name',
                icon: Icons.person_outline,
                validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 20),

              _buildLabel('PHONE NUMBER', 'رقم الهاتف'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hint: '05XXXXXXXX',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Please enter phone number' : null,
              ),
              const SizedBox(height: 20),

              Row(
                children: [

                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('DATE', 'التاريخ'),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppConstants.backgroundElevated,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppConstants.divider.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, color: AppConstants.textSecondary, size: 18),
                                const SizedBox(width: 12),
                                Text(
                                  intl.DateFormat('MMM dd, yyyy').format(_selectedDate),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppConstants.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('GUESTS', 'الأشخاص'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppConstants.backgroundElevated,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppConstants.divider.withValues(alpha: 0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _numberOfGuests > 1 ? () => setState(() => _numberOfGuests--) : null,
                                child: Icon(Icons.remove, size: 18, 
                                  color: _numberOfGuests > 1 ? AppConstants.textPrimary : AppConstants.textTertiary),
                              ),
                              Text(
                                '$_numberOfGuests',
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppConstants.textPrimary),
                              ),
                              GestureDetector(
                                onTap: _numberOfGuests < 20 ? () => setState(() => _numberOfGuests++) : null,
                                child: Icon(Icons.add, size: 18, 
                                  color: _numberOfGuests < 20 ? AppConstants.accentTeal : AppConstants.textTertiary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final bookingData = {
                        'name': _nameController.text,
                        'phone': _phoneController.text,
                        'place': widget.placeName,
                        'date': intl.DateFormat('yyyy-MM-dd').format(_selectedDate),
                        'guests': _numberOfGuests,
                        'partner_id': widget.partnerId,
                        'place_id': widget.placeId,
                      };
                      
                      // Save to Supabase via Provider
                      try {
                        context.read<PartnerProvider>().addBooking(bookingData);
                      } catch (e) {
                        debugPrint('Supabase Add Booking Error: $e');
                      }

                      final booking = Booking(
                        placeName: widget.placeName,
                        category: widget.category,
                        fullName: _nameController.text,
                        phoneNumber: _phoneController.text,
                        date: _selectedDate,
                        numberOfGuests: _numberOfGuests,
                        bookingType: widget.bookingType,
                      );
                      widget.onConfirm(booking);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.accentTeal,
                    foregroundColor: AppConstants.backgroundDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    'CONFIRM BOOKING',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String en, String ar) {
    return Row(
      children: [
        Text(en, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppConstants.textTertiary, letterSpacing: 1)),
        const SizedBox(width: 8),
        Text('• $ar', style: GoogleFonts.cairo(fontSize: 10, color: AppConstants.textTertiary.withValues(alpha: 0.6))),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(color: AppConstants.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: AppConstants.textTertiary, fontSize: 14),
        prefixIcon: Icon(icon, color: AppConstants.textSecondary, size: 20),
        filled: true,
        fillColor: AppConstants.backgroundElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppConstants.divider.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppConstants.divider.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppConstants.accentTeal),
        ),
      ),
    );
  }
}
