package  {
	
	public class Jacobi {

		public function Jacobi() {
			// constructor code
		}
 public function Solve ( coeficients:Array, dErr:Number):void
{//用Jacobi迭代法解方程组, dCoef[]系数阵, Y[]向量, iOrder给出方程阶数, dErr给出精度
var iOrder:int=coeficients.length
	var res:Array=[];	//方程解
	var res2:Array=[];	//保存上一阶方程解
	for ( var i:int = 0 ; i < iOrder ; res2 [i++] =  0.0 );	//初始解向量 (0,0...)
	while ( true)
	{
		var bStopIterative:Boolean = true;	
		for ( i= 0; i < iOrder ; ++i)
		{
			var  dSum2:Number = 0;
			for (var j:int  = 0 ; j < iOrder ; j++)
			{//求第二项
				if ( j == i ) continue;
				dSum2 += coeficients[i][j] * res2 [j];
			}
			res[i] = 1/coeficients[i][i] * ( coeficients[i][iOrder+1] - dSum2 );
			
			if ( abs ( res2[i] - res [i] ) > dErr )
				bStopIterative = false;
		}
		
		if ( bStopIterative )
			break;
		for ( i = 0 ; i < iOrder ; i++ )
			res2[ i ] = res[ i ];
	}

}

	}
	
}
