using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

namespace SuperService
{
  public class Program
  {
    public static void Main(string[] args)
    {
      CreateHostBuilder(args).Build().Run();
    }

    public static IHostBuilder CreateHostBuilder(string[] args) =>
      Host.CreateDefaultBuilder(args)
        .ConfigureWebHostDefaults(webBuilder =>
        {
          webBuilder.UseUrls("https://0.0.0.0:8443");
          webBuilder.UseStartup<Startup>();
        });
  }
}
