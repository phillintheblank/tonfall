package tonfall.format
{
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public interface IAudioIOStrategy
	{
		/**
		 * @return true, if strategy can read decoder format information
		 */
		function readableFor( decoder: AbstractAudioDecoder ): Boolean;
		
		/**
		 * Reads audio data from source format and write audio data in Flashplayer format (44100Hz,Stereo,Float)
		 * 
		 * @param decoder WavDecoder providing all wav header information
		 * @param target The ByteArray to write the audio data
		 * @param length How many samples must be written
		 * @param startPosition position, where to start reading
		 */
		function readData( decoder: AbstractAudioDecoder, target : ByteArray, length : Number, startPosition : Number ) : void;

		/**
		 * Writes format tag
		 * @param bytes ByteArray to write the format tag
		 */
		function writeFormatTag( bytes: ByteArray ): void;

		/**
		 * Reads audio data in Flashplayer format (44100Hz,Stereo,Float) and writes audio data to target format
		 * 
		 * @param data ByteArray with incoming audio data in Flashplayer format
		 * @param target ByteArray to write the data in target format
		 * @param numSamples Number of samples to process 
		 */
		function write32BitStereo44KHz( data: ByteArray, target: ByteArray, numSamples: uint ): void;
		
		/**
		 * @return blockAlign
		 */
		function get blockAlign(): uint;
	}
}
