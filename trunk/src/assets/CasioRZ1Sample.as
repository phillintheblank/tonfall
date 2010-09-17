package assets
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
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
		
		private var _bytes: ByteArray;
		private var _compression : int;
		private var _numChannels : int;
		private var _rate : int;
		private var _bytesPerSecond : int;
		private var _blockAlign : int;
		private var _bits : int;
		private var _numSignals: uint;
		private var _dataOffset: uint;

		public function CasioRZ1Sample( bytes: ByteArray )
		{
			_bytes = bytes;

			init();
		}
		
		public function extract( target: ByteArray, length: Number, position: Number ) : Number
		{
			if( position >= _numSignals )
				return 0.0;

			if( position + length > _numSignals )
			{
				length = _numSignals - position;
			}

			_bytes.position = _dataOffset + position * _blockAlign;
			
			// TODO SWITCH THROUGH ALL WAV SETTINGS AND CALL DIFFERENT READERS
			read16Bit44KhzMono( target, _bytes, length );

			return length;
		}

		private function read16Bit44KhzMono( target: ByteArray, bytes: ByteArray, length: Number ) : void
		{
			var value: Number;
			
			for( var i: int = 0 ; i < length ; ++i )
			{
				value = bytes.readShort() * 3.051850947600e-05;
				
				target.writeFloat( value );
				target.writeFloat( value );
			}
		}
		
		private function init(): void
		{
			_bytes.position = 0;
			_bytes.endian = Endian.LITTLE_ENDIAN;

			if( _bytes.readUTFBytes( 4 ) != 'RIFF' )
				throw new Error( 'Unknown Format (Not RIFF).' );

			if( _bytes.length != _bytes.readUnsignedInt( ) + 8 )
				throw new Error( 'Length does not match.' );

			if( _bytes.readUTFBytes( 4 ) != 'WAVE' )
				throw new Error( 'Unknown Format (Not WAVE).' );

			var id : String;
			var length : uint;
			var position : uint;

			while( _bytes.bytesAvailable )
			{
				id = _bytes.readUTFBytes( 4 );
				length = _bytes.readUnsignedInt( );
				position = _bytes.position;
				
				switch( id )
				{
					case 'fmt ':
						_compression = _bytes.readUnsignedShort( );
						_numChannels = _bytes.readUnsignedShort( );
						_rate = _bytes.readUnsignedInt( );
						_bytesPerSecond = _bytes.readUnsignedInt( );
						_blockAlign = _bytes.readUnsignedShort( );
						_bits = _bytes.readUnsignedShort( );
						_bytes.position = position + length;
						break;

					case 'data':

						_dataOffset = position;
						_numSignals = length / _blockAlign;
						
						_bytes.position = position + length;
						break;

					default:

						_bytes.position = position + length;
						break;
				}
			}
		}
		
		public function toString(): String
		{
			return '[CasioRZ1Sample compression: ' + _compression +
								', numChannels: ' + _numChannels +
								', rate: ' + _rate +
								', bytesPerSecond: ' + _bytesPerSecond +
								', blockAlign: ' + _blockAlign +
								', bits: ' + _bits +
								', numSignals: ' + _numSignals +
								']';
		}
	}
}
