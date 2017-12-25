using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace AsmGen
{

    public class FormalParameter
    {
        private UserDefinedType parameterType;
        public UserDefinedType ParameterType { get => parameterType; set => parameterType = value; }

        private string parameterName;
        public string ParameterName { get => parameterName; set => parameterName = value; }

        public FormalParameter(UserDefinedType type, string name)
        {
            ParameterType = type;
            ParameterName = name;
        }
    }

    public class Function
        : UserDefinedType
    {
        public static readonly UserDefinedType CodeType = new UserDefinedType("Code", null);
        private FunctionSignature signature;
        public FunctionSignature Signature { get => signature; set => signature = value; }

        private UserDefinedType[] functionTypes;
        public UserDefinedType[] FunctionTypes { get => functionTypes; set => functionTypes = value; }

        private Invocation[] body;
        public Invocation[] Body { get => body; set => body = value; }

        public Function(string name, FormalParameter[] parameters, Invocation[] body)
            : base(name, CodeType)
        {
            //Signature = signature;
            //FunctionTypes = definedTypes;
            Body = body;
        }
    }

    public class Invocation
    {
        private Function invokedFunction;
        public Function InvokedFunction { get => invokedFunction; set => invokedFunction = value; }

        private Expr[] actualParameters;
        public Expr[] ActualParameters { get => actualParameters; set => actualParameters = value; }

        public Invocation(Function func, Expr[] parameters)
        {
            InvokedFunction = func;
            ActualParameters = parameters;
        }
    }

    public class RuleContext
    {

    }

    public interface Rule
    {
        bool Verify(RuleContext context);
    }

    public interface Expr
    {
        UserDefinedType GetExprType();
        bool IsTarget();
        IEnumerable<Expr> ReplacableTarget();
        Rule AssociatedRule();
    }

    public interface ImmediateExpression
    {

    }

    public class ImmediateExpr
        : Expr
    {
        private int immediateValue;
        public int ImmediateValue { get => immediateValue; set => immediateValue = value; }

        private ImmediateExpression expression;
        public ImmediateExpression Expression { get => expression; set => expression = value; }

        public ImmediateExpr(string valueString)
        {

        }

        public UserDefinedType GetExprType()
        {
            throw new NotImplementedException();
        }
    }

    public class UdtExpr
        : Expr
    {
        public UdtExpr(UserDefinedType udt)
        {

        }

        public UserDefinedType GetExprType()
        {
            throw new NotImplementedException();
        }
    }
}
