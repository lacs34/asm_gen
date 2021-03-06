﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace asm_gen
{
    public class UserDefinedSetCollection
    {
        /*private int levelCount;
        private class Level
        {
            [StructLayout(LayoutKind.Explicit)]
            private struct subLevelElement
            {
                [FieldOffset(0)]
                private int next;
            }
            private uint mask;
            public uint Mask { get => mask; }

            private Level[] subLevel;
            public Level[] SubLevel { get => subLevel; }

            public Level(IEnumerable<Tuple<int, Level>> subLevels)
            {
            }
            public Level(int bottomMask, Level level)
            {
                mask = 1u << bottomMask;
                subLevel = new Level[bottomMask + 1];
                subLevel[bottomMask] = level;
            }

            public Level(int bottomMask)
            {
                mask = 1u << bottomMask;
                subLevel = null;
            }
        }
        private Level topLevel;
        private const int perLevelBitCount = 5;
        private const int perLevelMask = (1 << perLevelBitCount) - 1;*/

        private BitArray collection;

        private UserDefinedSetCollection(BitArray c)
        {
            collection = c;
        }

        public UserDefinedSetCollection(int element)
        {
            collection = new BitArray(200);
            collection[element] = true;
            /*int currentLevel = 0;
            int currentValue = element;
            int currentLevelValue = element & perLevelMask;
            currentValue >>= perLevelBitCount;
            Level level = new Level(currentLevelValue);
            while (currentValue != 0)
            {
                currentLevelValue = element & perLevelMask;
                currentValue >>= perLevelBitCount;
                level = new Level(currentLevelValue, level);
                ++currentLevel;
            }

            levelCount = currentLevel;
            topLevel = level;*/
        }

        public bool Include(UserDefinedSetCollection included)
        {
            /*if (levelCount < included.levelCount)
            {
                return false;
            }
            int level = levelCount;
            Level includingLevel = topLevel;
            Level includedLevel = included.topLevel;
            while (level > included.levelCount)
            {
                includingLevel = includingLevel.SubLevel[0];
                if (includingLevel == null)
                {
                    return false;
                }
                --level;
            }*/
            return (new BitArray(collection)).Not().And(included.collection).OfType<bool>().All(u => !u);
        }

        public bool ProperlyInclude(UserDefinedSetCollection included)
        {
            return (new BitArray(collection)).Not().And(included.collection).OfType<bool>().All(u => !u);
        }

        public void Expend(UserDefinedSetCollection another)
        {
            collection.Or(another.collection);
        }

        public UserDefinedSetCollection Intersect(UserDefinedSetCollection another)
        {
            return new UserDefinedSetCollection((new BitArray(collection)).And(another.collection));
        }

        public UserDefinedSetCollection Union(UserDefinedSetCollection another)
        {
            return new UserDefinedSetCollection((new BitArray(collection)).Or(another.collection));
        }

        public UserDefinedSetCollection Sub(UserDefinedSetCollection another)
        {
            return new UserDefinedSetCollection(new BitArray(another.collection).Not().And(collection));
        }
    }

    public class ParseContext
    {
        private Dictionary<string, UserDefinedSetCollection> defindedSets = new Dictionary<string, UserDefinedSetCollection>();
        private List<string> elements = new List<string>();

        private UserDefinedSetCollection CreateNewSet(string name)
        {
            UserDefinedSetCollection created = new UserDefinedSetCollection(elements.Count);
            elements.Add(name);
            return created;
        }

        public UserDefinedSetCollection FindSet(string name)
        {
            UserDefinedSetCollection set = null;
            bool exist = defindedSets.TryGetValue(name, out set);
            if (!exist)
            {
                set = CreateNewSet(name);
                defindedSets.Add(name, set);
            }
            return set;
        }
    }
}
