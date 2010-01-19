using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Dna.SnesIntegration.ActivityProcessor
{
    public interface ISnesActivity
    {
        string GetActivityJson();
        string GetPostUri();
        int ActivityId { get; set; }
    }
}
