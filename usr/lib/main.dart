import "package:flutter/material.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Car Controller",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const CarControllerScreen(),
    );
  }
}

class CarControllerScreen extends StatefulWidget {
  const CarControllerScreen({super.key});

  @override
  State<CarControllerScreen> createState() => _CarControllerScreenState();
}

class _CarControllerScreenState extends State<CarControllerScreen> {
  // State variables mirroring the C# script's functionality
  int _currentGear = 1;
  final int _maxGears = 6;
  double _clutchInput = 0.0;
  double _throttleInput = 0.0;
  double _brakeInput = 0.0;
  double _steerInput = 0.0;
  bool _lightsOn = false;
  bool _handbrakeOn = false;

  void _shiftUp() {
    setState(() {
      if (_currentGear < _maxGears) {
        _currentGear++;
      }
    });
  }

  void _shiftDown() {
    setState(() {
      if (_currentGear > 1) {
        _currentGear--;
      }
    });
  }

  void _honkHorn() {
    // In a real app, this would play a sound.
    // For this UI demo, we can show a snackbar.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("HONK! HONK!"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Controller Interface"),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Steering
            _buildControlSection(
              "Steering",
              Slider(
                value: _steerInput,
                min: -1.0,
                max: 1.0,
                divisions: 20,
                label: _steerInput.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _steerInput = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // Pedals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildControlSection(
                    "Throttle",
                    Slider(
                      value: _throttleInput,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (value) {
                        setState(() {
                          _throttleInput = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildControlSection(
                    "Brake",
                    Slider(
                      value: _brakeInput,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (value) {
                        setState(() {
                          _brakeInput = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Gears
            _buildControlSection(
              "Gears",
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.arrow_downward), onPressed: _shiftDown),
                  Text("$_currentGear", style: Theme.of(context).textTheme.headlineMedium),
                  IconButton(icon: const Icon(Icons.arrow_upward), onPressed: _shiftUp),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(_lightsOn ? Icons.lightbulb : Icons.lightbulb_outline),
                  label: Text(_lightsOn ? "Lights ON" : "Lights OFF"),
                  onPressed: () => setState(() => _lightsOn = !_lightsOn),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _lightsOn ? Colors.yellow.shade700 : null,
                    foregroundColor: _lightsOn ? Colors.black : null,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.local_parking),
                  label: Text(_handbrakeOn ? "Handbrake ON" : "Handbrake OFF"),
                  onPressed: () => setState(() => _handbrakeOn = !_handbrakeOn),
                   style: ElevatedButton.styleFrom(
                    backgroundColor: _handbrakeOn ? Colors.red.shade700 : null,
                  ),
                ),
                 ElevatedButton.icon(
                  icon: const Icon(Icons.pedal_bike), // No great clutch icon
                  label: Text(_clutchInput > 0 ? "Clutch IN" : "Clutch OUT"),
                  onPressed: () => setState(() => _clutchInput = _clutchInput > 0 ? 0.0 : 1.0),
                   style: ElevatedButton.styleFrom(
                    backgroundColor: _clutchInput > 0 ? Colors.blue.shade700 : null,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.campaign),
                  label: const Text("Horn"),
                  onPressed: _honkHorn,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Debug Display
            _buildDebugDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlSection(String title, Widget control) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        control,
      ],
    );
  }

  Widget _buildDebugDisplay() {
    final debugStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: "monospace");
    String handbrakeStatus = _handbrakeOn ? "ON" : "OFF";
    String lightsStatus = _lightsOn ? "ON" : "OFF";
    
    String debugString = 
        "G: $_currentGear | "
        "Cl: ${_clutchInput.toStringAsFixed(1)} | "
        "Th: ${_throttleInput.toStringAsFixed(1)} | "
        "Br: ${_brakeInput.toStringAsFixed(1)} | "
        "St: ${_steerInput.toStringAsFixed(1)} | "
        "HB: $handbrakeStatus | "
        "Lights: $lightsStatus";

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Text(
        debugString,
        style: debugStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
