package tonfall.format.wav
{
	import tonfall.format.pcm.PCMEncoder;

	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * @author Andre Michelle
	 */
	public final class WavEncoder extends PCMEncoder
	{
		private var _dtlo: uint; // store data tag length offset for writing later
		public function WavEncoder( strategy: IWAVIOStrategy )
		{
			super( strategy );
		}
		
		/**
		 * @return file extension
		 */
		override public function get fileExt(): String
		{
			return '.wav';
		}
		
		override protected function writeHeader( bytes: ByteArray ) : void
		{
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.writeUnsignedInt( WavTags.RIFF );
			bytes.writeUnsignedInt( 0 );
			bytes.writeUnsignedInt( WavTags.WAVE );
			
			bytes.writeUnsignedInt( WavTags.FMT );
			bytes.writeUnsignedInt( 16 ); // chunk length
			bytes.writeShort( int( strategy.compressionType ) ); // compression
			bytes.writeShort( strategy.numChannels ); // numChannels
			bytes.writeUnsignedInt( strategy.samplingRate ); // samplingRate
			bytes.writeUnsignedInt( strategy.samplingRate * strategy.blockAlign ); // bytesPerSecond
			bytes.writeShort( strategy.blockAlign ); // blockAlign
			bytes.writeShort( strategy.bits ); // bits

			bytes.writeUnsignedInt( WavTags.DATA );
			
			_dtlo = bytes.position;
			
			bytes.writeUnsignedInt( 0 );
		}
		
		override protected function updateHeader( bytes: ByteArray, totalSamples: uint ) : void
		{
			const position: uint = bytes.position;
			
			// WRITE FILE SIZE
			bytes.position = 4;
			bytes.writeUnsignedInt( bytes.length - 8 );

			// WRITE AUDIO SIZE
			bytes.position = _dtlo;
			bytes.writeUnsignedInt( totalSamples * strategy.blockAlign );
			
			// REVERT POSITION
			bytes.position = position;
		}
	}
}
