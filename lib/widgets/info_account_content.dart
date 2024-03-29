import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/models/account.dart';
import 'package:iclean_mobile_app/services/api_account_repo.dart';
import 'package:iclean_mobile_app/view/common/notification/notification_screen.dart';
import 'package:iclean_mobile_app/view/common/profile/location/location_screen.dart';
import 'package:iclean_mobile_app/widgets/location_dialog.dart';
import 'package:iclean_mobile_app/widgets/shimmer_loading.dart';

class InfoAccountContent extends StatelessWidget {
  const InfoAccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    Future<Account> fetchAccount() async {
      final ApiAccountRepository apiAccountRepository = ApiAccountRepository();
      try {
        final account = await apiAccountRepository.getAccount(context);
        return account;
      } catch (e) {
        throw Exception(e);
      }
    }

    void showLocationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const LocationDialog(),
      );
    }

    return FutureBuilder(
      future: fetchAccount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const ShimmerLoadingWidget.circular(height: 48, width: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ShimmerLoadingWidget.rectangular(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 16,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                ShimmerLoadingWidget.rectangular(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  height: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.notifications_sharp,
                color: Colors.white,
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final account = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (account.defaultAddress == '') {
              showLocationDialog(context);
            }
          });

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(account.avatar),
                    radius: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LocationScreen()));
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    (account.defaultAddress == '')
                                        ? "Bạn vẫn chưa cập nhật vị trí"
                                        : account.defaultAddress,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      color: (account.defaultAddress == '')
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
                child: const Icon(
                  Icons.notifications_sharp,
                  color: Colors.white,
                ),
              )
            ],
          );
        }
        return const Divider();
      },
    );
  }
}
