using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WRMySQL.Helpers;
using WRMySQL.Model;

namespace SlowLog_Snapshotter
{
    class Program
    {
        static void WriteLog(string message)
        {
            string outMessage = String.Format("{0}: {1}", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"), message);

            Console.WriteLine(outMessage);
            File.AppendAllText("output_slowlog.log", outMessage + "\n");
        }

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

            MySqlConnection connDst = DBHelper.Connect(dstName);
           
            long snapId = DBHelper.CreateSlow_LogSnapshot(connDst, srcName, timeBeg, timeEnd);
            WriteLog("Snapshot created: ID = " + snapId);
            
            MySqlConnection connSrc = DBHelper.Connect(srcName);
            string tableName = "mysql.slow_log";
            WriteLog("Init & load started");
            
            WRTableMeta meta = new WRTableMeta(connDst, tableName);
            meta.FillFieldsCollection();

            bool haveNewData = true;
            WRTableData data = new WRTableData(meta, connSrc, connDst);
            int batchSize = 10000;
            int currentOffset = 0;
            int curDataRowNum = 0;
            while (haveNewData)
            {
                WriteLog(String.Format("Init & load (offset = {0})", currentOffset));
                data.LoadDataFromSrc(String.Format("WHERE start_time between '{0}' and '{1}' LIMIT {2} OFFSET {3}", timeBeg.ToString("yyyy-MM-dd HH:mm:ss"), timeEnd.ToString("yyyy-MM-dd HH:mm:ss"),batchSize,currentOffset));

                WriteLog("SaveData started");
                data.SaveDataToDst(snapId);
                DBHelper.Commit(connDst);
                WriteLog("SaveData finished");
                
                currentOffset += batchSize;
                haveNewData = (data.TableData.Rows.Count > 0);
            };

            connSrc.Close();

            // cleanUp            
            connDst.Close();

            WriteLog("Wrapping up");


        }
    }
}
