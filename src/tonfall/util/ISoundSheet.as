package tonfall.util
{
	import tonfall.format.IAudioDecoder;

	/**
	 * Defines a sheet of an instrument where keys are stored in a single audio file
	 * 
	 * [Check /load/piano.mp3 for instance]
	 * 
	 * @author Andre Michelle
	 */
	public interface ISoundSheet
	{
		function get numSamplesEachKey(): Number;
		
		function getKeyIndexByNote( note: int ): int;
		
		function getFrequencyByKeyIndex( keyIndex: int ): Number;
		
		function getStartPositionFromKeyIndex( keyIndex: int ): Number;
		
		function getEndPositionFromKeyIndex( keyIndex: int ): Number;
		
		function get decoder(): IAudioDecoder;
	}
}