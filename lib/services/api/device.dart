import 'package:entrance_tricks/services/api/api.dart';
import 'package:entrance_tricks/utils/device/device.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:entrance_tricks/utils/utils.dart';

class DeviceService {
  final ApiClient apiClient = ApiClient();

  Future<void> registerDevice() async {
    final device = await UserDevice.getDeviceInfo();
    final response = await apiClient.post(
      '/auth/device/',
      data: {
        'device_id': device.id,
        'os': device.os,
        'name': device.name,
        'model': device.model,
        'manufacturer': device.manufacturer,
        'device': device.device,
        'brand': device.brand,
      },

      authenticated: true,
    );
    logger.i(response.data);
    if (response.statusCode == 201) {
      return;
    }

    throw ApiException("Failed to register device");
  }
}
