using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace asm_gen
{
    public class Function
    {
        private FunctionSignature signature;
        public FunctionSignature Signature { get => signature; set => signature = value; }

        private UserDefinedType[] functionTypes;
        public UserDefinedType[] FunctionTypes { get => functionTypes; set => functionTypes = value; }

        private object body;
        public object Body { get => body; set => body = value; }

        public Function(FunctionSignature signature, UserDefinedType[] definedTypes, object body)
        {
            Signature = signature;
            FunctionTypes = definedTypes;
            Body = body;
        }
    }
}
