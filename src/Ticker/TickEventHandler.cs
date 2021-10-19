using System;
using System.Threading.Tasks;
using Amazon.Lambda.CloudWatchEvents.ScheduledEvents;
using Amazon.Lambda.Core;
using Kralizek.Lambda;
using Microsoft.Extensions.Logging;

namespace Ticker
{
    public class TickEventHandler : IEventHandler<ScheduledEvent>
    {
        private readonly ILogger<TickEventHandler> _logger;
        public TickEventHandler(ILogger<TickEventHandler> logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public Task HandleAsync(ScheduledEvent input, ILambdaContext context)
        {
            _logger.LogInformation("Tick: {DATE}", input.Time);

            return Task.CompletedTask;
        }
    }
}