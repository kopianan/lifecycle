import 'package:life_cycle/services/stoppable_service.dart';
import 'package:local_auth/local_auth.dart';

class LocationService extends StoppableService {
  @override
  void start() async {
    super.start();
    print('start subs');

    var _localAuth = LocalAuthentication();

    await _localAuth.authenticate(localizedReason: "res");
  }

  @override
  void stop() {
    super.stop();
    print('stop subs');
  }
}
