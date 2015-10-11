using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppLogSimulator
{
    public class StorageUsage
    {
        public string Storage { get; set; }
        public int Bytes { get; set; }
        public DateTime StoreTime { get; internal set; }
    }
}
