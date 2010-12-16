package tonfall.format.aiff
{
	import tonfall.format.pcm.PCMEncoder;
	import tonfall.data.IeeeExtended;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * @author Andre Michelle
	 */
	public final class AiffEncoder extends PCMEncoder
	{
		private var _nsao: uint; // store numSamples offset for writing later
		private var _dtlo: uint; // store ssnd tag offset for writing later
		
		public function AiffEncoder( strategy : IAudioIOStrategy )
		{
			super( strategy );
		}
		
		override protected function writeHeader( bytes: ByteArray ) : void
		{
			bytes.endian = Endian.BIG_ENDIAN;
			
			bytes.writeUTFBytes( AiffTags.FORM );
			bytes.writeUnsignedInt( 0 );
			bytes.writeUTFBytes( AiffTags.AIFF );
			bytes.writeUTFBytes( AiffTags.COMM );
			bytes.writeUnsignedInt( 18 ); 
			bytes.writeShort( strategy.numChannels );
			_nsao = bytes.position;
			bytes.writeUnsignedInt( 0 ); // numSamples
			bytes.writeShort( strategy.bits );
			IeeeExtended.forward( strategy.samplingRate, bytes );
			bytes.writeUTFBytes( AiffTags.SSND );
			_dtlo = bytes.position;
			bytes.writeUnsignedInt( 0 ); // SSND length
		}
		
		override protected function updateHeader( bytes: ByteArray, totalSamples: uint ) : void
		{
			// WRITE FILE SIZE
			bytes.position = 4;
			bytes.writeInt( bytes.length - 8 );

			// WRITE AUDIO SIZE
			bytes.position = _nsao;
			bytes.writeUnsignedInt( totalSamples );
			bytes.position = _dtlo;
			bytes.writeInt( totalSamples * strategy.blockAlign );
		}
	}
}
