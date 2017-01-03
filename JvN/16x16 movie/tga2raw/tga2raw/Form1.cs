using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace tga2raw
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        public void Save(byte[] data, string path)
        {
            File.WriteAllBytes(path + "ROM.dat", data);
            MessageBox.Show("Saved to " + path + "ROM.dat", "", MessageBoxButtons.OK, MessageBoxIcon.Information);
            Application.Exit();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Hide();

            FolderBrowserDialog fbd = new FolderBrowserDialog();

            DialogResult result = fbd.ShowDialog();

            if (!string.IsNullOrWhiteSpace(fbd.SelectedPath))
            {
                string path = fbd.SelectedPath + @"\";
                byte[] data = new byte[32*1024];
                int i = 0;
                while (true) {
                    string fileName = path + i.ToString() + ".tga";
                    if (File.Exists(fileName))
                    {
                        FileInfo info = new FileInfo(fileName);
                        if (info.Length != 50)
                        {
                            MessageBox.Show(i.ToString() + ".tga" + " : file size mismatch.\n 18 byte header + 32 byte 1bpp raw data", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            Application.Exit();
                        }
                        else
                        {
                            byte[] fileBytes = File.ReadAllBytes(fileName);
                            Array.Copy(fileBytes, 18, data, i*32, 32);
                        }

                    }
                    else
                    {
                        break;
                    }
                    i++;
                    if (i == 1024)
                        break;
                }
                Save(data, path);
            }
            Application.Exit();
        }
    }
}
