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

    public class CodeBlockCollector
    {
        public CodeBlockCollector Clone()
        {
            return this;
        }
        public void Add(ResolvedInvocation ri)
        {

        }
    }

    public class InstantiateParam
    {
        private RuleContext context;
        public RuleContext Context { get => context; set => context = value; }

        private CodeBlockCollector codeBlock;
        public CodeBlockCollector CodeBlock { get => codeBlock; set => codeBlock = value; }

    }

    public interface RuleContextUpdater
    {
        RuleContext UpdateContext(RuleContext context);
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

        private Rule precondition;
        private RuleContextUpdater preUpdater;
        private RuleContextUpdater innerUpdater;
        private RuleContextUpdater postUpdater;

        public Function(string name, FormalParameter[] parameters, Invocation[] body)
            : base(name, CodeType)
        {
            //Signature = signature;
            //FunctionTypes = definedTypes;
            Body = body;
        }

        public bool Verify(RuleContext context)
        {

        }

        public bool TryInstantiate(InstantiateParam parameter)
        {
            if (!precondition.Verify(parameter.Context))
            {
                return false;
            }
            RuleContext context = preUpdater.UpdateContext(parameter.Context);
            InstantiateParam innerParameter = new InstantiateParam() { CodeBlock = parameter.CodeBlock, Context = context };
            foreach (Invocation i in Body)
            {
                bool innerInstantiateResult = i.TryInstantiate(innerParameter);
                if (!innerInstantiateResult)
                {
                    return false;
                }
            }
            parameter.CodeBlock = innerParameter.CodeBlock;
            parameter.Context = postUpdater.UpdateContext(innerParameter.Context);
            return true;
        }
    }

    public class FunctionResolveScope
    {
        private IEnumerable<Function> FindFunctions(string name, int paramCount)
        {
            return null;
        }

        private 
        public Function FindFunction(string name, Expr[] parameters, RuleContext context)
        {
            return null;
        }
    }

    public class ResolvedInvocation
    {
        private Function function;
        public Function InvokedFunction { get => function; set => function = value; }

        private Expr[] actualParameters;
        public Expr[] ActualParameters { get => actualParameters; set => actualParameters = value; }


    }

    public class Invocation
    {
        private FunctionResolveScope scope;
        private string functionName;
        public string FunctionName { get => functionName; set => functionName = value; }

        private Expr[] actualParameters;
        public Expr[] ActualParameters { get => actualParameters; set => actualParameters = value; }

        public Invocation(string func, Expr[] parameters)
        {
            FunctionName = func;
            ActualParameters = parameters;
        }

        public bool TryInstantiate(InstantiateParam parameter)
        {
            Function func = FindMostSuitableFunction(scope.FindFunctions(functionName).Where(f => f.Signature.Parameters.Length == actualParameters.Length), parameter.Context);
            return func.TryInstantiate(parameter);
        }
    }

    public class RuleContext
    {
        RuleContext Clone()
        {
            throw new NotImplementedException();
        }
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

        public bool IsTarget()
        {
            return true;
        }

        public IEnumerable<Expr> ReplacableTarget()
        {
            throw new NotImplementedException();
        }

        public Rule AssociatedRule()
        {
            throw new NotImplementedException();
        }
    }

    public class UdtExpr
        : Expr
    {
        private UserDefinedType type;
        public UdtExpr(UserDefinedType udt)
        {
            type = udt;
        }

        public Rule AssociatedRule()
        {
            throw new NotImplementedException();
        }

        public UserDefinedType GetExprType()
        {
            throw new NotImplementedException();
        }

        public bool IsTarget()
        {
            return type.IsTargetType;
        }

        public IEnumerable<Expr> ReplacableTarget()
        {
            throw new NotImplementedException();
        }
    }
}
