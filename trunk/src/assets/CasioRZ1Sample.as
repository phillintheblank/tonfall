package assets
{
	import flash.utils.ByteArray;

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
	public final class CasioRZ1Sample extends WavSample
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

		public static const BASSDRUM: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_BASSDRUM() );
		public static const RIMSHOT: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_RIMSHOT() );
		public static const SNAREDRUM: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_SNAREDRUM() );
		public static const CLAP: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_CLAP() );
		public static const COWBELL: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_COWBELL() );
		public static const CRASH: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_CRASH() );
		public static const RIDE: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_RIDE() );
		public static const HIGHHAT_CLOSED: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_HIGHHAT_CLOSED() );
		public static const HIGHHAT_OPEN: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_HIGHHAT_OPEN() );
		public static const TOM_HIGH: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_TOM_HIGH() );
		public static const TOM_MID: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_TOM_MID() );
		public static const TOM_LOW: CasioRZ1Sample = new CasioRZ1Sample( new CLASS_TOM_LOW() );
		
		public static const LIST: Vector.<CasioRZ1Sample> = new Vector.<CasioRZ1Sample>( 12, true );
		
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
		
		public function CasioRZ1Sample( bytes: ByteArray )
		{
			super( bytes );
		}
	}
}