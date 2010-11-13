package tonfall.format.wav
{
	import tonfall.core.samplingRate;
	import flash.utils.ByteArray;

	/**
	 * Does not run any interpolation
	 * 
	 * @author aM
	 */
	internal final class WAV16BitMonoAllKhz
		implements IWavDecoderStrategy
	{
		public static const INSTANCE: IWavDecoderStrategy = new WAV16BitMonoAllKhz();   

		public function supports( decoder: WavDecoder ) : Boolean
		{
			return 1 == decoder.compression && 16 == decoder.bits && 1 == decoder.numChannels;
		}
		
		public function read( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const ratio : Number = decoder.rate / samplingRate;
			
			const offset: uint = decoder.dataOffset;
			const blockAlign : int = decoder.blockAlign;
			const bytes: ByteArray = decoder.bytes;
			const bits: int = decoder.bits;

			var targetPosition : Number;

			var amplitude : Number;

			for ( var i : int = 0 ; i < length ; ++i )
			{
				targetPosition = startPosition * ratio;

				bytes.position = offset + int( targetPosition ) * blockAlign;

				if ( 8 == bits )
				{
					amplitude = ( bytes.readUnsignedByte() - 127.5 ) * 0.007843137254902;
				}
				else if ( 16 == bits )
				{
					amplitude = bytes.readShort() * 3.051850947600e-05;
				}
				else if ( 32 == bits )
				{
					amplitude = bytes.readFloat();
				}

				target.writeFloat( amplitude );
				target.writeFloat( amplitude );

				++startPosition;
			}
		}
	}
}
