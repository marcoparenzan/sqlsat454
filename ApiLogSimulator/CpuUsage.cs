using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppLogSimulator
{
    public class CpuUsage
    {
        public string Deployment { get; set; }
        public decimal Load { get; set; }
        public DateTime LogTime { get; internal set; }
    }
}
