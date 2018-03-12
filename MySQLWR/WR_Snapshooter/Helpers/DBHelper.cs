using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data;
using MySql.Data.MySqlClient;
using WR_Snapshooter.Model;
using System.Configuration;

namespace WR_Snapshooter.Helpers
{
    public class DBHelper
    {
        public static MySqlConnection Connect(string connName)
        {
            string connStr = ConfigurationManager.ConnectionStrings[connName].ConnectionString; 

            MySqlConnection conn = new MySqlConnection(connStr);            
            conn.Open();
            return conn;
        }

        public static long CreateSnapshot(MySqlConnection conn, string servName)
        {
            string sqlIns = "INSERT INTO wrSnapshot (hostName, snapTime) VALUES (?,?)";
            using (MySqlCommand cmd = new MySqlCommand(sqlIns, conn))
            {
                cmd.Parameters.AddWithValue("hostName", servName);
                cmd.Parameters.AddWithValue("snapTime", DateTime.Now);

                cmd.ExecuteNonQuery();

                return cmd.LastInsertedId;
            }            
        }

        public static void Commit(MySqlConnection conn)
        {
            string sql = "commit";
            using (MySqlCommand cmd = new MySqlCommand(sql, conn))
            {                
                cmd.ExecuteNonQuery();                
            }
        }

    }
}
