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
    public partial class frmMain : Form
    {
        private string[] inputParameters =
        {
            "WD", "WS", "O", "K", "D", "D3", "D5", "D15", "D50", "N", "N3", "N5", "N15", "N20", "M", "M3", "M10", "M15",
            "W", "W3", "W5", "W15", "W50", "W80", "CWS", "CO", "CK", "CD", "CD3", "CD5", "CD15", "CD50", "CN", "CN3",
            "CN5", "CN15", "CN20", "CM", "CM3", "CM10", "CM15", "CW", "CW3", "CW5", "CW15", "CW50", "CW80", "CWH",
            "WHZ", "WHF", "RD3", "RD5", "RD15", "RD50", "RN3", "RN5", "RN15", "RN20", "RM3", "RM10", "RM15", "RW3",
            "RW5", "RW15", "RW50", "RW80", "RWH", "ALPHA", "BETA", "GAMA", "T1", "T2", "T3", "T4"
        };

        private string[] outputParameters =
        {
            "Z", "XWD", "XD3", "XD5", "XD15", "XD50", "XN3", "XN5", "XN15", "XN20", "XM3", "XM10", "XM15", "XW3", "XW5",
            "XW15", "XW50", "XW80", "XWH", "XWDI", "XOD", "XON", "XOM", "XOW", "XSO", "XSK", "XO", "XK"
        };

        public frmMain()
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

            var src1 = File.Open(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "1.dat"), FileMode.Open);
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
                var s = ((TextBox) (Controls.Find(inputParameter, true)[0])).Text;
                sw.WriteLine($"{inputParameter}={s};");
            }

            sw.WriteLine();

            sw.WriteLine("Solve O_Model Using MIP Maximizing z;");
            sw.WriteLine();

            foreach (var outputParameter in outputParameters)
            {
                var s = ((TextBox) (Controls.Find(outputParameter, true)[0])).Text;
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
                ((TextBox) (Controls.Find(outputParameter, true)[0])).Text = line.Trim();
            }
            sr.Close();
            result.Close();

            File.Delete(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"tmp.gms"));
            File.Delete(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"tmp.lst"));
            File.Delete(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"Results.txt"));

            Cursor = Cursors.Default;
            Enabled = true;
        }

        private void UnzipGAMS()
        {
            string dir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "GAMS23.4");
            if (Directory.Exists(dir))
                Directory.Delete(dir, true);
            ZipFile.ExtractToDirectory(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "GAMS23.4.zip"),
                AppDomain.CurrentDomain.BaseDirectory);
        }

        private void frmMain_Load(object sender, EventArgs e)
        {
            frmSplash frm = new frmSplash();
            frm.ShowDialog();
        }
    }
}
