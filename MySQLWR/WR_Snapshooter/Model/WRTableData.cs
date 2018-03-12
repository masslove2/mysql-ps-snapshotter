using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WR_Snapshooter.Model
{
    public class WRTableData
    {
        public WRTableMeta TableMeta { get; set; }
        public DataTable TableData { get; set; }

        public MySqlConnection SrcConn { get; set; }
        public MySqlConnection DstConn { get; set; }


        public WRTableData(WRTableMeta tableMeta, MySqlConnection srcConn, MySqlConnection dstConn)
        {
            TableMeta = tableMeta;
            SrcConn = srcConn;
            DstConn = dstConn;
        }

        public void LoadDataFromSrc()
        {
            string ColumnsCsv = String.Join(",", TableMeta.FieldsCollection.Keys);

            string sqlSelect = String.Format("SELECT {0} FROM {1}", ColumnsCsv, TableMeta.SrcTableName);
            using (MySqlDataAdapter da = new MySqlDataAdapter(sqlSelect, SrcConn))
            {
                TableData = new DataTable();
                da.Fill(TableData);
            }
        }

        public void SaveDataToDst(long snapId)
        {
            if (TableData == null) { throw new Exception("No data loaded"); }

            //TableData.Columns.Add(WRTableMeta.SNAPID_COLUMN_NAME, Type.GetType("int"));
            
            string fieldsCsv = WRTableMeta.SNAPID_COLUMN_NAME + "," + String.Join(",", TableMeta.FieldsCollection.Keys);
            string placeholdersCsv = "?," + String.Join(",", Enumerable.Repeat("?", TableMeta.FieldsCollection.Keys.Count));

            string sqlInsert = String.Format("INSERT INTO {0} ({1}) VALUES ({2})",TableMeta.DstTableName, fieldsCsv, placeholdersCsv);
            using (MySqlCommand cmd = new MySqlCommand(sqlInsert, DstConn))
            {
                foreach (DataRow row in TableData.Rows)
                {
                    cmd.Parameters.Clear();
                    cmd.Parameters.AddWithValue("snapId", snapId);
                    foreach (DataColumn fld in TableData.Columns)
                    {
                        cmd.Parameters.AddWithValue(fld.ColumnName, row[fld.ColumnName]);
                    }
                    cmd.ExecuteNonQuery();
                }
            }
        }

    }
}
