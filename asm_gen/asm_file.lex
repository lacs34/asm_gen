%namespace     AsmGen


gp8            [abcd][lh]
gp8x64         ([sd]il)|([bs]pl)|(r[89]l)|(r1[0-5]l)
gp16           ([abcd]x)|([sd]i)|([bs]p)
gp16x64        (r[89]w)|(r1[0-5]w)
gp32           e{gp16}
gp32x64        (r[89]d)|(r1[0-5]d)
gp64           (r{gp16})|(r[89])|(r1[0-5])
reg_type       (fp)|(mm)|(xmm)|(ymm)|(imm)|m|(m8)|(m16)|(m32)|(m64)
xmm_regs       xmm[0-7]
xmm_regsx64    xmm([89]|(1[0-5]))
ymm_regs       ymm[0-7]
ymm_regsx64    ymm([89]|(1[0-5]))
mm_regs        mm[0-7]
fp_regs        st\([0-7]\)
base16         [0-9][0-9a-f]*h
base10         [+\-][0-9]+
base2          [0-1]+b
%%
__x32                     return AsmElement.X32Block;
__x64                     return AsmElement.X64Block;
{gp8}                     return AsmElement.Gp8;
{gp8x64}                  return AsmElement.Gp8x64;
{gp16}                    return AsmElement.Gp16;
{gp16x64}                 return AsmElement.Gp16x64;
{gp32}                    return AsmElement.Gp32;
{gp32x64}                 return AsmElement.Gp32x64;
{gp64}                    return AsmElement.Gp64;
gp8                       return AsmElement.Gp8Type;
gp16                      return AsmElement.Gp16Type;
gp32                      return AsmElement.Gp32Type;
gp64                      return AsmElement.Gp64Type;
m                         return AsmElement.MType;
imm                       return AsmElement.ImmType;
{xmm_regs}                return AsmElement.XmmReg;
{xmm_regsx64}             return AsmElement.XmmRegx64;
{ymm_regs}                return AsmElement.YmmReg;
{ymm_regsx64}             return AsmElement.YmmRegx64;
{mm_regs}                 return AsmElement.MmReg;
{fp_regs}                 return AsmElement.FpReg;
{base16}|{base10}|{base2} return AsmElement.ImmValue;
\(                        return AsmElement.LBracket;
\)                        return AsmElement.RBracket;
\[                        return AsmElement.LSBracket;
\]                        return AsmElement.RSBracket;
\{                        return AsmElement.LCBracket;
\}                        return AsmElement.RCBracket;
\+                        return AsmElement.Add;
\-                        return AsmElement.Sub;
\*                        return AsmElement.Mul;
\:                        return AsmElement.Colon;
,                         return AsmElement.Comma;
\n                        return AsmElement.NewLine;
=                         return AsmElement.Equal;
[:IsWhiteSpace:]          continue;
[a-z][a-z0-9]*            return AsmElement.Id;
%%