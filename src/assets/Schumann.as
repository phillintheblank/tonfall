package assets
{
	import tonfall.format.midi.MidiFormat;

	/**
	 * Kreisleriana, Opus 16 (1838)
	 * 
	 * @author Robert Schumann
	 */
	public final class Schumann
	{
		[ Embed( source='../../assets/midi/schumann.mid', mimeType='application/octet-stream' ) ]
			private static const MIDI_CLASS: Class;
		
		public static const MIDI: MidiFormat = MidiFormat.decode( new MIDI_CLASS() );
	}
}
