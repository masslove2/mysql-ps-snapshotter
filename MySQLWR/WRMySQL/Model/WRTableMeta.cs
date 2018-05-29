using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WRMySQL.Model
{
    public class WRTableMeta
    {
        public const string TABLE_SCHEMA = "WR";
        public const string DST_TABLE_PREFIX = "wr";
        public const string DEFAULT_SRC_TABLE_SCHEMA = "performance_schema";
        public const string SNAPID_COLUMN_NAME = "snapId";

        public MySqlConnection Conn { get; set; }
        public string SrcTableSchema { get; set; }
        public string SrcTableName { get; set; }
        public string DstTableName { get; set; }
        public Dictionary<string, string> FieldsCollection; // fieldname -> data type

        public string SrcTableNameWithSchema { get { return String.Format("{0}.{1}", SrcTableSchema, SrcTableName); } }

        public WRTableMeta(MySqlConnection conn, string srcTableNameWithSchema)
        {
            Conn = conn;

            string[] parts = srcTableNameWithSchema.Split('.');
            if (parts.Length > 1)
            {
                SrcTableSchema = parts[0]; SrcTableName = parts[1];
            }
            else
            {
                SrcTableSchema = DEFAULT_SRC_TABLE_SCHEMA; SrcTableName = srcTableNameWithSchema;
            }

            DstTableName = DST_TABLE_PREFIX + SrcTableName;            
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
