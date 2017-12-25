using AsmGen;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace test_asm_gen
{
    class Program
    {
        static void Main(string[] args)
        {
            AsmParser parser = new AsmParser();
            parser.Parse(@"C:\Users\OptaneTester\Documents\Visual Studio 2017\Projects\s\asm_gen\asm_gen\ReadMe.txt");
        }
    }
}
