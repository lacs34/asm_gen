%namespace AsmGen
%using System.IO;
%using System.Reflection;
%using System.Linq;
%using AsmGen;
%output=parser.cs
%YYSTYPE object
%token Def Is Rule Operator Code Target Not And Or Imm ImmValue LBracket RBracket LSBracket RSBracket LCBracket RCBracket Add Sub Mul Colon Comma NewLine Id
%%
code_block
    :
	| non_empty_block
	;
non_empty_block
    : code_line
	| non_empty_block new_lines code_line
	;
code_line
    : function_definition                                        {$$ = $1;}
	| function_invokation                                        {$$ = $1;}
	| rule_definitioin                                           {$$ = $1;}
	| group_definitioin                                          {$$ = $1;}
	| target_definitioin                                         {$$ = $1;}
	;
function_invokation
    : Id function_input_list
	;
function_input_list
    :
	| function_input_p1                                          {$$ = CreateList((Expr)$1);}
	| function_input_list Comma function_input_p1                {$$ = AddIntoList<Expr>($1, (Expr)$3);}
	;
function_input_p1
    : function_input_p2                                          {$$ = $1;}
	| function_input_p1 Add function_input_p2
	| function_input_p1 Sub function_input_p2
    ;
function_input_p2
    : function_input_p3                                          {$$ = $1;}
    | function_input_p2 Mul function_input_p3
	;
function_input_p3
    : Id                                                         {$$ = new UdtExpr(FindType((string)$1));}
	| ImmValue                                                   {$$ = new ImmediateExpr((string)$1);}
	| LSBracket function_input_p1 RSBracket
	;
function_definition
    : Def Id Id LBracket parameters RBracket group_list LCBracket new_lines code_block RCBracket      {Function func = new Function((string)$3, ((IList<FormalParameter>)$5).ToArray(), $10); $$ = func; userDefinedTypes.Pop(); functions.Pop(); DefineFunction(func);}
    | Def Id LBracket parameters RBracket group_list LCBracket new_lines code_block RCBracket         {Function func = new Function((string)$3, ((IList<FormalParameter>)$5).ToArray(), $10); $$ = func; userDefinedTypes.Pop(); functions.Pop(); DefineFunction(func);}
    | Target Id Id LBracket parameters RBracket group_list LCBracket new_lines code_block RCBracket   {Function func = new Function((string)$3, ((IList<FormalParameter>)$5).ToArray(), $10); $$ = func; userDefinedTypes.Pop(); functions.Pop(); DefineFunction(func);}
    | Target Id LBracket parameters RBracket group_list LCBracket new_lines code_block RCBracket
	;
group_list
    :                                                                                                 {$$ = Array.Empty<UserDefinedType>(); userDefinedTypes.Push(new Dictionary<string, UserDefinedType>());}
	| non_empty_group_list                                                                            {$$ = $1; userDefinedTypes.Push(new Dictionary<string, UserDefinedType>());}
	;
non_empty_group_list
    : Id                                                                                              {$$ = CreateList<UserDefinedType>(FindType((string)$1));}
	| non_empty_group_list Id                                                                         {List<UserDefinedType> types = (List<UserDefinedType>)$1; types.Add(FindType((string)$2)); $$ = types;}
	;
parameters
    :                                                                                                 {$$ = Array.Empty<FormalParameter>();}
	| non_empty_parameters                                                                            {$$ = $1;}
	;
non_empty_parameters
    : Id Id                                                                                           {$$ = CreateList<FormalParameter>(new FormalParameter(FindType((string)$1), (string)$2));}
	| non_empty_parameters Comma Id Id                                                                {List<FormalParameter> types = (List<FormalParameter>)$1; types.Add(new FormalParameter(FindType((string)$3), (string)$4)); $$ = types;}
	;
rule_definitioin
    : Rule Id rule_element_list_p1
	;
rule_element_list_p1
    : rule_element_list_p2
	| rule_element_list_p1 Or rule_element_list_p2
	;
rule_element_list_p2
    : rule_element_list_p3
	| rule_element_list_p2 And rule_element_list_p3
	;
rule_element_list_p3
    : Id
	| Not rule_element_list_p3
	| LBracket rule_element_list_p1 RBracket
	;
group_definitioin
    : Def definitioin                                  {TypeDefinition td = (TypeDefinition)$2; DefineTypes(td.DefinedTypeNames.Select(u => new UserDefinedType(u, td.Parent, false)));}
	;
target_definitioin
    : Target definitioin                               {TypeDefinition td = (TypeDefinition)$2; DefineTypes(td.DefinedTypeNames.Select(u => new UserDefinedType(u, td.Parent, true)));}
	;
definitioin
    : type_list Is Id                                  {$$ = new TypeDefinition((List<string>)$1, FindType((string)$3));}
    | type_list                                        {$$ = new TypeDefinition((List<string>)$1, null);}
	;
type_list
    : Id                                               {$$ = CreateList<string>((string)$1);}
    | type_list Comma Id                               {$$ = AddIntoList<string>($1, (string)$3);}
	;
new_lines
    : NewLine
    | NewLine new_lines
	;
%%
public Parser(Stream file) : base(new Scanner(file)) { }

Stack<Dictionary<string, UserDefinedType>> userDefinedTypes = new Stack<Dictionary<string, UserDefinedType>>();
public UserDefinedType FindType(string name)
{
    foreach (Dictionary<string, UserDefinedType> frame in userDefinedTypes)
    {
        UserDefinedType type = null;
        bool findResult = frame.TryGetValue(name, out type);
        if (findResult)
        {
            return type;
        }
    }
    throw new Exception("Type " + name + " not find.");
}
public void DefineTypes(IEnumerable<UserDefinedType> types) {
    Dictionary<string, UserDefinedType> topFrame = userDefinedTypes.Peek();
    foreach (UserDefinedType type in types)
	{
	    topFrame[type.Name] = type;
	}
}
public List<T> CreateList<T>(T element) {
    List<T> lst = new List<T>();
	lst.Add(element);
	return lst;
}
public List<T> AddIntoList<T>(object obj, T element) {
    List<T> lst = (List<T>)obj;
	lst.Add(element);
	return lst;
}

Stack<Dictionary<string, Function>> functions = new Stack<Dictionary<string, Function>>();
public Function FindFunction(string name)
{
    foreach (Dictionary<string, Function> frame in functions)
    {
        Function type = null;
        bool findResult = frame.TryGetValue(name, out type);
        if (findResult)
        {
            return type;
        }
    }
    throw new Exception("Function " + name + " not find.");
}
public void DefineFunction(Function func) {
    Dictionary<string, Function> topFrame = functions.Peek();
	topFrame[func.Name] = func;
}