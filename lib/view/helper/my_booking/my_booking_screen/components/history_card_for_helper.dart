import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/models/bookings.dart';
import 'package:iclean_mobile_app/models/booking_status.dart';
import 'package:iclean_mobile_app/utils/color_palette.dart';
import 'package:iclean_mobile_app/utils/time.dart';
import 'package:iclean_mobile_app/view/helper/my_booking/booking_details/booking_details_for_helper_screen.dart';
import 'package:iclean_mobile_app/widgets/avatar_widget.dart';
import 'package:iclean_mobile_app/widgets/info_booking.dart';

import 'package:intl/intl.dart';

class HistoryCardForHelper extends StatefulWidget {
  final List<Booking> listBookings;

  const HistoryCardForHelper({
    super.key,
    required this.listBookings,
  });

  @override
  State<HistoryCardForHelper> createState() => _HistoryCardForHelperState();
}

class _HistoryCardForHelperState extends State<HistoryCardForHelper>
    with TickerProviderStateMixin {
  Color getColorForStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.notYet:
        return ColorPalette.mainColor;
      case BookingStatus.rejected:
        return Colors.red;
      case BookingStatus.upcoming:
        return Colors.lightBlue;
      case BookingStatus.finished:
        return Colors.green;
      default:
        return ColorPalette.mainColor;
    }
  }

  String getStringForStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.notYet:
        return "Đang đợi duyệt đơn";
      case BookingStatus.rejected:
        return "Bị từ chối";
      case BookingStatus.upcoming:
        return "Sắp đến";
      case BookingStatus.finished:
        return "Hoàn thành";
      default:
        return "Trạng thái đơn hàng";
    }
  }

  void navigateToScreenBasedOnStatus(Booking booking) {
    BookingStatus status = booking.status!;
    switch (status) {
      case BookingStatus.finished:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return BookingDetailsForHelperScreen(booking: booking);
        }));
        break;
      case BookingStatus.upcoming:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return BookingDetailsForHelperScreen(booking: booking);
        }));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        for (int i = 0; i < widget.listBookings.length; i++)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        navigateToScreenBasedOnStatus(widget.listBookings[i]);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //avatar
                                AvatarWidget(
                                    imagePath:
                                        widget.listBookings[i].serviceIcon),
                                const SizedBox(width: 16),
                                //Info
                                InfoBooking(
                                  jobName: widget.listBookings[i].serviceName,
                                  date: DateFormat('d/MM/yyyy')
                                      .format(widget.listBookings[i].workDate),
                                  time: widget.listBookings[i].workTime
                                      .to24hours(),
                                  price:
                                      widget.listBookings[i].formatPriceInVND(),
                                ),
                              ],
                            ),
                            const Divider(
                              color: ColorPalette.greyColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: getColorForStatus(
                                        widget.listBookings[i].status!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    getStringForStatus(
                                        widget.listBookings[i].status!),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                ),
                                if (widget.listBookings[i].status ==
                                    BookingStatus.finished)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: ColorPalette.mainColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Đặt lại",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}