# NewOrderCodeSequencer

Substitution Cipher MIDI Instrument

//Overview
This project is a unique MIDI instrument inspired by the substitution cipher used by Peter Saville for the band New Order’s iconic Blue Monday 12-inch sleeve design. A video by @DistortThePreamp delves into the details of this cipher, sparking the idea behind this interactive sketch.

In essence, this sketch allows users to type text, which then generates MIDI notes that correspond to each character in the substitution cipher. These notes can be played back in sequence, and the playback speed can be controlled to create unique musical experiences. For a demonstration, check out the project videos on YouTube:

Demo Video 1 - https://www.youtube.com/watch?v=5yWY1nZs_uw

Demo Video 2 - https://www.youtube.com/watch?v=F0nwzTGFUaU

//Getting Started

To use this project, you'll need:
- Processing IDE: The sketch is written in Processing, so you'll need the Processing IDE to run it.
- MIDI Device: This sketch triggers MIDI notes, which requires a Digital Audio Workstation (DAW) or any MIDI-capable software to generate sounds from these notes.

//Setup Instructions

1) Download Processing: Ensure that you have the Processing IDE installed on your machine.
2) Open the Sketch: Load the .pde file into Processing.
3) Run the Sketch: Hit the play button in the Processing IDE to start the sketch. The sketch listens for keyboard input and will generate corresponding MIDI notes.

//Modifying the Code
A few adjustments may be needed based on your setup:

- MIDI Device Name: The script references a specific MIDI device. If you're using a different device, you’ll need to update the device name in the code. To find your device’s name, use the printArray(MidiBus.list()); function within Processing, which will display a list of available devices in the console.
- Playback Speed: This can be modified in the script if you prefer different playback speeds. Refer to the MIDI controller instructions in the code comments.

//Note on Sound Generation
This script solely triggers MIDI notes; to produce sound, a DAW or other MIDI-enabled software is required. Connect your MIDI device to your DAW and set up an instrument channel to hear the notes played by the sketch.

//Fair Use and Attribution
This project is shared under the MIT license for non-commercial use. Feel free to use and modify this code, but please credit the original author. Be kind and share any improvements or creative adaptations you make!

