using System;
using System.Collections.Generic;
using System.Linq;
using System.Reactive.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace AppLogSimulator
{
    class Program
    {
        static void Main(string[] args)
        {
            var deployments = new HashSet<Deployment>();
            deployments.Add(new Deployment("WestEurope1"));
            deployments.Add(new Deployment("WestEurope2"));
            deployments.Add(new Deployment("CentraUS"));
            deployments.Add(new Deployment("EastAsia"));

            var storages = new HashSet<Storage>();
            storages.Add(new Storage("WestEurope1"));
            storages.Add(new Storage("CentralUS"));
            storages.Add(new Storage("EastAsia"));

            var tasks = new List<Task>();

            foreach (var deployment in deployments)
            {
                tasks.Add(Task.Run(() => deployment.ApiCalls()));
                tasks.Add(Task.Run(() => deployment.CpuLoads()));
            }
            foreach (var storage in storages)
            {
                tasks.Add(Task.Run(() => storage.StorageUsed()));
            }
            Task.WaitAll(tasks.ToArray());
        }
    }
}
