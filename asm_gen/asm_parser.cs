using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace AsmGen
{
    enum AsmElement :
        int
    {
        Gp8,
        Gp16,
        Gp16x64,
        Gp32,
        Gp32x64,
        Gp64,
        RegType,
        XmmReg,
        XmmRegx64,
        YmmReg,
        YmmRegx64,
        MmReg,
        FpReg,
        Imm,
        LBracket,
        RBracket,
        LSBracket,
        RSBracket,
        LCBracket,
        RCBracket,
        Add,
        Sub,
        Mul,
        Id,
        Colon
    }

    enum InstructionOperandType
    {
        M8,
        M16,
        M32,
        M64,
        M128,
        M256,
        GP8,
        GP16,
        GP32,
        GP64,
        FP,
        MM,
        XMM,
        YMM,
        IMM
    }
    interface CPUInstruction
    {

    }
    interface CPUModel
    {
        CPUInstruction InstructionByName(string name, InstructionOperandType[] operands);
    }

    /// <summary>
    /// vpunpckwd     xmm1,xmm(name),{register type}(name)
    /// __x32() {
    /// }
    /// </summary>
    public class AsmParser
    {
        public void Parse(string path)
        {
            using (FileStream file = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                Parse(file);
            }
        }

        public void Parse(FileStream file)
        {
            Parser parser = new Parser(file);
            parser.Parse();
        }
    }
}
