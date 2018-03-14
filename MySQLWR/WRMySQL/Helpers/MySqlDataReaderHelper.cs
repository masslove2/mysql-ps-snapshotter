using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WRMySQL.Helpers
{
    public static class MySqlDataReaderHelper
    {
        public static string SafeGetString(this MySqlDataReader reader, int colIndex)
        {
            return (!reader.IsDBNull(colIndex)) ? reader.GetString(colIndex) : string.Empty;
        }

        public static ulong SafeGetBigInt(this MySqlDataReader reader, int colIndex)
        {
            return (!reader.IsDBNull(colIndex)) ? reader.GetUInt64(colIndex) : 0;
        }

        public static DateTime SafeGetDateTime(this MySqlDataReader reader, int colIndex)
        {
            return (!reader.IsDBNull(colIndex)) ? reader.GetDateTime(colIndex) : DateTime.MinValue;
        }

        public static string SafeGetString(this MySqlDataReader reader, string colName)
        {
            return (reader[colName] != DBNull.Value) ? reader.GetString(colName) : string.Empty;
        }

        public static ulong SafeGetBigInt(this MySqlDataReader reader, string colName)
        {
            return (reader[colName] != DBNull.Value) ? reader.GetUInt64(colName) : 0;
        }

        public static DateTime SafeGetDateTime(this MySqlDataReader reader, string colName)
        {
            return (reader[colName] != DBNull.Value) ? reader.GetDateTime(colName) : DateTime.MinValue;
        }

        public static object SafeGet(this MySqlDataReader reader, string colName, string type)
        {
            switch (type)
            {
                case "string": return SafeGetString(reader, colName);
                case "ulong": return SafeGetBigInt(reader, colName);
                case "datetime": return SafeGetDateTime(reader, colName);
                default:
                    throw new Exception("Unknown type = " + type);
            }
        }


    }
}
