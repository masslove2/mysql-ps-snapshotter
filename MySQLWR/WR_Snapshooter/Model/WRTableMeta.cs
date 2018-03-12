using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WR_Snapshooter.Model
{
    public class WRTableMeta
    {
        public const string TABLE_SCHEMA = "WR";
        public const string SNAPID_COLUMN_NAME = "snapId";

        public MySqlConnection Conn { get; set; }
        public string SrcTableName { get; set; }
        public string DstTableName { get; set; }
        public Dictionary<string, string> FieldsCollection; // fieldname -> data type

        public WRTableMeta(MySqlConnection conn, string dstTableName)
        {
            Conn = conn;
            DstTableName = dstTableName;
            SrcTableName = DstTableName.Substring(2); // remove prefix wr
            FieldsCollection = new Dictionary<string, string>();
        }

        public void FillFieldsCollection()
        {
            FieldsCollection.Clear();

            string sql = @"select column_name, data_type 
                             from information_schema.columns
                            where table_name = ? and table_schema = ?
                              and column_name != ?
                            order by ordinal_position";
            using (MySqlCommand cmd = new MySqlCommand(sql, Conn))
            {
                cmd.Parameters.AddWithValue("table_name", DstTableName);
                cmd.Parameters.AddWithValue("table_schema", TABLE_SCHEMA);
                cmd.Parameters.AddWithValue("exclue_column_name", SNAPID_COLUMN_NAME);
                using (MySqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        FieldsCollection.Add(dr[0].ToString(), dr[1].ToString());
                    }
                }
            }
        }
    }
}
