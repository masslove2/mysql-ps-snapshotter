using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WRMySQL.Model
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

        private void SaveData_FlushRows(long snapId, List<DataRow> rows)
        {
            int countRows = rows.Count;
            if (countRows == 0) { return; }

            string fieldsCsv = WRTableMeta.SNAPID_COLUMN_NAME + "," + String.Join(",", TableMeta.FieldsCollection.Keys);
            string placeholdersCsv = "(?," + String.Join(",", Enumerable.Repeat("?", TableMeta.FieldsCollection.Keys.Count)) + ")";

            string sqlInsert = String.Format("INSERT INTO {0} ({1}) VALUES {2}", TableMeta.DstTableName, fieldsCsv, String.Join(",", Enumerable.Repeat(placeholdersCsv, countRows)));

            int i = 0;
            using (MySqlCommand cmd = new MySqlCommand(sqlInsert, DstConn))
            {
                cmd.Parameters.Clear();

                foreach (DataRow row in rows)
                {
                    i++;
                    cmd.Parameters.AddWithValue("snapId" + i, snapId);
                    foreach (DataColumn fld in TableData.Columns)
                    {
                        cmd.Parameters.AddWithValue(fld.ColumnName + i, row[fld.ColumnName]);
                    }
                }

                cmd.ExecuteNonQuery();
            }
        }

        public void SaveDataToDst(long snapId)
        {
            if (TableData == null) { throw new Exception("No data loaded"); }

            int chunkSize = 100;

            List<DataRow> rowsCollection = new List<DataRow>();

            foreach (DataRow row in TableData.Rows)
            {
                rowsCollection.Add(row);
                if (rowsCollection.Count >= chunkSize)
                {
                    SaveData_FlushRows(snapId, rowsCollection);
                    rowsCollection.Clear();
                };
            }
            SaveData_FlushRows(snapId, rowsCollection); // final
        }
    }
}
