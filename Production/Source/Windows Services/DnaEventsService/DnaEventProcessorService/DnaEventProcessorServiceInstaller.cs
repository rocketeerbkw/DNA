using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;
using System.Linq;
using System.ServiceProcess;


namespace DnaEventProcessorService
{
    [RunInstaller(true)]
    public partial class DnaEventProcessorServiceInstaller : Installer
    {
        public DnaEventProcessorServiceInstaller()
        {
            InitializeComponent();
        }

        public override void Install(IDictionary stateSaver)
        {
            serviceInstaller1.StartType = ServiceStartMode.Automatic;
            base.Install(stateSaver);
        }
    }
}
