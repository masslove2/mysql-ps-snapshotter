using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SlowLog_Snapshotter
{
    class Program
    {


        static void Main(string[] args)
        {
            if (args.Length < 2)
            {
                Console.WriteLine("Usage: SlowLog_Snapshooter.exe srcConnName dstConnName TimeBeg TimeEnd" +
                                  "TimeFormat \"YYYY-MM-DD HH24:MI:SS\" - example \"2018-03-03 14:45:00\""
                                                    );
                Environment.Exit(0);
            }

            string srcName = args[0]; // "AMWAY-PERF";
            string dstName = args[1];
            DateTime timeBeg = DateTime.Parse(args[2]);
            DateTime timeEnd = DateTime.Parse(args[3]);

           

        }
    }
}
