package tonfall.data
{
	import flash.utils.ByteArray;
	
	/**
	 * http://www-mmsp.ece.mcgill.ca/Documents/AudioFormats/AIFF/Docs/AIFF-C.9.26.91.pdf
	 * 
	 * Pascal-style string, one byte count followed by text bytes followed—when needed— by one pad byte.
	 * The total number of bytes in a pstring must be even.The pad byte is included when the number of
	 * text bytes is even, so the total of text bytes + one count byte + one pad byte will be even.
	 * This pad byte is not reflected in the count.
	 * 
 	 * TODO Test it. I never encountered a AIFF with a compressionName
 	 * 
	 * @author Andre Michelle
	 */
	public function readPString( bytes: ByteArray ): String
	{
		const count: int = bytes.readUnsignedByte();
		
		return bytes.readUTFBytes( count + ( count & 1 ) );
	}
}
