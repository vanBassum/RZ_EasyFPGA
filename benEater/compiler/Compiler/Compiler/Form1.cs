using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Compiler
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }


        byte wr = 0;
        void AddRAM(byte val, string ist = "")
        {
            richTextBox2.AppendText($"{wr++} => x\"{val.ToString("X2")}\", --{ist}\r\n");
        }

        void ASMERROR(string msg)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            wr = 0;
            richTextBox2.Text = "";
            Dictionary<string, byte> labels = new Dictionary<string, byte>();

            foreach(string line in richTextBox1.Lines)
            {
                string[] split = line.Split(' ');

                if(split.Length > 0)
                {
                    string ist = split[0];


                    byte val = 0;

                    if(split.Length > 1)
                    {
                        if(!byte.TryParse(split[1], out val))
                        {
                            //Label?

                            if(labels.ContainsKey(split[1]))
                            {
                                val = labels[split[1]];
                            }
                            else
                            {
                                ASMERROR($"Label '{split[1]}' not found");
                            }
                        }
                    }


                    if (ist.EndsWith(":"))
                    {
                        labels.Add(ist.TrimEnd(':'), wr);
                    }

                    else
                    {
                        switch (ist)
                        {
                            case "LDI": //Loads value of next byte into REGA
                                AddRAM(0x01, ist);
                                AddRAM(val);
                                break;

                            case "LDA": //Loads value of RAM at address of next byte into REGA
                                AddRAM(0x02, ist);
                                AddRAM(val);
                                break;

                            case "STA": //Stores REGA to RAM at address of next byte
                                AddRAM(0x03, ist);
                                AddRAM(val);
                                break;

                            case "OUT": //Ouputs contents of REGA
                                AddRAM(0x04, ist);
                                break;

                            case "ADI": //Adds value to REGA
                                AddRAM(0x05, ist);
                                AddRAM(val);
                                break;

                            case "ADD": //Adds RAM to REGA
                                AddRAM(0x06, ist);
                                AddRAM(val);
                                break;

                            case "JP": //Jumps to value
                                AddRAM(0x07, ist);
                                AddRAM(val);
                                break;

                            case "JNZ": //Jumps when not zero
                                AddRAM(0x08, ist);
                                AddRAM(val);
                                break;

                            case "SUI": //Substracts value from rega
                                AddRAM(0x09, ist);
                                AddRAM(val);
                                break;

                            case "HLT":
                                AddRAM(0xFF, ist);
                                break;
                        }
                    }
                }
            }









        }
    }
}
