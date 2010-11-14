package tonfall.format.wav
{
	import flash.utils.ByteArray;

	/**
	 * @author aM
	 */
	public interface IWavIOStrategy
	{
		function canDecode( decoder: WavDecoder ): Boolean;
		
		function read( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void;
	}
}
