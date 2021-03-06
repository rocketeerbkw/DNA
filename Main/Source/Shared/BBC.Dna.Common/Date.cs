using System;
using BBC.Dna.Utils;
using System.Runtime.Serialization;
using System.Xml.Serialization;

//TODO: fix namespacing issue in xml serialisation
namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType=true, TypeName="LOCALDATE")]
    [XmlRootAttribute(IsNullable=false, ElementName="LOCALDATE")]
    [DataContract(Name = "LocalDate")]
    public class LocalDate
    {
        protected DateTime _dateTime;

        public LocalDate()
        { }

        public LocalDate(DateTime dateTime)
        {
            _dateTime = dateTime;
        }

        [XmlIgnore]
        [DataMember(Name = ("dateTime"))]
        public DateTime DateTime
        {
            get { return _dateTime; }
            set { _dateTime = value; }
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="DAYNAME")]
        public string DayName
        {
            get { return _dateTime.DayOfWeek.ToString(); }
            set{}
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="SECONDS")]
        public int Seconds
        {
            get{ return _dateTime.Second; }
            set{}
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="MINUTES")]
        public int Minutes
        {
            get { return _dateTime.Minute; }
            set{}
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="HOURS")]
        public int Hours
        {
            get { return _dateTime.Hour; }
            set{}
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="DAY")]
        public int Day
        {
            get { return _dateTime.Day; }
            set{}
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="MONTH")]
        public int Month
        {
            get { return _dateTime.Month; }
            set{}
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="MONTHNAME")]
        public string MonthName
        {
            get { return GetMonthName(_dateTime.Month); }
            set{}
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="YEAR")]
        public int Year
        {
            get { return _dateTime.Year; }
            set{}
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="SORT")]
        public string Sort
        {
            get { return _dateTime.ToString("yyyyMMddHHmmss"); }
            set{}
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "RELATIVE")]
        [DataMember(Name = ("ago"))]
        public string Relative
        {
            get { return DnaDateTime.TryGetRelativeValueForPastDate(_dateTime); }
            set{}
        }


        /// <summary>
        /// Returns full month name. 
        /// </summary>
        /// <param name="month">Month number (e.g. 1 = January, 2 = February etc.</param>
        /// <returns>Full month name (i.e. January | February etc.)</returns>
        private string GetMonthName(int month)
        {
            switch (month)
            {
                case 1: return "January";
                case 2: return "February";
                case 3: return "March";
                case 4: return "April";
                case 5: return "May";
                case 6: return "June";
                case 7: return "July";
                case 8: return "August";
                case 9: return "September";
                case 10: return "October";
                case 11: return "November";
                case 12: return "December";
                default: return "Unknown";
            }
        }
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [XmlTypeAttribute(AnonymousType=true, TypeName="DATE")]
    [XmlRootAttribute(IsNullable = false, ElementName = "DATE")]
    [DataContract(Name = "Date")]
    public class Date : LocalDate
    {
        public Date() { }
        public Date(DateTime dateTime)
        {
            _dateTime = dateTime.ToUniversalTime();
            Local = new LocalDate(BBC.Dna.Utils.TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(_dateTime));
        }

    /// <remarks/>
        [XmlElementAttribute(Form = System.Xml.Schema.XmlSchemaForm.Unqualified, Order = 0, ElementName = "LOCAL")]
        [DataMember(Name = ("local"))]
        public LocalDate Local
        {
            get;
            set;
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "DATE")]
    [XmlRootAttribute(IsNullable = false, ElementName = "DATE")]
    [DataContract(Name = "DateElement")]
    public class DateElement 
    {

        public DateElement() { }
        public DateElement(DateTime dateTime)
        {
            Date = new Date(dateTime);
        }

        /// <remarks/>
        [XmlElementAttribute(Form = System.Xml.Schema.XmlSchemaForm.Unqualified, Order = 0, ElementName = "DATE")]
        [DataMember(Name = ("date"))]
        public Date Date
        {
            get;
            set;
        }
    }
}
