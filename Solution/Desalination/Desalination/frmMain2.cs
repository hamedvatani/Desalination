using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Desalination
{
    public partial class frmMain2 : Form
    {
        private string[] inputParameters =
        {
            "WD", "WS", "ALPHA", "W", "W5", "W15", "W50", "W80", "WL5", "WL15", "WL50", "WL80", "CWS", "CW5", "CW15",
            "CW50", "CW80", "CWH", "WHZ", "WHF", "RW5", "RW15", "RW50", "RW80", "RWH", "WLH"
        };

        private string[] outputParameters =
        {
            "Z", "XWDI", "XWD", "XSO", "XSK", "XO", "XOW", "XK", "XKH", "XW5", "XW15", "XWH", "XW50", "XW80"
        };

        public frmMain2()
        {
            InitializeComponent();
        }

        private void BtnCalculate_Click(object sender, EventArgs e)
        {
            Enabled = false;
            Cursor = Cursors.WaitCursor;

            string GAMSFilename = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "GAMS23.4", "gams.exe");
            if (!File.Exists(GAMSFilename))
                UnzipGAMS();

            var filename = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "tmp.gms");
            if (File.Exists(filename))
                File.Delete(filename);
            var file = File.Open(filename, FileMode.OpenOrCreate);
            var sw = new StreamWriter(file);

            var src1 = File.Open(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "2.dat"), FileMode.Open);
            var sr = new StreamReader(src1);
            while (true)
            {
                var line = sr.ReadLine();
                if (line == null)
                    break;
                sw.WriteLine(line);
            }

            sr.Close();
            src1.Close();

            foreach (var inputParameter in inputParameters)
            {
                var s = ((TextBox)(Controls.Find(inputParameter, true)[0])).Text;
                sw.WriteLine($"{inputParameter}={s};");
            }

            sw.WriteLine();
            sw.WriteLine();
            sw.WriteLine("O = WS;");
            sw.WriteLine("K = WS;");
            sw.WriteLine("CO = 0;");
            sw.WriteLine("CK = 0;");
            sw.WriteLine("T4 = 100;");
            sw.WriteLine("CW = 0;");
            sw.WriteLine();
            sw.WriteLine("F5.UP=100000;");
            sw.WriteLine("F15.UP=100000;");
            sw.WriteLine();
            sw.WriteLine("XW50.UP=100000;");
            sw.WriteLine("XW80.UP=100000;");
            sw.WriteLine();
            sw.WriteLine();
            sw.WriteLine("OPTION optca=0,optcr=0, RESLIM=50000 ;");
            sw.WriteLine();
            sw.WriteLine("M=300000;");
            sw.WriteLine("Solve O_Model Using MIP Maximizing Z;");
            sw.WriteLine();

            foreach (var outputParameter in outputParameters)
            {
                var s = ((TextBox)(Controls.Find(outputParameter, true)[0])).Text;
                sw.WriteLine($"PUT {outputParameter}.L;");
                sw.WriteLine("PUT/;");
            }

            sw.Close();
            file.Close();

            var p = new Process();
            p.StartInfo.FileName = GAMSFilename;
            p.StartInfo.Arguments = "tmp.gms";
            p.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            p.StartInfo.CreateNoWindow = true;
            p.Start();
            p.WaitForExit();

            var result = File.Open(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Results.txt"), FileMode.Open);
            sr = new StreamReader(result);
            sr.ReadLine();
            sr.ReadLine();
            foreach (var outputParameter in outputParameters)
            {
                var line = sr.ReadLine();
                ((TextBox)(Controls.Find(outputParameter, true)[0])).Text = line.Trim().Replace(".", "/");
            }
            sr.Close();
            result.Close();

            File.Delete(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "tmp.gms"));
            File.Delete(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "tmp.lst"));
            File.Delete(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Results.txt"));

            Cursor = Cursors.Default;
            Enabled = true;
        }

        private void UnzipGAMS()
        {
            string dir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "GAMS23.4");
            if (Directory.Exists(dir))
                Directory.Delete(dir, true);
            ZipFile.ExtractToDirectory(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "GAMS23.4_1.zip"),
                AppDomain.CurrentDomain.BaseDirectory);
            ZipFile.ExtractToDirectory(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "GAMS23.4_2.zip"),
                AppDomain.CurrentDomain.BaseDirectory);
        }

        private void frmMain_Load(object sender, EventArgs e)
        {
            frmSplash frm = new frmSplash();
            frm.ShowDialog();
        }
    }
}
