package assets
{
	import tonfall.format.midi.MidiFormat;

	/**
	 * @author Unknown
	 */
	public final class BubbleBobble
	{
		[ Embed( source='../../assets/midi/BBtheme.mid', mimeType='application/octet-stream' ) ]
			private static const MIDI_CLASS: Class;
		
		public static const MIDI: MidiFormat = MidiFormat.decode( new MIDI_CLASS() );
	}
}
