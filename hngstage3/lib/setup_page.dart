import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hngstage3/models/wallpaper_model.dart';

enum DisplayMode { fit, fill, stretch, tile }

class WallpaperSetupSheet extends StatefulWidget {
  final Wallpaper wallpaper;

  const WallpaperSetupSheet({super.key, required this.wallpaper});

  @override
  State<WallpaperSetupSheet> createState() => _WallpaperSetupSheetState();
}

class _WallpaperSetupSheetState extends State<WallpaperSetupSheet> {
  DisplayMode _selectedMode = DisplayMode.fit;
  bool _autoRotation = true;
  bool _lockWallpaper = false;
  bool _syncAcrossDevices = false;
  bool _isWallpaperActivated = false;
  bool _isSettingWallpaper = false;

  Future<void> _setWallpaper() async {
    if (_isSettingWallpaper) return;

    setState(() {
      _isSettingWallpaper = true;
    });

    try {
      final String assetPath = widget.wallpaper.imagePath;
      final ByteData bytes = await rootBundle.load(assetPath);
      final Uint8List list = bytes.buffer.asUint8List();

      final String tempPath = (await getTemporaryDirectory()).path;
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final File file = File('$tempPath/$fileName');

      await file.writeAsBytes(list);

      int location;
      switch (_selectedMode) {
        case DisplayMode.fit:
          location = WallpaperManager.HOME_SCREEN;
          break;
        case DisplayMode.fill:
          location = WallpaperManager.BOTH_SCREEN;
          break;
        case DisplayMode.stretch:
          location = WallpaperManager.LOCK_SCREEN;
          break;
        case DisplayMode.tile:
          debugPrint("Tile mode is not supported. Falling back to default.");
          location = WallpaperManager.HOME_SCREEN;
          break;
      }

      final bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);

      if (result) {
        setState(() {
          _isWallpaperActivated = true;
        });
        _showSuccessSnackbar();
      } else {
        _showErrorSnackbar();
      }
    } on PlatformException catch (e) {
      debugPrint("Error setting wallpaper: $e");
      _showErrorSnackbar();
    } finally {
      setState(() {
        _isSettingWallpaper = false;
      });
    }
  }

  void _showSuccessSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Wallpaper activated successfully!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 12),
            Text('Failed to set wallpaper.', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSettingsPanel();
  }

  Widget _buildSettingsPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wallpaper Setup',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Configure your wallpaper settings and enable auto-rotation.',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 32),
          _buildSectionCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Activate Wallpaper',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Set the selected wallpaper as your desktop background',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _buildActivationStatusChip(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Display mode',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            child: Column(
              children: [
                _buildRadioOption(
                  title: 'Fit',
                  subtitle: 'Scale to fit without cropping',
                  value: DisplayMode.fit,
                ),
                _buildRadioOption(
                  title: 'Fill',
                  subtitle: 'Scale to fill the entire screen',
                  value: DisplayMode.fill,
                ),
                _buildRadioOption(
                  title: 'Stretch',
                  subtitle: 'Stretch to fill the screen',
                  value: DisplayMode.stretch,
                ),
                _buildRadioOption(
                  title: 'Tile',
                  subtitle: 'Repeat the image to fill the screen',
                  value: DisplayMode.tile,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionCard(
            child: _buildSwitchOption(
              title: 'Auto - Rotation',
              subtitle: 'Automatically change your wallpaper at regular intervals',
              value: _autoRotation,
              onChanged: (val) {
                setState(() => _autoRotation = val);
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Advanced Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            child: Column(
              children: [
                _buildCheckboxOption(
                  title: 'Lock Wallpaper',
                  subtitle: 'Prevent accidental changes',
                  value: _lockWallpaper,
                  onChanged: (val) {
                    setState(() => _lockWallpaper = val!);
                  },
                ),
                _buildCheckboxOption(
                  title: 'Sync Across Devices',
                  subtitle: 'Keep wallpaper consistent on all devices',
                  value: _syncAcrossDevices,
                  onChanged: (val) {
                    setState(() => _syncAcrossDevices = val!);
                  },
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActivationStatusChip() {
    if (_isWallpaperActivated) {
      // Activated Chip
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 16),
            SizedBox(width: 6),
            Text(
              'Activated',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      // Inactive Chip
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.cancel, color: Colors.grey.shade600, size: 16),
            const SizedBox(width: 6),
            Text(
              'Inactive',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: child,
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String subtitle,
    required DisplayMode value,
    bool isLast = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _selectedMode = value),
          child: Row(
            children: [
              Radio<DisplayMode>(
                value: value,
                groupValue: _selectedMode,
                onChanged: (DisplayMode? newValue) {
                  setState(() => _selectedMode = newValue!);
                },
                activeColor: Colors.orange.shade700,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 16,
            thickness: 1,
            color: Colors.grey.shade100,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  Widget _buildSwitchOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 14)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.orange.shade700,
        ),
      ],
    );
  }

  Widget _buildCheckboxOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    bool isLast = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.orange.shade700,
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 16,
            thickness: 1,
            color: Colors.grey.shade100,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 350) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isSettingWallpaper ? null : _setWallpaper,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSettingWallpaper
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text('Save Settings', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
            ),
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSettingWallpaper ? null : _setWallpaper,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isSettingWallpaper
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text('Save Settings', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      }
    });
  }
}
