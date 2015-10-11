using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppLogSimulator
{
    public class Deployment
    {
        private string _name;

        public Deployment(string name)
        {
            _name = name;
        }

        public void ApiCalls()
        {
            var observer = new EventHubObserver<ApiCall>("apicalls");
            var random = new Random();
            var calls = new string[] { "A", "B", "C", "D", "E" };
            while (true)
            {
                var size = random.Next(500, 3000);
                var e = new ApiCall
                {
                    CallTime = DateTime.Now.ToUniversalTime()
                    ,
                    Deployment = _name
                    ,
                    Url = "http://www.sqlsatexpo.com/api/" + calls[random.Next(0, 5)]
                    ,
                    Size = size
                    ,
                    Elapsed = size/10 + random.Next(50, 150)
                };

                observer.OnNext(e);
                Task.Delay(e.Elapsed + random.Next(0, 1000));
            }
        }

        public void CpuLoads()
        {
            var observer = new EventHubObserver<CpuUsage>("cpuUsage");
            var random = new Random();
            while (true)
            {
                var e = new CpuUsage
                {
                    LogTime = DateTime.Now.ToUniversalTime()
                    ,
                    Deployment = _name
                    ,
                    Load = random.Next(0, 1000) / 10
                };

                observer.OnNext(e);
                Task.Delay(30000);
            }
        }
    }
}
