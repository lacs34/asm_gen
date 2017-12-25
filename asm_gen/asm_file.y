%namespace AsmGen
%using System.IO;
%output=parser.cs
%YYSTYPE object.create($$)
%token Def Is Rule Operator Code Target Not And Or Imm ImmValue LBracket RBracket LSBracket RSBracket LCBracket RCBracket Add Sub Mul Colon Comma NewLine Id
%%
code_block
    :
	| non_empty_block
	;
non_empty_block
    : code_line
	| non_empty_block new_lines code_line         {Console.Output($1);}
	;
code_line
    : function_definition                                        $$ = $1;
	| function_invokation                                        $$ = $1;
	| rule_definitioin                                           $$ = $1;
	| group_definitioin                                          $$ = $1;
	| target_definitioin                                         $$ = $1;
	;
function_invokation
    : Id function_input_list
	;
function_input_list
    :
	| function_input_p1
	| function_input_p1 Comma function_input_list
	;
function_input_p1
    : function_input_p2
	| function_input_p1 Add function_input_p2
	| function_input_p1 Sub function_input_p2
    ;
function_input_p2
    : function_input_p3
    | function_input_p2 Mul function_input_p3
	;
function_input_p3
    : Id
	| ImmValue
	| LSBracket function_input_p1 RSBracket
	;
function_definition
    : group_list Id LBracket parameters RBracket Id LCBracket new_lines code_block RCBracket   $$ = CreateObject(typeof(FunctionSignature), $2, );
    | group_list Id LBracket parameters RBracket LCBracket new_lines code_block RCBracket
	;
group_list
    :
	| non_empty_group_list
	;
non_empty_group_list
    : Id
	| non_empty_group_list Id
	;
parameters
    :
	| non_empty_parameters
	;
non_empty_parameters
    : Id Id
	| non_empty_parameters Comma Id Id
	;
rule_definitioin
    : Rule Id rule_element_list_p1 new_lines
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
    : Def definitioin new_lines
	;
target_definitioin
    : Target definitioin new_lines
	;
definitioin
    : type_list Is Id
	| type_list
	;
type_list
    : Id
	| Id type_list
	;
new_lines
    : NewLine
	| NewLine new_lines
	;
%%
public Parser(Stream file) : base(new Scanner(file)) { }

static object CreateObject(Type objectType, params object[] parameters)
{
    ConstructorInfo constructor = objectType.GetConstructor(parameters.Select(p => p.GetType()).ToArray());
    return constructor.Invoke(parameters);
}

static object ToArray<T>(object source)
{
    IEnumerable<T> isource = (IEnumerable<T>)source;
    return isource.ToArray();
}