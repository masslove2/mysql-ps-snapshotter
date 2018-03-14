using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WRMySQL.Helpers
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

        public static long CreateSnapshot(MySqlConnection conn, string servName, string snapshotComments)
        {
            string sqlIns = "INSERT INTO wrSnapshot (hostName, snapTime, comments) VALUES (?,?,?)";
            using (MySqlCommand cmd = new MySqlCommand(sqlIns, conn))
            {
                cmd.Parameters.AddWithValue("hostName", servName);
                cmd.Parameters.AddWithValue("snapTime", DateTime.Now);
                cmd.Parameters.AddWithValue("comments", snapshotComments);

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
