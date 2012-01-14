# Coffee Prototype

## Espresso

Everything in `/espresso` has been compiled with the Adobe Flex 4 SDK and the FlashPunk 1.6 library targeting Adobe Flash Player 10.0.0 with `/espresso/src/Espresso.as` as the default application using the following compiler arguments: "`-locale en_US -default-size 320 480`".

### Controls

- **Fill** 		`Space`	`Z`
- **New Stage** `Enter`	`N`

## Prototype

Everything in `/prototype` has been compiled with the Adobe Flex 4 SDK and the FlashPunk 1.6 library targeting Adobe Flash Player 10.0.0 with `/prototype/src/Coffee.as` as the default application using the following compiler arguments: "`-locale en_US`".

### Controls

- **Fill** 		`X`

## Waveform Generator

Okay, this is where shit gets weird. I made this bitch with Flex, and it's all kinda' crazy. I guess it's best just to run the binaries, but I think there's enough stuff in there to be able to compile it with FlashBuilder.

### Functionality

- Waveform Grid
	- Double-click a cell to edit it.
	- Click `+` to add a waveform.
	- Click `-` to delete the currently selected waveform.
	- *Note: The first waveform in the graph is the "pour effect" waveform. It's best not to delete this one.*
- Click `Generate Waveform` to generate the current waveform...
- Options
	- Wave Speed controls the speed of an animated wave.
	- Step Size controls the draw step size of the wave (in pixels).
	- Animated determines if the wave is animated.
- Click and hold on the animated wave to "pour" into it. Sweet!