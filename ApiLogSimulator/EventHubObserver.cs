using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.ServiceBus;
using Microsoft.ServiceBus.Messaging;
using Newtonsoft.Json;
using System.Configuration;

namespace AppLogSimulator
{
    public class EventHubObserver<TEvent> : IObserver<TEvent>
    {
        private EventHubClient _client;
                
        public EventHubObserver(string eventHubName)
        {
            _client = EventHubClient.CreateFromConnectionString(ConfigurationManager.AppSettings[eventHubName], eventHubName);
        }

        public void OnCompleted()
        {
        }

        public void OnError(Exception error)
        {
            throw error;
        }

        public void OnNext(TEvent value)
        {
            var json = JsonConvert.SerializeObject(value);
            var bytes = Encoding.UTF8.GetBytes(json);
            var data = new EventData(bytes);

            _client.Send(data);
            Console.WriteLine(json);
        }
    }
}
