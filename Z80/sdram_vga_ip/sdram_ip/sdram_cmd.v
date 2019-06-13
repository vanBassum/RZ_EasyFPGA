`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: ��Ȩ franchises3
// Create Date	: 2009.05.11
// Design Name	: 
// Module Name	: sdram_cmd
// Project Name	: 
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: SDRAM����ģ��
//				
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
module sdram_cmd(
				clk,rst_n,
				sdram_cke,sdram_cs_n,sdram_ras_n,sdram_cas_n,sdram_we_n,sdram_ba,sdram_addr,
				sys_wraddr,sys_rdaddr,sdwr_byte,sdrd_byte,
				init_state,work_state,sys_r_wn,cnt_clk
			);
	//ϵͳ�ź�
input clk;					//50MHz
input rst_n;				//�͵�ƽ��λ�ź�
	// SDRAMӲ���ӿ�
output sdram_cke;			// SDRAMʱ����Ч�ź�
output sdram_cs_n;			//	SDRAMƬѡ�ź�
output sdram_ras_n;			//	SDRAM�е�ַѡͨ����
output sdram_cas_n;			//	SDRAM�е�ַѡͨ����
output sdram_we_n;			//	SDRAMд����λ
output[1:0] sdram_ba;		//	SDRAM��L-Bank��ַ��
output[11:0] sdram_addr;	// SDRAM��ַ����
	// SDRAM��װ�ӿ�
input[21:0] sys_wraddr;		// дSDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
input[21:0] sys_rdaddr;		// ��SDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
input[8:0] sdwr_byte;		//ͻ��дSDRAM�ֽ�����1-256����
input[8:0] sdrd_byte;		//ͻ����SDRAM�ֽ�����1-256����
	// SDRAM�ڲ��ӿ�
input[3:0] init_state;		// SDRAM��ʼ��״̬�Ĵ���
input[3:0] work_state;		// SDRAM��д״̬�Ĵ���
input sys_r_wn;			// SDRAM��/д�����ź�
input[8:0] cnt_clk;		//ʱ�Ӽ���	


`include "sdram_para.v"		// ����SDRAM��������ģ��


//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
reg[4:0] sdram_cmd_r;	//	SDRAM��������
reg[1:0] sdram_ba_r;
reg[11:0] sdram_addr_r;

assign {sdram_cke,sdram_cs_n,sdram_ras_n,sdram_cas_n,sdram_we_n} = sdram_cmd_r;
assign sdram_ba = sdram_ba_r;
assign sdram_addr = sdram_addr_r;

//-------------------------------------------------------------------------------
	//SDRAM���������ֵ
wire[21:0] sys_addr;		// ��дSDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 	
assign sys_addr = sys_r_wn ? sys_rdaddr:sys_wraddr;		//��/д��ַ�����л�����
	
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			sdram_cmd_r <= `CMD_INIT;
			sdram_ba_r <= 2'b11;
			sdram_addr_r <= 12'hfff;
		end
	else
		case (init_state)
				`I_NOP,`I_TRP,`I_TRF1,`I_TRF2,`I_TMRD: begin
						sdram_cmd_r <= `CMD_NOP;
						sdram_ba_r <= 2'b11;
						sdram_addr_r <= 12'hfff;	
					end
				`I_PRE: begin
						sdram_cmd_r <= `CMD_PRGE;
						sdram_ba_r <= 2'b11;
						sdram_addr_r <= 12'hfff;
					end 
				`I_AR1,`I_AR2: begin
						sdram_cmd_r <= `CMD_A_REF;
						sdram_ba_r <= 2'b11;
						sdram_addr_r <= 12'hfff;						
					end 			 	
				`I_MRS: begin	//ģʽ�Ĵ������ã��ɸ���ʵ����Ҫ��������
						sdram_cmd_r <= `CMD_LMR;
						sdram_ba_r <= 2'b00;	//����ģʽ����
						sdram_addr_r <= {
                            2'b00,			//����ģʽ����
                            1'b0,			//����ģʽ����(��������ΪA9=0,��ͻ����/ͻ��д)
                            2'b00,			//����ģʽ����({A8,A7}=00),��ǰ����Ϊģʽ�Ĵ�������
                            3'b011,			// CASǱ��������(��������Ϊ3��{A6,A5,A4}=011)()
                            1'b0,			//ͻ�����䷽ʽ(��������Ϊ˳��A3=b0)
                            3'b111			//ͻ������(��������Ϊ256��{A2,A1,A0}=111)
								};
					end	
				`I_DONE:
					case (work_state)
							`W_IDLE,`W_TRCD,`W_CL,`W_TRFC,`W_TDAL: begin
									sdram_cmd_r <= `CMD_NOP;
									sdram_ba_r <= 2'b11;
									sdram_addr_r <= 12'hfff;
								end
							`W_ACTIVE: begin
									sdram_cmd_r <= `CMD_ACTIVE;
									sdram_ba_r <= sys_addr[21:20];	//L-Bank��ַ
									sdram_addr_r <= sys_addr[19:8];	//�е�ַ
								end
							`W_READ: begin
									sdram_cmd_r <= `CMD_READ;
									sdram_ba_r <= sys_addr[21:20];	//L-Bank��ַ
									sdram_addr_r <= {
													4'b0100,		// A10=1,����д�������Ԥ���
													sys_addr[7:0]	//�е�ַ  
												};
								end
							`W_RD: begin
									if(`end_rdburst) sdram_cmd_r <= `CMD_B_STOP;
									else begin
										sdram_cmd_r <= `CMD_NOP;
										sdram_ba_r <= 2'b11;
										sdram_addr_r <= 12'hfff;								
									end
								end								
							`W_WRITE: begin
									sdram_cmd_r <= `CMD_WRITE;
									sdram_ba_r <= sys_addr[21:20];	//L-Bank��ַ
									sdram_addr_r <= {
													4'b0100,		// A10=1,����д�������Ԥ���
													sys_addr[7:0]	//�е�ַ  
												};
								end		
							`W_WD: begin
									if(`end_wrburst) sdram_cmd_r <= `CMD_B_STOP;
									else begin
										sdram_cmd_r <= `CMD_NOP;
										sdram_ba_r <= 2'b11;
										sdram_addr_r <= 12'hfff;								
									end
								end													
							`W_AR: begin
									sdram_cmd_r <= `CMD_A_REF;
									sdram_ba_r <= 2'b11;
									sdram_addr_r <= 12'hfff;	
								end
							default: begin
									sdram_cmd_r <= `CMD_NOP;
									sdram_ba_r <= 2'b11;
									sdram_addr_r <= 12'hfff;	
								end
						endcase
				default: begin
							sdram_cmd_r <= `CMD_NOP;
							sdram_ba_r <= 2'b11;
							sdram_addr_r <= 12'hfff;	
						end
			endcase
end

endmodule

