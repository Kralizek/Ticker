using System.Threading.Tasks;
using Amazon.Lambda.CloudWatchEvents.ScheduledEvents;
using Amazon.Lambda.Core;
using Kralizek.Lambda;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace Ticker
{
    public class Function : EventFunction<ScheduledEvent>
    {
        protected override void Configure(IConfigurationBuilder builder)
        {
            builder.AddJsonFile("appsettings.json");

            builder.AddEnvironmentVariables();
        }

        protected override void ConfigureLogging(ILoggingBuilder logging, IExecutionEnvironment executionEnvironment)
        {
            logging.AddLambdaLogger(new LambdaLoggerOptions(Configuration));
        }

        protected override void ConfigureServices(IServiceCollection services, IExecutionEnvironment executionEnvironment)
        {
            RegisterHandler<TickEventHandler>(services);
        }
    }
}
