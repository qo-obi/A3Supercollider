README.txt

A3 : LIVE CODING
by Arushi, Shubhangini, Rahul, Siddharth, Saudharam and Kanishk 



Hello ! Thank you for your guidance throughout the last 6 weeks :)
We, too, wish the class could've carried on for the course of a year. 



I. Task : To demonstrate understanding of Basics of Programming 
using SuperCollider and Python


II. Vision : To recreate an electronic song using environmental soundscapes 


III. Execution : 



# Division of Labour : 

Shubhangini and Arushi : Sound Synthesis
Siddharth and Saudharam : Sound Recording and Buffer Allocation
Kanishk and Rahul : Python OSC and Data Sonification

We then took turns reviewing and manipulating the sound using Ndef methods of Live Coding. 



# Data Sonification using Python


How it works:

In the code, Fast Fourier Transform (FFT) is used to break down an audio recording of environmental sounds into different frequency parts. 

The audio signal is converted from time domain into the frequency domain. 

The code separates these frequencies into three ranges: low (20-300 Hz), mid (300-2000 Hz), and high (above 2000 Hz). It does this by filtering the results to only include values within these ranges, creating three separate signals.

Then, it uses the inverse FFT to convert these signals back into the time domain, isolating the low, mid, and high parts of the sound. 

Finally, it plots these parts, showing how each frequency range contributes to the overall sound. This helps us see and understand which frequencies are most present in the soundscape.

Using these, we were able to tell what sounds should be used for what instruments.




# Synths chosen for our sound synthesis:

Drum : Plays a buffer of a Door slamminh with a low-pass filter and adjustable amplitude. Used for percussive sounds

Zipper Kick: Plays a buffer of a bag zipping with a variable rate and adds randomness

ElectroNotes Synth: A sequence of notes of the song Positif by Mr. Oizo using a saw wave. Melodic content.

AmbientNoise : Plays a buffer of cafeteria ambience with a high-pass filter and adjustable rate. We later added panning and textures to the background sounds.

Each SynthDef is added to the SuperCollider server with the .add method.




# Live Coding


1. Adjusting the Rate of \zipper

The ~setFastRate function to adjust the playback rate of the \zipper SynthDef dynamically


2. Modifying the \drum Ndef

The \drum Ndef is updated to change its amplitude and duration patterns


3. Applying Delay Effect using Comb


4. Reverb and Spectral Modulation

Reverb and spectral modulation effects are applied to the \ambient Ndef. More spatial characterisation of sound as we were experimenting with panning


5. Panning and Chorus Effects













