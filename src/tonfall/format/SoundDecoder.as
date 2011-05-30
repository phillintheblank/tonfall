package tonfall.format
{
	import flash.media.Sound;
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class SoundDecoder extends Sound
		implements IAudioDecoder
	{
		// Compensate encoder delay (LAME 3.98.2 + flash.media.Sound Delay)
		public static const MP3_LAME_OFFSET : Number = 2257.0;

		private var _decodeOffset : Number;

		public function SoundDecoder( decodeOffset: Number = 0.0 )
		{
			_decodeOffset = decodeOffset;
		}

		override public function extract( target : ByteArray, length : Number, startPosition : Number = -1.0 ) : Number
		{
			return super.extract( target, length, startPosition + _decodeOffset );
		}

		public function get numSamples() : Number
		{
			return length * 44.1;
		}
	}
}