using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppLogSimulator
{
    public class Storage
    {
        private string _name;

        public Storage(string name)
        {
            _name = name;
        }

        public void StorageUsed()
        {
            var observer = new StorageObserver(_name);
            var random = new Random();
            var writer = new StringWriter();
            writer.WriteLine("StoreTime;Storage;Bytes");
            var minute = 0;
            while (true)
            {
                var size = random.Next(10000, 50000);
                writer.WriteLine("{0};{1};{2}", DateTime.Now.ToUniversalTime(), _name, size);

                var delay = random.Next(1000, 2000);
                System.Threading.Thread.Sleep(delay);
                minute += delay;
                if (minute > 10000) {
                    writer.Close();
                    observer.OnNext(new CsvEvent {
                        Data = DateTime.UtcNow
                        ,
                        Csv = writer.ToString()
                    });
                    writer = new StringWriter();
                    writer.WriteLine("StoreTime;Storage;Bytes");
                    minute = 0;
                }
            }
        }

        private void Thread(int delay)
        {
            throw new NotImplementedException();
        }
    }
}
