using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// DateRangeValidation - A helper calss that validates date ranges
    /// </summary>
    public class DateRangeValidation
    {
        /// <summary>
        /// Enum of possible validation results
        /// </summary>
        public enum ValidationResult
        {
            /// <summary>
            /// Value for a valid validation test
            /// </summary>
		    VALID,
            /// <summary>
            /// Value for an invalid start date
            /// </summary>
		    STARTDATE_INVALID,
            /// <summary>
            /// Value for an invalid end date
            /// </summary>
		    ENDDATE_INVALID,
            /// <summary>
            /// Value for a start date that is equal to the end date
            /// </summary>
		    STARTDATE_EQUALS_ENDDATE,
            /// <summary>
            /// Value for a start date that is greater than the end date
            /// </summary>
		    STARTDATE_GREATERTHAN_ENDDATE,
            /// <summary>
            /// Value for an invalid time interval
            /// </summary>
		    TIMEINTERVAL_INVALID,
            /// <summary>
            /// Value for a start date that is in the future
            /// </summary>
		    FUTURE_STARTDATE,
            /// <summary>
            /// Value for an end date in the future
            /// </summary>
		    FUTURE_ENDDATE
	    };

        // The last validation result
        private ValidationResult _lastValidationResult = ValidationResult.VALID;
        private DateTime _startDate;
        private DateTime _endDate;

        /// <summary>
        /// Last result property
        /// </summary>
        public ValidationResult LastResult
        {
            get { return _lastValidationResult; }
            set { _lastValidationResult = value; }
        }

        /// <summary>
        /// Last start date parsed property
        /// </summary>
        public DateTime LastStartDate
        {
            get { return _startDate; }
        }

        /// <summary>
        /// Last end date parsed property
        /// </summary>
        public DateTime LastEndDate
        {
            get { return _endDate; }
        }

       /// <summary>
        /// Validate a date to see if it represents a valid date . 
        /// </summary>
        /// <param name="date">The start date for the date range</param>
        /// <param name="errorOnFutureDate">A flag that states whether or not you want a date in the future to be error conditions</param>
        /// <returns>The result of the validation</returns>
        public ValidationResult ValidateDate(DateTime date, bool errorOnFutureDate)
        {
            // Reset the last result
            _lastValidationResult = ValidationResult.VALID;

            // Check to see if the dates are within valid datetime ranges for the database. 
            if (!DnaDateTime.IsDateWithinDBSmallDateTimeRange(date))
            {
                _lastValidationResult = ValidationResult.STARTDATE_INVALID;
                return _lastValidationResult;
            }
	        // Now check to see if we're worried about future dates
            if (errorOnFutureDate)
            {
                // Check to see if the start date is in the future
                if (date > DateTime.Today)
                {
                    // Start date in the future
                    _lastValidationResult = ValidationResult.FUTURE_STARTDATE;
                    return _lastValidationResult;
                }
            }
            // Got here? Must be valid!
            return ValidationResult.VALID;
        }
        /// <summary>
        /// Validate two dates to see if they represent a valid date range. 
        /// </summary>
        /// <param name="startDate">The start date for the date range</param>
        /// <param name="endDate">The end date for the date range</param>
        /// <param name="timeInterval">A time interval within the date range. e.g. 1 = a day, 7 = a week</param>
        /// <param name="errorOnFutureDates">A flag that states whether or not you want dates in the future to be error conditions</param>
        /// <param name="errorOnInvalidTimeInterval">A flag that states whether or not you want invalid time intervals to be error conditions</param>
        /// <returns>The result of the validation</returns>
        public ValidationResult ValidateDateRange(DateTime startDate, DateTime endDate, int timeInterval, bool errorOnFutureDates, bool errorOnInvalidTimeInterval)
        {
            // Reset the last result
            _lastValidationResult = ValidationResult.VALID;

            // Update the member dates
            _startDate = startDate;
            _endDate = endDate;

           	// Check to see if the dates are within valid datetime ranges for the database. 
	        if (!DnaDateTime.IsDateWithinDBSmallDateTimeRange(startDate))
	        {
                _lastValidationResult = ValidationResult.STARTDATE_INVALID;
                return _lastValidationResult;
	        }

            if (!DnaDateTime.IsDateWithinDBSmallDateTimeRange(endDate))
	        {
                _lastValidationResult = ValidationResult.ENDDATE_INVALID;
                return _lastValidationResult;
            }

	        // Now check to see if we're worried about future dates
	        if (errorOnFutureDates)
	        {
		        // Check to see if the start date is in the future
		        if (startDate > DateTime.Today)
		        {
			        // Start date in the future
			        _lastValidationResult = ValidationResult.FUTURE_STARTDATE;
                    return _lastValidationResult;
		        }

		        // Now check to see if the end date is in the future
		        if (endDate > DateTime.Today)
		        {
                    // End date is in the future
			        _lastValidationResult = ValidationResult.FUTURE_ENDDATE;
                    return _lastValidationResult;
		        }
	        }

	        // Check tyo make sure the start date is not the same as the end date
	        if (startDate == endDate)
	        {
                // Start date is equal to the end date.
		        _lastValidationResult = ValidationResult.STARTDATE_EQUALS_ENDDATE;
                return _lastValidationResult;
	        }

	        // Check tomake sure that the start date is before the end date
	        if (startDate > endDate)
	        {
                // The start date is greater than the end date
		        _lastValidationResult = ValidationResult.STARTDATE_GREATERTHAN_ENDDATE;
                return _lastValidationResult;
	        }

            // See if we're checking for invalid time intervals
            if (errorOnInvalidTimeInterval)
            {
                // Check to make sure the interval is smaller or equal to the difference in dates
                TimeSpan dateDiff = endDate.Subtract(startDate);
                if (dateDiff.Days < timeInterval)
                {
                    _lastValidationResult = ValidationResult.TIMEINTERVAL_INVALID;
                    return _lastValidationResult;
                }
            }

            // Got here? Must be valid!
            return ValidationResult.VALID;
        }

        /// <summary>
        /// Gets the last validtion result as an Error XML Element.
        /// </summary>
        /// <param name="doc">The document the element is to be added to.</param>
        /// <returns>An XML Element that represents the last validation result as an error.</returns>
        public XmlElement GetLastValidationResultAsXmlElement(XmlDocument doc)
        {
            // Create the new element and add the default attribute
            XmlElement validationResult = doc.CreateElement("ERROR");
            validationResult.SetAttribute("OBJECT", "DateRangeValidation.ValidateDateRange()");

            XmlText errorMsg = doc.CreateTextNode("");
            validationResult.AppendChild(errorMsg);

            // Now switch on the last result
            switch (_lastValidationResult)
            {
                case ValidationResult.VALID:
                    {
                        validationResult.SetAttribute("CODE","NoError");
                        errorMsg.Value = "No Error";
                        break;
                    }
                case ValidationResult.STARTDATE_INVALID:
                    {
                        validationResult.SetAttribute("CODE", "StartDateInvalid");
                        errorMsg.Value = "Start date is invalid";
                        break;
                    }
                case ValidationResult.ENDDATE_INVALID:
                    {
                        validationResult.SetAttribute("CODE", "EndDateInvalid");
                        errorMsg.Value = "End date is invalid";
                        break;
                    }
                case ValidationResult.STARTDATE_GREATERTHAN_ENDDATE:
                    {
                        validationResult.SetAttribute("CODE", "StartDateGreaterThanEndDate");
                        errorMsg.Value = "Start date greater than end date";
                        break;
                    }
                case ValidationResult.STARTDATE_EQUALS_ENDDATE:
                    {
                        validationResult.SetAttribute("CODE", "StartDateEqualsEndDate");
                        errorMsg.Value = "Start date equals end date";
                        break;
                    }
                case ValidationResult.TIMEINTERVAL_INVALID:
                    {
                        validationResult.SetAttribute("CODE", "TimeIntervalInvalid");
                        errorMsg.Value = "Time interval invalid for date range";
                        break;
                    }
                case ValidationResult.FUTURE_STARTDATE:
                    {
                        validationResult.SetAttribute("CODE", "StartDateInFuture");
                        errorMsg.Value = "Start date is in the future";
                        break;
                    }
                case ValidationResult.FUTURE_ENDDATE:
                    {
                        validationResult.SetAttribute("CODE", "EndDateInTheFuture");
                        errorMsg.Value = "End date is in the future";
                        break;
                    }
            }

            // Return the new element
            return validationResult;
        }
    }
}
