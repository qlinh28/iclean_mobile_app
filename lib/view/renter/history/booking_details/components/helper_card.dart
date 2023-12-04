import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/models/helper.dart';
import 'package:iclean_mobile_app/services/api_booking_repo.dart';
import 'package:iclean_mobile_app/view/renter/nav_bar_bottom/renter_screen.dart';
import 'package:iclean_mobile_app/widgets/checkout_success_dialog.dart';
import 'package:iclean_mobile_app/widgets/main_color_inkwell_full_size.dart';

class HelperCard extends StatelessWidget {
  const HelperCard({
    super.key,
    required this.helper,
    required this.bookingId,
  });

  final Helper helper;
  final int bookingId;

  @override
  Widget build(BuildContext context) {
    void chooseHelper(int bookingId, int helperId) {
      final ApiBookingRepository repository = ApiBookingRepository();
      repository.chooseHelperForBooking(bookingId, helperId, context).then((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) => CheckoutSuccessDialog(
            title: "Chọn người giúp việc thành công",
            description: "Dịch vụ của bạn sắp được hoàn thành!",
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RenterScreens(
                          selectedIndex: 1, initialIndex: 2)));
            },
          ),
        );
      }).catchError((error) {
        // ignore: avoid_print
        print('Failed to choose location: $error');
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(helper.avatar),
                radius: 36,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    helper.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    helper.phoneNumber,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Đánh giá (${helper.numberOfFeedback})",
                    style: const TextStyle(
                      fontFamily: 'Lato',
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          helper.rate.toInt(), // assuming rate is a double
                          (index) => const Icon(Icons.star),
                        ),
                      ),
                      if (helper.rate % 1 != 0)
                        const Icon(Icons.star_half), // Half star
                      Text(
                        "(${helper.rate.toString()})",
                        style: const TextStyle(
                          fontFamily: 'Lato',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          MainColorInkWellFullSize(
            onTap: () {
              chooseHelper(bookingId, helper.id);
            },
            text: "Chọn người này",
          ),
        ],
      ),
    );
  }
}