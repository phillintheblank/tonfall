package
{
	import test.matrix.MatrixModel;
	import test.matrix.MatrixView;

	import flash.display.Sprite;

	/**
	 * @author aM
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="512", height="512")]
	public final class Test extends Sprite
	{
		public function Test()
		{
			const view: MatrixView = new MatrixView();
			addChild( view );
			
			view.model = new MatrixModel( 16, 8 );
		}
	}
}
