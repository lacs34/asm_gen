using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace asm_gen
{
    public class UserDefinedType
    {
        private string name;
        public string Name { get => name; set => name = value; }

        private UserDefinedType parentType;
        public UserDefinedType ParentType { get => parentType; set => parentType = value; }

        private bool isTargetType;
        public bool IsTargetType { get => isTargetType; set => isTargetType = value; }

        public UserDefinedType(string name, UserDefinedType parent)
        {
            Name = name;
            ParentType = parent;
        }
        public UserDefinedType(string name, UserDefinedType parent, bool isTarget)
        {
            Name = name;
            ParentType = parent;
            IsTargetType = isTarget;
        }
    }

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

    public class FunctionSignature
    {
        private string name;
        public string Name { get => name; set => name = value; }
        private UserDefinedType[] parameterNames;
        public UserDefinedType[] ParameterNames { get => parameterNames; set => parameterNames = value; }
        
        public FunctionSignature(string name , UserDefinedType[] parameters)
        {
            Name = name;
            ParameterNames = parameters;
        }
        
        public override bool Equals(object obj)
        {
            FunctionSignature another = obj as FunctionSignature;
            if (another == null)
            {
                return false;
            }
            if (another.Name != Name || another.ParameterNames.Length != ParameterNames.Length)
            {
                return false;
            }
            for (int i = 0; i < ParameterNames.Length; ++i)
            {
                if (another.ParameterNames[i] != ParameterNames[i])
                {
                    return false;
                }
            }
            return true;
        }

        public override int GetHashCode()
        {
            return ParameterNames.Aggregate(Name.GetHashCode(), (hash, p) => hash ^ p.GetHashCode());
        }
    }
}
