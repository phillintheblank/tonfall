package tonfall.format.wav
{
	import flash.utils.ByteArray;
	/**
	 * @author aM
	 */
	public interface IWavDecoderStrategy
	{
		function supports( decoder: WavDecoder ): Boolean;
		
		function read( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void;
	}
}
