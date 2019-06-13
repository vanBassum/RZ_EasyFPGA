`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: ��Ȩ franchises3
// Create Date	: 2009.05.11
// Design Name	: 
// Module Name	: sdram_wr_data
// Project Name	: 
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: SDRAM���ݶ�дģ��
//				
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
module sdram_wr_data(
					clk,rst_n,
					/*sdram_clk,*/sdram_data,
					sys_data_in,sys_data_out,
					work_state,cnt_clk
				);
	//ϵͳ�ź�
input clk;		//ϵͳʱ�ӣ�100MHz
input rst_n;	//��λ�źţ��͵�ƽ��Ч
	// SDRAMӲ���ӿ�
//output sdram_clk;			// SDRAMʱ���ź�
inout[15:0] sdram_data;		// SDRAM��������
	// SDRAM��װ�ӿ�
input[15:0] sys_data_in;	//дSDRAMʱ�����ݴ���
output[15:0] sys_data_out;	//��SDRAMʱ�����ݴ���

	// SDRAM�ڲ��ӿ�
input[3:0] work_state;	//��дSDRAMʱ����״̬�Ĵ���
input[8:0] cnt_clk;		//ʱ�Ӽ���

`include "sdram_para.v"		// ����SDRAM��������ģ��

//assign sdram_clk = ~clk;	// SDRAMʱ���ź�

//------------------------------------------------------------------------------
//����д�����
//------------------------------------------------------------------------------
reg[15:0] sdr_din;	//ͻ������д�Ĵ���
reg sdr_dlink;		// SDRAM�������������������

	//����д�������͵�SDRAM����������
always @ (posedge clk or negedge rst_n) 
	if(!rst_n) sdr_din <= 16'd0;	//ͻ������д�Ĵ�����λ
	else if((work_state == `W_WRITE) | (work_state == `W_WD)) sdr_din <= sys_data_in;	//����д��洢��wrFIFO�е�256��16bit����

	//����˫�������߷�������߼�
always @ (posedge clk or negedge rst_n) 
	if(!rst_n) sdr_dlink <= 1'b0;
   else if((work_state == `W_WRITE) | (work_state == `W_WD)) sdr_dlink <= 1'b1;
	else sdr_dlink <= 1'b0;

assign sdram_data = sdr_dlink ? sdr_din:16'hzzzz;

//------------------------------------------------------------------------------
//���ݶ�������
//------------------------------------------------------------------------------
reg[15:0] sdr_dout;	//ͻ�����ݶ��Ĵ���	

	//�����ݴ�SDRAM����
always @ (posedge clk or negedge rst_n)
	if(!rst_n) sdr_dout <= 16'd0;	//ͻ�����ݶ��Ĵ�����λ
	else if((work_state == `W_RD)/* & (cnt_clk > 9'd0) & (cnt_clk < 9'd10)*/) sdr_dout <= sdram_data;	//��������8B��16bit���ݴ洢��rdFIFO��

assign sys_data_out = sdr_dout;

//------------------------------------------------------------------------------

endmodule
