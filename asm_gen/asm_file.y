%namespace AsmGen
%token Gp8 Gp8x64 Gp16 Gp16x64 Gp32 Gp32x64 Gp64 Gp8Type Gp16Type Gp32Type Gp64Type MType ImmType XmmReg XmmRegx64 YmmReg YmmRegx64 MmReg FpReg ImmValue LBracket RBracket LSBracket RSBracket LCBracket RCBracket Add Sub Mul Id Colon Comma X32Block X64Block NewLine Equal
%%
blocks
    : x32block
	| x64block
	| x32block blocks
	| x64block blocks
	;
x32block
    : X32Block Id LBracket param_list RBracket LCBracket instructionsx32 RCBracket
    | X32Block Id LBracket param_list RBracket new_lines LCBracket instructionsx32 RCBracket
    | X32Block Id LBracket param_list RBracket LCBracket new_lines instructionsx32 RCBracket
    | X32Block Id LBracket param_list RBracket new_lines LCBracket new_lines instructionsx32 RCBracket
    | X32Block Id LBracket param_list RBracket LCBracket instructionsx32 new_lines RCBracket
    | X32Block Id LBracket param_list RBracket new_lines LCBracket instructionsx32 new_lines RCBracket
    | X32Block Id LBracket param_list RBracket LCBracket new_lines instructionsx32 new_lines RCBracket
    | X32Block Id LBracket param_list RBracket new_lines LCBracket new_lines instructionsx32 new_lines RCBracket
	;
x64block
    : X64Block Id LBracket param_list RBracket LCBracket instructionsx64 RCBracket
    | X64Block Id LBracket param_list RBracket new_lines LCBracket instructionsx64 RCBracket
    | X64Block Id LBracket param_list RBracket LCBracket new_lines instructionsx64 RCBracket
    | X64Block Id LBracket param_list RBracket new_lines LCBracket new_lines instructionsx64 RCBracket
    | X64Block Id LBracket param_list RBracket LCBracket instructionsx64 new_lines RCBracket
    | X64Block Id LBracket param_list RBracket new_lines LCBracket instructionsx64 new_lines RCBracket
    | X64Block Id LBracket param_list RBracket LCBracket new_lines instructionsx64 new_lines RCBracket
    | X64Block Id LBracket param_list RBracket new_lines LCBracket new_lines instructionsx64 new_lines RCBracket
	;
param_list
    : LBracket RBracket
	| LBracket params RBracket
	;
params
    : Id
	| Id params
	;
instructionsx32
    : instructionx32
	| instructionx32 new_lines instructionsx32
	;
instructionsx64
    : instructionx64
	| instructionx64 new_lines instructionsx64
	;
instructionx32
    : Id
	| Id Colon
	| Id operandsx32
	| Id param_assigns_listx32
	;
instructionx64
    : Id
	| Id Colon
	| Id operandsx64
	| Id param_assigns_listx64
	;
param_assigns_listx32
    : LBracket RBracket
	| LBracket param_assignsx32 RBracket
	;
param_assigns_listx64
    : LBracket RBracket
	| LBracket param_assignsx64 RBracket
	;
param_assignsx32
    : Id Equal operandx32
	| Id Equal operandx32 Comma param_assignsx32
	;
param_assignsx64
    : Id Equal operandx64
	| Id Equal operandx64 Comma param_assignsx64
	;
operandsx32
    : operandx32
	| operandx32 Comma operandsx32
	;
operandsx64
    : operandx64
	| operandx64 Comma operandsx64
	;
operandx32
    : gpx32
	| memoryx32
	| operand_unknow
	;
operandx64
    : gpx64
	| memoryx64
	| operand_unknow
	| XmmRegx64
	| YmmRegx64
	;
operand_unknow
    : imm
	| XmmReg
	| YmmReg
	| MmReg
	| FpReg
	;
memoryx32
    : LSBracket addressx32 RSBracket
    | LSBracket address_unknow RSBracket
	| MType
	;
memoryx64
    : LSBracket addressx64 RSBracket
    | LSBracket address_unknow RSBracket
	| MType
	;
address_unknow
    : imm
	| regunknow Add imm
	| imm Add regunknow
	| regunknow Add regunknow
	| regunknow Add regunknow Add imm
	| regunknow Add imm Add regunknow
	| imm Add regunknow Add regunknow
	| imm Add regunknow Add imm Mul regunknow
	| imm Add imm Mul regunknow Add regunknow
	| imm Mul regunknow Add imm Add regunknow
	| imm Mul regunknow Add regunknow Add imm
	| regunknow Add imm Mul regunknow Add imm
	| regunknow Add imm Add imm Mul regunknow
	;
addressx32
    : gp32bitx32
    | gp32bitx32 Add imm
    | imm Add gp32bitx32
    | gp32bitx32 Add gp32bitx32
    | gp32bitx32 Add regunknow
    | regunknow Add gp32bitx32
    | gp32bitx32 Add imm Mul gp32bitx32
    | imm Mul gp32bitx32 Add gp32bitx32
    | gp32bitx32 Add imm Mul regunknow
    | imm Mul regunknow Add gp32bitx32
    | imm Mul gp32bitx32 Add regunknow
    | regunknow Add imm Mul gp32bitx32
    | gp32bitx32 Add gp32bitx32 Add imm
    | gp32bitx32 Add imm Add gp32bitx32
    | imm Add gp32bitx32 Add gp32bitx32
    | gp32bitx32 Add regunknow Add imm
    | gp32bitx32 Add imm Add regunknow
    | imm Add gp32bitx32 Add regunknow
    | imm Add regunknow Add gp32bitx32
    | regunknow Add imm Add gp32bitx32
    | regunknow Add gp32bitx32 Add imm
    | gp32bitx32 Add imm Mul gp32bitx32 Add imm
    | gp32bitx32 Add imm Add imm Mul gp32bitx32
    | imm Add gp32bitx32 Add imm Mul gp32bitx32
    | imm Add imm Mul gp32bitx32 Add gp32bitx32
    | imm Mul gp32bitx32 Add imm Add gp32bitx32
    | imm Mul gp32bitx32 Add gp32bitx32 Add imm
    | gp32bitx32 Add imm Mul regunknow Add imm
    | gp32bitx32 Add imm Add imm Mul regunknow
    | imm Add gp32bitx32 Add imm Mul regunknow
    | imm Add imm Mul regunknow Add gp32bitx32
    | imm Mul regunknow Add imm Add gp32bitx32
    | imm Mul regunknow Add gp32bitx32 Add imm
    | imm Mul gp32bitx32 Add regunknow Add imm
    | imm Mul gp32bitx32 Add imm Add regunknow
    | imm Add imm Mul gp32bitx32 Add regunknow
    | imm Add regunknow Add imm Mul gp32bitx32
    | regunknow Add imm Add imm Mul gp32bitx32
    | regunknow Add imm Mul gp32bitx32 Add imm
	;
addressx64
    : gp64bit
    | gp64bit Add imm
    | imm Add gp64bit
    | gp64bit Add gp64bit
    | gp64bit Add regunknow
    | regunknow Add gp64bit
    | gp64bit Add imm Mul gp64bit
    | imm Mul gp64bit Add gp64bit
    | gp64bit Add imm Mul regunknow
    | imm Mul regunknow Add gp64bit
    | imm Mul gp64bit Add regunknow
    | regunknow Add imm Mul gp64bit
    | gp64bit Add gp64bit Add imm
    | gp64bit Add imm Add gp64bit
    | imm Add gp64bit Add gp64bit
    | gp64bit Add regunknow Add imm
    | gp64bit Add imm Add regunknow
    | imm Add gp64bit Add regunknow
    | imm Add regunknow Add gp64bit
    | regunknow Add imm Add gp64bit
    | regunknow Add gp64bit Add imm
    | gp64bit Add imm Mul gp64bit Add imm
    | gp64bit Add imm Add imm Mul gp64bit
    | imm Add gp64bit Add imm Mul gp64bit
    | imm Add imm Mul gp64bit Add gp64bit
    | imm Mul gp64bit Add imm Add gp64bit
    | imm Mul gp64bit Add gp64bit Add imm
    | gp64bit Add imm Mul regunknow Add imm
    | gp64bit Add imm Add imm Mul regunknow
    | imm Add gp64bit Add imm Mul regunknow
    | imm Add imm Mul regunknow Add gp64bit
    | imm Mul regunknow Add imm Add gp64bit
    | imm Mul regunknow Add gp64bit Add imm
    | imm Mul gp64bit Add regunknow Add imm
    | imm Mul gp64bit Add imm Add regunknow
    | imm Add imm Mul gp64bit Add regunknow
    | imm Add regunknow Add imm Mul gp64bit
    | regunknow Add imm Add imm Mul gp64bit
    | regunknow Add imm Mul gp64bit Add imm
	;
regunknow
    : LCBracket Id RCBracket LBracket Id RBracket
	;
imm
    : ImmType
	| ImmValue
	;
gpx32
    : gp8bitx32
	| gp16bitx32
	| gp32bitx32
	;
gpx64
    : gp8bitx64
	| gp16bitx64
	| gp32bitx64
	| gp64bit
	;
gp8bitx32
    : Gp8
	| Gp8Type LBracket Id RBracket
	;
gp8bitx64
    : gp8bitx32
	| Gp8x64
	;
gp16bitx32
    : Gp16
	| Gp16Type LBracket Id RBracket
	;
gp16bitx64
    : gp16bitx32
	| Gp16x64
	;
gp32bitx32
    : Gp32
	| Gp32Type LBracket Id RBracket
	;
gp32bitx64
    : gp32bitx32
	| Gp32x64
	;
gp64bit
    : Gp64
	| Gp64Type LBracket Id RBracket
	;
new_lines
    : NewLine
	| NewLine new_lines
	;