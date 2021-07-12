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


        List<Instruction> instructions = new List<Instruction>()
        {
            new Instruction("LDI", 0x01, 1, "Writes value to REGA"),
            new Instruction("LDA", 0x02, 1, "Reads RAM to REGA"),
            new Instruction("STA", 0x03, 1, "Writes REGA to RAM"),
            new Instruction("OUT", 0x04, 0, "Writes REGA to Output"),
            new Instruction("ADI", 0x05, 1, "Increases REGA by value"),
            new Instruction("ADD", 0x06, 1, "Increases REGA by RAM"),
            new Instruction("JP",  0x07, 1, "Jumps to address or label"),
            new Instruction("JNZ", 0x08, 1, "Jumps to address or label if REGA is not zero"),
            new Instruction("SUI", 0x09, 1, "Decreases REGA by value"),
            new Instruction("HLT", 0xFF, 1, "Stops code execution"),
        };




        void ASMERROR(int lineNo, string msg)
        {
            richTextBox3.AppendText($"Line {lineNo}: {msg}\r\n");
        }



        private void button1_Click(object sender, EventArgs e)
        {
            int rd = 0;
            byte wr = 0;
            richTextBox2.Text = "";
            Dictionary<string, byte> labels = new Dictionary<string, byte>();

            for (rd = 0; rd < richTextBox1.Lines.Length; rd++)
            {
                string line = richTextBox1.Lines[rd];
                string[] split = line.Split(' ');

                if (split.Length > 0)
                {
                    if (split[0].EndsWith(":"))
                    {
                        labels.Add(split[0].TrimEnd(':'), wr);
                    }
                    else
                    {
                        string instr = split[0].Trim('\t', ' ');

                        if(instr != "") //Ignore white spaces
                        {
                            Instruction ist = instructions.FirstOrDefault(a => a.ASM == split[0]);

                            if (ist == null)
                            {
                                ASMERROR(rd, $"Instruction '{split[0]}' not found.");
                            }
                            else
                            {
                                try
                                {
                                    string s;
                                    ist.ToString(ref wr, out s, split, labels);
                                    richTextBox2.AppendText(s);
                                }
                                catch (Exception ex)
                                {
                                    ASMERROR(rd, ex.Message);
                                }
                            }
                        }
                    }
                }
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            richTextBox2.Text = "Available commands:\r\n";

            foreach(Instruction ist in instructions)
            {
                richTextBox2.AppendText($" - {ist.ASM.PadRight(4)} takes {ist.Parameters} parameters. {ist.Description}\r\n");
            }

        }
    }

    class Instruction
    {
        public string ASM { get; set; } = "HLT";
        public byte HEX { get; set; } = 0xFF;
        public string Description { get; set; } = "Stops exectution";
        public int Parameters { get; set; } = 0;

        public Instruction()
        {

        }

        public Instruction(string aSM, byte hEX, int parameters, string description)
        {
            ASM = aSM;
            HEX = hEX;
            Description = description;
            Parameters = parameters;
        }

        public void ToString(ref byte wr, out string s, string[] parameters, Dictionary<string, byte> labels)
        {
            s = $"{wr++} => x\"{HEX.ToString("X2")}\", \t--{Description}\r\n";

            for (int i = 1; i < parameters.Length; i++)
            {
                byte p;
                if (byte.TryParse(parameters[i], out p))
                    s += $"{wr++} => x\"{p.ToString("X2")}\",\r\n";
                else if(labels.TryGetValue(parameters[i], out p))
                    s += $"{wr++} => x\"{p.ToString("X2")}\",\r\n";
                else
                    throw new Exception($"Parameter {i} '{parameters[i]}' is not a valid label nor convertable to a byte!");
            }
        }
    }
}
