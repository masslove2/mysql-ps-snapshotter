using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace WR_Snapshooter.Helpers
{
    public class TablesToProcessSection : IConfigurationSectionHandler
    {
        public object Create(object parent, object configContext, XmlNode section)
        {
            List<string> myConfigObject = new List<string>();

            foreach (XmlNode childNode in section.ChildNodes)
            {
                foreach (XmlAttribute attrib in childNode.Attributes)
                {
                    if (attrib.Name.Equals("Name"))
                    {
                        myConfigObject.Add(attrib.Value);
                    }
                }
            }
            return myConfigObject;
        }
    }

    public class TableItem
    {
        public string Name { get; set; }
    }
}
