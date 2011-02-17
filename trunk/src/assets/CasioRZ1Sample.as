package assets
{
	import tonfall.core.WavSample;

	/**
	 * CasioRZ1Sample contains all samples of the Casio RZ1 drumcomputer
	 * 
	 * Info
	 * http://en.wikipedia.org/wiki/Casio_RZ-1
	 * 
	 * Downloaded at
	 * http://machines.hyperreal.org/manufacturers/Casio/RZ-1/samples/tmp/casio-rz1/
	 * 
	 * @author Andre Michelle
	 */
	public final class CasioRZ1Sample
	{
		[ Embed( source='../../assets/casio_rz1/KIRZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_BASSDRUM: Class;
		[ Embed( source='../../assets/casio_rz1/RSRZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_RIMSHOT: Class;
		[ Embed( source='../../assets/casio_rz1/SNRZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_SNAREDRUM: Class;
		[ Embed( source='../../assets/casio_rz1/CLRZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_CLAP: Class;
		[ Embed( source='../../assets/casio_rz1/CBRZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_COWBELL: Class;
		[ Embed( source='../../assets/casio_rz1/CCRZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_CRASH: Class;
		[ Embed( source='../../assets/casio_rz1/CRRZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_RIDE: Class;
		[ Embed( source='../../assets/casio_rz1/HCRZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_HIGHHAT_CLOSED: Class;
		[ Embed( source='../../assets/casio_rz1/HORZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_HIGHHAT_OPEN: Class;
		[ Embed( source='../../assets/casio_rz1/TM1RZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_TOM_HIGH: Class;
		[ Embed( source='../../assets/casio_rz1/TM2RZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_TOM_MID: Class;
		[ Embed( source='../../assets/casio_rz1/TM3RZ.WAV', mimeType='application/octet-stream' ) ]
			private static const CLASS_TOM_LOW: Class;

		public static const BASSDRUM: WavSample = new WavSample( new CLASS_BASSDRUM() );
		public static const RIMSHOT: WavSample = new WavSample( new CLASS_RIMSHOT() );
		public static const SNAREDRUM: WavSample = new WavSample( new CLASS_SNAREDRUM() );
		public static const CLAP: WavSample = new WavSample( new CLASS_CLAP() );
		public static const COWBELL: WavSample = new WavSample( new CLASS_COWBELL() );
		public static const CRASH: WavSample = new WavSample( new CLASS_CRASH() );
		public static const RIDE: WavSample = new WavSample( new CLASS_RIDE() );
		public static const HIGHHAT_CLOSED: WavSample = new WavSample( new CLASS_HIGHHAT_CLOSED() );
		public static const HIGHHAT_OPEN: WavSample = new WavSample( new CLASS_HIGHHAT_OPEN() );
		public static const TOM_HIGH: WavSample = new WavSample( new CLASS_TOM_HIGH() );
		public static const TOM_MID: WavSample = new WavSample( new CLASS_TOM_MID() );
		public static const TOM_LOW: WavSample = new WavSample( new CLASS_TOM_LOW() );
		
		public static const LIST: Vector.<WavSample> = new Vector.<WavSample>( 12, true );
		
		LIST[ 0] = BASSDRUM;
		LIST[ 1] = RIMSHOT;
		LIST[ 2] = SNAREDRUM;
		LIST[ 3] = CLAP;
		LIST[ 4] = COWBELL;
		LIST[ 5] = CRASH;
		LIST[ 6] = RIDE;
		LIST[ 7] = HIGHHAT_CLOSED;
		LIST[ 8] = HIGHHAT_OPEN;
		LIST[ 9] = TOM_HIGH;
		LIST[10] = TOM_MID;
		LIST[11] = TOM_LOW;
	}
}