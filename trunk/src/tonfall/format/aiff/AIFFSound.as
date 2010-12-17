package tonfall.format.aiff
{
	import tonfall.format.pcm.PCMSound;

	import flash.utils.ByteArray;
	
	public final class AIFFSound extends PCMSound
	{
		public function AIFFSound( bytes: ByteArray, onComplete: Function = null )
		{
			super( bytes, AiffDecoder.parseHeader( bytes ), onComplete );
		}
	}
}