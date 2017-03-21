package 
{

	public class Mathml
	{

		public function Mathml()
		{
		}
		public static function AsciiToMathml(input:String):XML
		{
			var mn:RegExp = /(\d)*(\.)*(\d)+/gi;
			var mo:RegExp = /(\-|\+|\－|\±|\=)/g;
			var space:RegExp = /\s/g;
			var output:String = input.replace(mn,"<mn>$1$2$3</mn>");
			output="<mathml><mrow>"+output+"</mrow></mathml>";
			output = output.replace(space,"");
			output = output.replace(mo,"<mo>$1</mo>");
			output = output.replace(/\*/g,"<mo>·</mo>");
			output = output.replace(/pi/gi,"<mo>π</mo>");
			output = output.replace(/\(|\（|\[|{/g,"<mrow>");
			output = output.replace(/\)|\）|\]|}/g,"</mrow>");
			var msqrt:RegExp = /sqrt</g;
			var k:int = output.match(msqrt).length;
			for (var u:int=0; u<k; u++)
			{
				var i = output.search(msqrt);
				var j = dualAfter(output,i);
				var array:Array = output.split("");
				array.splice(j+1,0,"</msqrt></mrow>");
				output = array.join("");
				output = output.replace("sqrt<","<mrow><msqrt><");
			}
			var sup:RegExp = /\^/g;
			output = output.replace(sup,"<mc></mc>");

			var mi:RegExp = />([a-zA-Z][a-zA-Z0-9]*)/gi;
			output = output.replace(mi,"><mi>$1 </mi>");
			mi = /([a-zA-Z][a-zA-Z0-9]*)</gi;
			output = output.replace(mi,"<mi>$1 </mi><");
			sup = /<mc><\/mc>/g;
			output = output.replace(sup,"\^");
			sup = /\^/;
			while (sup.test (output))
			{
				i = output.search(sup);
				j = dualAfter(output,i);
				array = output.split("");
				array.splice(j+1,0,"</msup>");
				j = dualBefore(output,i);
				array.splice(j,0,"<msup>");
				output = array.join("");
				output = output.replace(sup,"");
			}
			var divide:RegExp = />\/</;
			while (divide.test (output))
			{
				i = output.search(divide);
				j = dualAfter(output,i);
				array = output.split("");
				array.splice(j+1,0,"</mfrac>");
				j = dualBefore(output,i);
				array.splice(j,0,"<mfrac>");
				output = array.join("");
				output = output.replace(divide,"><");
			}
			sup = /<msup><mrow>....[^(]/;//给(1+3)^3打上括号
			while (sup.test (output))
			{
				i = output.search(sup);
				j = dualAfter(output,i);
				array = output.split("");
				array.splice(j-6,0,"<mo>)</mo>");
				array.splice(i+12,0,"<mo>(</mo>");
				output = array.join("");
			}
			sup = /<\/mo><mrow>....[^(]/;//给3*(1+3)打上括号
			while (sup.test (output))
			{
				i = output.search(sup);
				j = dualAfter(output,i);
				array = output.split("");
				array.splice(j-6,0,"<mo>)</mo>");
				array.splice(i+11,0,"<mo>(</mo>");
				output = array.join("");
			}

			mi = /<\/mi><mrow>....[^\[(]/;//给log 2*8打上括号
			while (mi.test (output))
			{
				i = output.search(mi);
				j = dualAfter(output,i);
				array = output.split("");
				array.splice(j-6,0,"<mo>)</mo>");
				array.splice(i+11,0,"<mo>(</mo>");
				output = array.join("");
			}
			sup = /[^)\]]...[^t].<\/mrow><mo>/;//给(1+3)*3打上括号
			while (sup.test (output))
			{
				i = output.search(sup);
				j = dualBefore(output,i + 11);
				array = output.split("");
				array.splice(j+6,0,"<mo>(</mo>");
				array.splice(i+7,0,"<mo>)</mo>");
				output = array.join("");
			}
			 
			return new XML(output);
		}
		static function dualAfter(s:String ,i:int):int
		{//输入^所在的位置
			var preN:int = 0,reN:int = 0;
			var j:int = i;
			while (preN!=reN||preN*reN==0&&j<s.length-1 )
			{
				j++;
				if (s.charAt(j) != "<")
				{
					continue;
				}
				else
				{
					if (s.charAt(j+1)=="/")
					{
						reN++;
					}
					else
					{
						preN++;
					}
				}
			}//找到了配对标签的开头
			while (s.charAt(j)!=">")
			{
				j++;
			}
			return j;
		}
		static function dualBefore(s:String ,i:int):int
		{
			var reN:int = 0,preN:int = 0;
			var j:int = i;
			while (preN!=reN||preN*reN==0&&j>=0 )
			{
				j--;
				if (s.charAt(j) != "<")
				{
					continue;
				}
				else
				{
					if (s.charAt(j+1)=="/")
					{
						reN++;
					}
					else
					{
						preN++;
					}
				}
			}//找到了配对标签的开头
			return j;
		}
	}

}