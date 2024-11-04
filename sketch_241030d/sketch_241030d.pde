import themidibus.*;  // Import the MidiBus library
PFont customFont;
PGraphics overlay;  // Layer for static text

MidiBus midiBus;  // Define a MidiBus object

// Define RGB values for the 10 looping colors (from green to white)
color[] colors = {
  color(94, 136, 102),  // Green
  color(235, 197, 4),   // Yellow
  color(139, 75, 140),
  color(214, 87, 23),
  color(145, 180, 202),
  color(219, 138, 173),
  color(104, 38, 121),
  color(218, 12, 111),
  color(39, 82, 165),
  color(255, 255, 255)  // White
};

// Base MIDI notes for the Decatonic scale in the 4th octave (C4)
int[] baseNotes = { 60, 62, 63, 65, 66, 67, 68, 69, 70, 71 };

// Sequence and playback controls
ArrayList<Character> sequence = new ArrayList<Character>();  // Store sequence of letters
int currentNoteIndex = 0;  // Track current position in sequence
boolean isPlaying = false;  // Playback state
int bpm = 200;  // Default Beats per minute
int interval;  // Interval between notes in milliseconds
int nextPlayTime = 0;  // Next time to play a note in milliseconds

int nextX = 50;
int squareY = 100;  // Adjust this value to control how close to the top the squares are
int squareSize = 50;
int spacing = 10;  // Space between squares
ArrayList<Integer> xPositions = new ArrayList<>();  // Track x-positions of each square for playback indicator

void setup() {
  size(780, 300);
  background(0);
  
  // Load and set a custom font
  customFont = createFont("AvenirLTProMedium.otf", 14);  // Replace with your actual font filename
  textFont(customFont);
  fill(255);  // Set text color to white
  
  // Create the overlay layer for static text
  overlay = createGraphics(width, height);
  drawStaticText();  // Draw static text once in setup
  
  // Initialize MidiBus (choose the appropriate input and output based on your setup)
  MidiBus.list();  // List available MIDI devices in the console
  midiBus = new MidiBus(this, -1, "Bus 1");  // Use "Bus 1" as your MIDI output device

  // Calculate interval in milliseconds based on BPM
  interval = 60000 / bpm;

  println("Setup complete. Type letters to create a sequence, space for spaces, backspace to reset, and '>' to play/pause.");
 

}

void draw() {
  // Playback loop based on millis() instead of frameCount for more accurate timing
  if (isPlaying && millis() >= nextPlayTime) {
    playNoteFromSequence();
    nextPlayTime = millis() + interval;  // Schedule next note
  }
  
  // Draw the static overlay layer with the title, instructions, and link text
  image(overlay, 0, 0);
  
}

void keyPressed() {
  // Space command (adds space to sequence and spacing on screen)
  if (key == ' ' && sequence.size() < 10) {  // Limit sequence to 10 items
    sequence.add(' ');  // Add space to sequence
    nextX += squareSize + spacing;  // Add space without drawing a square
    xPositions.add(nextX);  // Track space position for playback indicator
    return;
  }
  
  // Backspace command - reset function
  if (keyCode == BACKSPACE) {
    resetSketch();
    return;
  }

  // Play/pause toggle with 'P' key
  if (key == '>' || key == '.') {
    isPlaying = !isPlaying;  // Toggle play/pause
    currentNoteIndex = 0;    // Reset to start of sequence
    nextPlayTime = millis(); // Set initial play time
    println(isPlaying ? "Playback started." : "Playback paused.");
    return;
  }

  // BPM adjustment with up and down arrow keys
  if (keyCode == UP) {
    bpm = min(bpm + 10, 900);  // Increase BPM, max 300
    interval = 60000 / bpm;  // Update interval in milliseconds
    println("BPM increased to: " + bpm);
    return;
  } else if (keyCode == DOWN) {
    bpm = max(bpm - 10, 30);  // Decrease BPM, min 30
    interval = 60000 / bpm;  // Update interval in milliseconds
    println("BPM decreased to: " + bpm);
    return;
  }

  // Convert key to uppercase for case-insensitive matching
  char letter = Character.toUpperCase(key);

  // Check if the key is a letter from A-Z and if the sequence has fewer than 11 items
  if (letter >= 'A' && letter <= 'Z' && sequence.size() < 11) {
    int index = letter - 'A';  // Get index based on alphabet position (A=0, B=1, ..., Z=25)
    
    // Add letter to the sequence
    sequence.add(letter);

    // Calculate MIDI note
    int noteIndex = index % 10;  // Position in the Decatonic scale
    int octaveShift = (index / 10) * 12;  // Shift up by an octave for each 10 letters
    int midiNote = baseNotes[noteIndex] + octaveShift;

    // Play MIDI note immediately when typed
    midiBus.sendNoteOn(0, midiNote, 100);
    delay(100);  // Brief delay to hear each note
    midiBus.sendNoteOff(0, midiNote, 100);

    // Render the letter on the screen
    drawSquare(letter, index);
  }
}

// Draws a square based on the letter
void drawSquare(char letter, int index) {
  int colorIndex = index % colors.length;  // Cycles through colors every 10 letters

  // Render single-colored squares for letters A through I
  if (index < 9) {
    fill(colors[colorIndex]);
    noStroke();
    rect(nextX, squareY - squareSize / 2, squareSize, squareSize);
  }
  // Render two-tone squares with green on the bottom for letters J through S
  else if (index >= 9 && index < 19) {
    fill(colors[colorIndex]);  // Top half color from looping array
    noStroke();
    rect(nextX, squareY - squareSize / 2, squareSize, squareSize / 2);

    noStroke();
    fill(colors[0]);  // Green for bottom half
    rect(nextX, squareY, squareSize, squareSize / 2);
    
    stroke(255);  // White dividing line
    strokeWeight(2);
    line(nextX , squareY, nextX + squareSize -1, squareY);
  }
  // Render two-tone squares with yellow on the bottom for letters T through Z
  else {
    fill(colors[colorIndex]);  // Top half color from looping array
    noStroke();
    rect(nextX, squareY - squareSize / 2, squareSize, squareSize / 2);

    noStroke();
    fill(colors[1]);  // Yellow for bottom half
    rect(nextX, squareY, squareSize, squareSize / 2);
    
    stroke(255);  // White dividing line
    strokeWeight(2);
    line(nextX , squareY, nextX + squareSize -1, squareY);
  }
  

  // Draw playback indicator line for the square if playing
  if (isPlaying && currentNoteIndex == sequence.size() - 1) {
    stroke(255, 0, 0);  // Red for indicator
    strokeWeight(2);
    line(nextX, squareY + squareSize / 2 + 5, nextX + squareSize, squareY + squareSize / 2 + 5);
  }
  
  // Draw the character label below the square
  fill(255);  // Set label color to white
  textSize(16);
  text(letter, nextX + squareSize / 2 - 4, squareY + squareSize +5);  // Center text below square


  // Save the x position of each square for playback visualization
  xPositions.add(nextX);

  // Update x position for the next square
  nextX += squareSize + spacing;
}

// Plays a note based on the current position in the sequence
void playNoteFromSequence() {
  // Reset to beginning if end of sequence is reached
  if (currentNoteIndex >= sequence.size()) {
    currentNoteIndex = 0;
  }

  char letter = sequence.get(currentNoteIndex);
  if (letter == ' ') {  // Skip spaces and move to the next position
    currentNoteIndex++;
    return;
  }

  int index = letter - 'A';
  int noteIndex = index % 10;
  int octaveShift = (index / 10) * 12;
  int midiNote = baseNotes[noteIndex] + octaveShift;

  // Send MIDI note on and off (short note)
  midiBus.sendNoteOn(0, midiNote, 100);
  delay(100);  // Brief delay for each note
  midiBus.sendNoteOff(0, midiNote, 100);

  // Draw playback indicator line under the current square
  int indicatorX = xPositions.get(currentNoteIndex);
  fill(0);  // Clear any previous indicator lines
  noStroke();
  rect(0, squareY + squareSize / 2 + 5, width, 10);  // Clear area for indicator
  stroke(255, 255, 255);  // White line for indicator
  strokeWeight(2);
  line(indicatorX, squareY + squareSize / 2 + 5, indicatorX + squareSize, squareY + squareSize / 2 + 5);

  // Move to the next letter
  currentNoteIndex++;
}

void drawStaticText() {
  overlay.beginDraw();
  overlay.background(0, 0);  // Transparent background
  
  // Draw the title and instructions at the bottom of the sketch
  fill(255);
  textSize(14);
  text("New Order Code Sequencer v01", 50, height - 90);  // Position title
  text("Type letters to create a sequence. Press '>' to play/pause, UP/DOWN to adjust speed.\r\nBackspace resets everything.\r\nInspired by https://bit.ly/4fapt4o" , 50, height - 60);
  overlay.endDraw();
}

// Resets the sketch
void resetSketch() {
  background(0);  // Clear the screen
  nextX = 50;  // Reset x position
  sequence.clear();  // Clear the sequence
  xPositions.clear();  // Clear x-positions
  currentNoteIndex = 0;
  isPlaying = false;  // Stop playback if active
  println("Resetting sketch...");
  
  // Redraw static text on reset if neededsks
  drawStaticText();
}
