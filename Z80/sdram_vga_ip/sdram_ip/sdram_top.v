`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: ��Ȩ franchises3
// Create Date	: 2009.05.11
// Design Name	: 
// Module Name	: sdram_top
// Project Name	: 
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: SDRAM��װ���ƶ���ģ��
//				
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
/*-----------------------------------------------------------------------------
SDRAM�ӿ�˵����
	�ϵ縴λʱ��SDRAM���Զ��ȴ�200usȻ����г�ʼ��������ģʽ�Ĵ�����
���òο�sdram_ctrlģ�顣
	SDRAM�Ĳ�����
		����sys_en=1,sys_r_wn=0,sys_addr,sys_data_in����SDRAM����д��
	����������sys_en=1,sys_r_wn=1,sys_addr���ɴ�sys_data_out�������ݡ�
	ͬʱ����ͨ����ѯsdram_busy��״̬�鿴��д�Ƿ���ɡ�	
-----------------------------------------------------------------------------*/
module sdram_top(
				clk,rst_n,
				sdram_wr_req,sdram_rd_req,sdram_wr_ack,sdram_rd_ack,
				sys_wraddr,sys_rdaddr,
				sys_data_in,sys_data_out,sdwr_byte,sdrd_byte,//sdram_busy,sys_dout_rdy,
				/*sdram_clk,*/sdram_cke,sdram_cs_n,sdram_ras_n,sdram_cas_n,
				sdram_we_n,sdram_ba,sdram_addr,sdram_data,//sdram_udqm,sdram_ldqm
				sdram_init_done
			);

input clk;		//ϵͳʱ�ӣ�100MHz
input rst_n;	//��λ�źţ��͵�ƽ��Ч

	// SDRAM�ķ�װ�ӿ�
input sdram_wr_req;			//ϵͳдSDRAM�����ź�
input sdram_rd_req;			//ϵͳ��SDRAM�����ź�
output sdram_wr_ack;		//ϵͳдSDRAM��Ӧ�ź�,��ΪwrFIFO�������Ч�ź�
output sdram_rd_ack;		//ϵͳ��SDRAM��Ӧ�ź�
input[21:0] sys_wraddr;		// дSDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
input[21:0] sys_rdaddr;		// ��SDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
input[15:0] sys_data_in;	//дSDRAMʱ�����ݴ�����4��ͻ����д�����ݣ�Ĭ��Ϊ00��ַbit15-0;01��ַbit31-16;10��ַbit47-32;11��ַbit63-48
output[15:0] sys_data_out;	//��SDRAMʱ�����ݴ���,(��ʽͬ��)
input[8:0] sdwr_byte;		//ͻ��дSDRAM�ֽ�����1-256����
input[8:0] sdrd_byte;		//ͻ����SDRAM�ֽ�����1-256����
//output sdram_busy;			// SDRAMæ��־���߱�ʾSDRAM���ڹ�����
//output sys_dout_rdy;		// SDRAM���������ɱ�־
output	sdram_init_done;	//ϵͳ��ʼ������ź�

	// FPGA��SDRAMӲ���ӿ�
//output sdram_clk;			// SDRAMʱ���ź�
output sdram_cke;			// SDRAMʱ����Ч�ź�
output sdram_cs_n;			// SDRAMƬѡ�ź�
output sdram_ras_n;			// SDRAM�е�ַѡͨ����
output sdram_cas_n;			// SDRAM�е�ַѡͨ����
output sdram_we_n;			// SDRAMд����λ
output[1:0] sdram_ba;		// SDRAM��L-Bank��ַ��
output[11:0] sdram_addr;	// SDRAM��ַ����
inout[15:0] sdram_data;		// SDRAM��������
//output sdram_udqm;		// SDRAM���ֽ�����
//output sdram_ldqm;		// SDRAM���ֽ�����

	// SDRAM�ڲ��ӿ�
wire[3:0] init_state;	// SDRAM��ʼ���Ĵ���
wire[3:0] work_state;	// SDRAM����״̬�Ĵ���
wire[8:0] cnt_clk;		//ʱ�Ӽ���	
wire sys_r_wn;			// SDRAM��/д�����ź�
				
sdram_ctrl		module_001(		// SDRAM״̬����ģ��
									.clk(clk),						
									.rst_n(rst_n),
							//		.sdram_udqm(sdram_udqm),
							//		.sdram_ldqm(sdram_ldqm)													
									.sdram_wr_req(sdram_wr_req),
									.sdram_rd_req(sdram_rd_req),
									.sdram_wr_ack(sdram_wr_ack),
									.sdram_rd_ack(sdram_rd_ack),
									.sdwr_byte(sdwr_byte),
									.sdrd_byte(sdrd_byte),							
							//		.sdram_busy(sdram_busy),
							//		.sys_dout_rdy(sys_dout_rdy),
									.sdram_init_done(sdram_init_done),
									//
									.init_state(init_state),
									.work_state(work_state),
									.cnt_clk(cnt_clk),
									.sys_r_wn(sys_r_wn)
								);

sdram_cmd		module_002(		// SDRAM����ģ��
									.clk(clk),
									.rst_n(rst_n),
									.sdram_cke(sdram_cke),		
									.sdram_cs_n(sdram_cs_n),	
									.sdram_ras_n(sdram_ras_n),	
									.sdram_cas_n(sdram_cas_n),	
									.sdram_we_n(sdram_we_n),	
									.sdram_ba(sdram_ba),			
									.sdram_addr(sdram_addr),									
									.sys_wraddr(sys_wraddr),	
									.sys_rdaddr(sys_rdaddr),
									.sdwr_byte(sdwr_byte),
									.sdrd_byte(sdrd_byte),		
									.init_state(init_state),	
									.work_state(work_state),
									.sys_r_wn(sys_r_wn),
									.cnt_clk(cnt_clk)
								);

sdram_wr_data	module_003(		// SDRAM���ݶ�дģ��
									.clk(clk),
									.rst_n(rst_n),
							//		.sdram_clk(sdram_clk),
									.sdram_data(sdram_data),
									.sys_data_in(sys_data_in),
									.sys_data_out(sys_data_out),
									.work_state(work_state),
									.cnt_clk(cnt_clk)
								);
endmodule

