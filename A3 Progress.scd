/*

File Paths for Buffers ( Shubhi's Laptop )

1. Chair Scraping = "C:/Users/balod/Downloads/chairscraping1.wav"
2. Door Slamming = "C:/Users/balod/Downloads/doorclosing.wav"
3. Cafeteria Ambience = "C:/Users/balod/Downloads/peopletalking.wav"
4. Paytm Machine = "C:/Users/balod/Downloads/paytm.wav"
5. Coffee Machine = "C:/Users/balod/Downloads/coffee.wav"
6. Keyboard Clicking = ""

*/



 ///////    Pre-requisites     ///////

s.boot;

( ~tempo = TempoClock.new; )


 ///////    Buffers     ///////

( ~doorslam = Buffer.read (s, "C:/Users/balod/Downloads/doorclosing.wav"); )
( ~bagzip = Buffer.read (s, "C:/Users/balod/Downloads/bagzip.wav"); )
( ~fan = Buffer.read (s, "C:/Users/balod/Downloads/fan.wav"); )
( ~cafeteria = Buffer.read(s, "C:/Users/balod/Downloads/peopletalking.wav"); )



 ///////    SynthDefs     ///////

(
SynthDef ( \drum, { | bufnum, amp = 0.5, sus = 1 |
    var sound = PlayBuf.ar ( 2, bufnum, loop: 0, doneAction: 2 );
    sound = LPF.ar ( sound, 250 );
    sound = sound * amp;
    Out.ar ( 0, sound!2 );
}).add;
)

(
SynthDef ( \zipper, {
    | bufnum, rate = 4 |
    var sound = PlayBuf.ar ( 1, bufnum, BufRateScale.kr ( bufnum ) * rate, loop: 1 ) * 0.5;
    var chaos = Dust.ar(10) * 0.1;
    Out.ar( 0, sound + chaos );
}).add;
)


(
SynthDef ( \electroNotes, {
    | freq = 440, amp = 0.1, sus = 1 |

    var env = EnvGen.kr ( Env.perc ( 0.01, sus ), doneAction: 2);
    var sig = Saw.ar(freq) * env;
    sig = sig * amp;
    Out.ar( 0, sig!2 );
}).add;
)

SynthDef(\ambientNoise, { | bufnum, amp = 0.3, rate = 1.0 |
    var sound = PlayBuf.ar( 2, bufnum, BufRateScale.kr( bufnum ) * rate, loop: 1 );
	var hpfFreq = LFNoise2.kr ( 0.5 ).range( 50, 300 );
    sound = sound * amp;
	sound = HPF.ar ( sound, hpfFreq );
    Out.ar ( 0, sound );
}).add;



 ///////    Ndefs     ///////

(
Ndef ( \drum, Pbind (
    \instrument, \drum,
    \bufnum, ~doorslam,
    \amp, 1,
	\dur, Pseq ( [ 0, 1 ], inf ),
    \sus, 1
    )
).play ( ~tempo );
)

(
Ndef(\zipper, Pbind(
    \instrument, \zipper,
    \bufnum, ~bagzip,
    \amp, 0.5,
    \sus, 1,
    \rate, 4,
	\rate, rrand(-12, 12).midiratio,
    \dur, Pseq([0.5, 0.5], inf)
)).play ( ~tempo );
)

(
Ndef ( \notes,
    Pbind (
        \instrument, \electroNotes,
        \freq, Pseq ( [ 261.63, 277.18, 246.94,
			233.18, 233.18, 233.18, 246.94,
			261.63, 233.18, 246.94, 246.94,
			261.63, 277.18 ], inf ),

        \amp, Pwhite ( 0.1, 0.5, inf ),
        \sus, 1,
		\rel, 1,
		\drive, Pwhite(0.1, 1.0, inf),
        \dur, Pseq ( [ 0.12, 0.12, 0.24, 0.24,
			0.24, 0.12, 0.12, 0.12, 0.12, 0.12,
			0.12, 0.12, 0.12 ], inf )
    )
).play ( ~tempo );
)

(
Ndef( \ambient,
	Pbind (
		\instrument, \ambientNoise,
		\bufnum, ~cafeteria,
		\amp, 0.3

	)).play;
)




 ///////    Live Coding     ///////

( Ndef ( \notes ).fadeTime_(4).play ( vol: 0.3 ) )

(
~setFastRate = { | rate = 9 |
    Ndef (\zipper).source = {
        var sound = PlayBuf.ar ( 1, ~bagzip, BufRateScale.kr ( ~bagzip ) * rate, loop: 1 ) * 0.5;
        var chaos = Dust.ar (10) * 0.1;
        sound + chaos;
    };
};

~setFastRate.(20);
)

(
Ndef ( \zipper, { |rate = 2| PlayBuf.ar(1, ~bagzip, BufRateScale.kr(~bagzip) * rate, loop: 1) }).play;
)

(
Ndef( \drum ).source = Pbind (
    \instrument, \drum,
    \bufnum, ~doorslam,

    \amp, Pseq([0.5, 0.7, 0.9], inf),
    \dur, Pseq([0.25, 0.25, 0.5], inf)
);
)

(
Ndef( \zipperDelay, { | in | CombC.ar ( Ndef.ar ( \zipper ), 0.3, 0.2, 5 ) }).play;
)

(
Ndef( \ambient ).source = {

    var sound = Ndef.ar ( \ambient );
    var reverbMix = LFNoise2.kr ( 0.1 ).range( 0.1, 0.5 );

    FreeVerb.ar (
		sound, mix: reverbMix,
		room: 0.8, damp: 0.5 )
};
)

(
Ndef ( \spectralMod, {

    var sound = Ndef.ar(\ambient);
    var modFreq = LFNoise1.kr(0.5).range(200, 1000);

    var modulator = SinOsc.ar(modFreq);

    sound = sound * modulator;
    sound;

}).play;
)

(
Ndef ( \pan, {

    var sound = Ndef.ar ( \electroNotes );
    var panPos = LFNoise1.kr(0.5).range(-1, 1);

    Pan2.ar(sound, panPos);

}).play;
)

(
Ndef ( \chorusEffect, {

    var sound = Ndef.ar ( \drum );
    var chorus = GVerb.ar
	(   sound, roomsize: 50,
		revtime: 3, damping: 0.7,
		inputbw: 0.7, earlyreflevel: 0.5,
		taillevel: 0.5 );

	Mix.fill
	( 3, { | i | DelayC.ar ( chorus, 0.3, [ 0.2, 0.25, 0.35 ] [ i ]) });

}).play;
)