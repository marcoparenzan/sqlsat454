using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.ServiceBus;
using Microsoft.ServiceBus.Messaging;
using Newtonsoft.Json;
using System.Configuration;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Auth;
using Microsoft.WindowsAzure.Storage.Blob;
using System.IO;

namespace AppLogSimulator
{
    public class StorageObserver : IObserver<CsvEvent>
    {
        private CloudBlobClient _client;
        private CloudBlobContainer _container;
            
        public StorageObserver(string storageName)
        {
            var account = CloudStorageAccount.Parse(ConfigurationManager.AppSettings["storageusage"]);
            _client = account.CreateCloudBlobClient();
            _container = _client.GetContainerReference("storageusage");
            _container.CreateIfNotExists();
        }

        public void OnCompleted()
        {
        }

        public void OnError(Exception error)
        {
            throw error;
        }

        public void OnNext(CsvEvent value)
        {
            var csv = _container.GetBlockBlobReference(string.Format("{0}{1}.csv", "storageusage", value.Data.ToString("yyyy-MM-ddThh:mm:ssZ")));
            csv.UploadText(value.Csv);
            Console.WriteLine(value.Csv);
        }
    }

    public class CsvEvent {
        public string Csv { get; internal set; }
        public DateTime Data { get; set; }

    }
}
