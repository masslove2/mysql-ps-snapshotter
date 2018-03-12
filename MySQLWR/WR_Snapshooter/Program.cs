using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WR_Snapshooter.Helpers;
using WR_Snapshooter.Model;

namespace WR_Snapshooter
{
    class Program
    {
        static void WriteLog(string message)
        {
            string outMessage = String.Format("{0}: {1}", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"), message);

            Console.WriteLine(outMessage);
            File.AppendAllText("output.log", outMessage + "\n");


        }

        static void Main(string[] args)
        {                       
            if (args.Length < 2) { Console.WriteLine("Usage: WR_Snapshooter.exe srcConnName dstConnName");  Environment.Exit(0);}

            string srcName = args[0]; // "AMWAY-PERF";
            string dstName = args[1];
            WriteLog(String.Format("Started {0} -> {1}", srcName, dstName));
                        
            MySqlConnection connDst = DBHelper.Connect(dstName);

            long snapId = DBHelper.CreateSnapshot(connDst, srcName);
            WriteLog("Snapshot created: ID = " + snapId);

            List<string> tablesToProcess = ConfigurationManager.GetSection("TablesToProcess") as List<string>;
            List<WRTableData> tablesDataPieces = new List<WRTableData>();

            MySqlConnection connSrc = DBHelper.Connect(srcName);
            WriteLog("Init & load started");
            // init & load data from src
            foreach (string tableName in tablesToProcess)
            {
                WriteLog("Load for table " + tableName);
                WRTableMeta meta = new WRTableMeta(connDst, tableName);
                meta.FillFieldsCollection();

                WRTableData data = new WRTableData(meta, connSrc, connDst);
                data.LoadDataFromSrc();
                tablesDataPieces.Add(data);
            }
            WriteLog("Init & load finished");
            connSrc.Close();

            WriteLog("SaveData started");
            // save to dst
            foreach (WRTableData tableData in tablesDataPieces)
            {
                WriteLog("SaveData for table " + tableData.TableMeta.DstTableName);
                tableData.SaveDataToDst(snapId);
            }
            WriteLog("SaveData finished");

            // cleanUp
            DBHelper.Commit(connDst);            
            connDst.Close();

            WriteLog("Wrapping up");
        }
    }
}
