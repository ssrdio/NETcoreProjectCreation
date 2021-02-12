using System;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using NLog;
using NLog.Web;

namespace {PROJECT_NAME}
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Logger logger = NLogBuilder.ConfigureNLog("nlog.config").GetLogger("general");
            try
            {
                IHost host = CreateHostBuilder(args).Build();

                logger.Info("App starting");
                host.Run();
            }
            catch (Exception ex)
            {
                ILogger globalExceptionLogger = LogManager.GetLogger("global_exception");

                globalExceptionLogger.Fatal(ex, "Stopped program because of exception");
            }
            finally
            {
                LogManager.Shutdown();
            }
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                })
                .UseNLog();
    }
}
