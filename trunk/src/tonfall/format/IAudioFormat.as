package tonfall.format
{
	import flash.utils.ByteArray;
	/**
	 * @author aM
	 */
	public interface IAudioFormat
	{
		function getNumSamples( targetRate: Number = 44100.0 ): Number;
		
		function extract( target : ByteArray, length : Number, startPosition : Number ) : Number;
	}
}