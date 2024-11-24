
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.SignalR;
using naTanjir.Services.SignalRService;

namespace naTanjir.Services.SignalR
{
    public class SignalRHubService : Hub, ISignalRHubService
    {
        public override async Task OnConnectedAsync()
        {
            Console.WriteLine($"Klijent konektovan: {Context.ConnectionId}");
            await Task.Delay(100);
            await Clients.Caller.SendAsync("ReceiveConnectionId", Context.ConnectionId);
            await base.OnConnectedAsync();
        }

    }
}
