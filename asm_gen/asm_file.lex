%namespace     AsmGen

base16         [0-9][0-9a-f]*h
base10         [+\-][0-9]+
base2          [0-1]+b
%%
def                       return (int)Tokens.Def;
is                        return (int)Tokens.Is;
rule                      return (int)Tokens.Rule;
operator                  return (int)Tokens.Operator;
code                      return (int)Tokens.Code;
target                    return (int)Tokens.Target;
\!                        return (int)Tokens.Not;
\&                        return (int)Tokens.And;
\|                        return (int)Tokens.Or;
imm                       return (int)Tokens.Imm;
{base16}|{base10}|{base2} yylval=yytext; return (int)Tokens.ImmValue;
\(                        return (int)Tokens.LBracket;
\)                        return (int)Tokens.RBracket;
\[                        return (int)Tokens.LSBracket;
\]                        return (int)Tokens.RSBracket;
\{                        return (int)Tokens.LCBracket;
\}                        return (int)Tokens.RCBracket;
\+                        return (int)Tokens.Add;
\-                        return (int)Tokens.Sub;
\*                        return (int)Tokens.Mul;
\:                        return (int)Tokens.Colon;
,                         return (int)Tokens.Comma;
\n                        return (int)Tokens.NewLine;
[:IsWhiteSpace:]          continue;
[a-z][a-z0-9]*            yylval=yytext; return (int)Tokens.Id;
%%