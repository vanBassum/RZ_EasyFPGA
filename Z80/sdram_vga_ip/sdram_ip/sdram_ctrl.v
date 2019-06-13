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
// Description	: SDRAM״̬����ģ��
//							SDRAM��ʼ���Լ���ʱˢ�¡���д����
//				
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
module sdram_ctrl(
				clk,rst_n,
				/*sdram_udqm,sdram_ldqm,*/
				sdram_wr_req,sdram_rd_req,
				sdwr_byte,sdrd_byte,
				sdram_wr_ack,sdram_rd_ack,
				//sdram_busy,
				sdram_init_done,
				init_state,work_state,cnt_clk,sys_r_wn
			);
	//ϵͳ�źŽӿ�
input clk;				//ϵͳʱ�ӣ�50MHz
input rst_n;			//��λ�źţ��͵�ƽ��Ч

	// SDRAMӲ���ӿ�
//output sdram_udqm;	// SDRAM���ֽ�����
//output sdram_ldqm;	// SDRAM���ֽ�����
	// SDRAM��װ�ӿ�
input sdram_wr_req;			//ϵͳдSDRAM�����ź�
input sdram_rd_req;			//ϵͳ��SDRAM�����ź�
input[8:0] sdwr_byte;		//ͻ��дSDRAM�ֽ�����1-256����
input[8:0] sdrd_byte;		//ͻ����SDRAM�ֽ�����1-256����
output sdram_wr_ack;		//ϵͳдSDRAM��Ӧ�ź�,��ΪwrFIFO�������Ч�ź�
output sdram_rd_ack;		//ϵͳ��SDRAM��Ӧ�ź�	

output	sdram_init_done;		//ϵͳ��ʼ������ź�
//output sdram_busy;		// SDRAMæ��־λ���߱�ʾæ

	// SDRAM�ڲ��ӿ�
output[3:0] init_state;	// SDRAM��ʼ���Ĵ���
output[3:0] work_state;	// SDRAM����״̬�Ĵ���
output[8:0] cnt_clk;	//ʱ�Ӽ���
output sys_r_wn;		// SDRAM��/д�����ź�

wire done_200us;		//�ϵ��200us�����ȶ��ڽ�����־λ
//wire sdram_init_done;	// SDRAM��ʼ����ɱ�־���߱�ʾ���
wire sdram_busy;		// SDRAMæ��־���߱�ʾSDRAM���ڹ�����
reg sdram_ref_req;		// SDRAM��ˢ�������ź�
wire sdram_ref_ack;		// SDRAM��ˢ������Ӧ���ź�

`include "sdram_para.v"		// ����SDRAM��������ģ��

	// SDRAMʱ����ʱ����
parameter		TRP_CLK		= 9'd4,//1,	//TRP=18nsԤ�����Ч����
				TRFC_CLK	= 9'd6,//3,	//TRC=60ns�Զ�Ԥˢ������
				TMRD_CLK	= 9'd6,//2,	//ģʽ�Ĵ������õȴ�ʱ������
				TRCD_CLK	= 9'd2,//1,	//TRCD=18ns��ѡͨ����
				TCL_CLK		= 9'd3,		//Ǳ����TCL_CLK=3��CLK���ڳ�ʼ��ģʽ�Ĵ����п�����
				//TREAD_CLK	= 9'd256,//8,		//ͻ������������8CLK
				//TWRITE_CLK	= 9'd256,//8,  	//ͻ��д����8CLK
				TDAL_CLK	= 9'd3;		//д��ȴ�

//------------------------------------------------------------------------------
//assign sdram_udqm = 1'b0;	// SDRAM���ݸ��ֽ���Ч
//assign sdram_ldqm = 1'b0;	// SDRAM���ݵ��ֽ���Ч

//------------------------------------------------------------------------------
//�ϵ��200us��ʱ,��ʱʱ�䵽,��done_200us=1
//------------------------------------------------------------------------------
reg[14:0] cnt_200us; 
always @ (posedge clk or negedge rst_n) 
	if(!rst_n) cnt_200us <= 15'd0;
	else if(cnt_200us < 15'd20_000) cnt_200us <= cnt_200us+1'b1;	//����

assign done_200us = (cnt_200us == 15'd20_000);

//------------------------------------------------------------------------------
//SDRAM�ĳ�ʼ������״̬��
//------------------------------------------------------------------------------
reg[3:0] init_state_r;	// SDRAM��ʼ��״̬

always @ (posedge clk or negedge rst_n)
	if(!rst_n) init_state_r <= `I_NOP;
	else 
		case (init_state_r)
				`I_NOP: 	init_state_r <= done_200us ? `I_PRE:`I_NOP;		//�ϵ縴λ��200us�����������һ״̬
				`I_PRE: 	init_state_r <= `I_TRP;		//Ԥ���״̬
				`I_TRP: 	init_state_r <= (`end_trp) ? `I_AR1:`I_TRP;			//Ԥ���ȴ�TRP_CLK��ʱ������
				`I_AR1: 	init_state_r <= `I_TRF1;	//��1����ˢ��
				`I_TRF1:	init_state_r <= (`end_trfc) ? `I_AR2:`I_TRF1;			//�ȴ���1����ˢ�½���,TRFC_CLK��ʱ������
				`I_AR2: 	init_state_r <= `I_TRF2; 	//��2����ˢ��	
				`I_TRF2:	init_state_r <= (`end_trfc) ? `I_MRS:`I_TRF2; 		//�ȴ���2����ˢ�½���,TRFC_CLK��ʱ������
				`I_MRS:		init_state_r <= `I_TMRD;//ģʽ�Ĵ������ã�MRS��	
				`I_TMRD:	init_state_r <= (`end_tmrd) ? `I_DONE:`I_TMRD;		//�ȴ�ģʽ�Ĵ����������,TMRD_CLK��ʱ������
				`I_DONE:	init_state_r <= `I_DONE;		// SDRAM�ĳ�ʼ��������ɱ�־
				default: init_state_r <= `I_NOP;
				endcase


assign init_state = init_state_r;
assign sdram_init_done = (init_state_r == `I_DONE);		// SDRAM��ʼ����ɱ�־
//------------------------------------------------------------------------------
//15us��ʱ��ÿ60msȫ��4096�д洢������һ����ˢ��
// ( �洢���е��ݵ�������Ч������������64ms )
//------------------------------------------------------------------------------	 
reg[10:0] cnt_15us;	//�����Ĵ���
always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt_15us <= 11'd0;
	else if(cnt_15us < 11'd1499) cnt_15us <= cnt_15us+1'b1;	// 60ms(64ms)/4096=15usѭ������
	else cnt_15us <= 11'd0;	

always @ (posedge clk or negedge rst_n)
	if(!rst_n) sdram_ref_req <= 1'b0;
	else if(cnt_15us == 11'd1498) sdram_ref_req <= 1'b1;	//������ˢ������
	else if(sdram_ref_ack) sdram_ref_req <= 1'b0;		//����Ӧ��ˢ�� 

//------------------------------------------------------------------------------
//SDRAM�Ķ�д�Լ���ˢ�²���״̬��
//------------------------------------------------------------------------------
reg[3:0] work_state_r;	// SDRAM��д״̬
reg sys_r_wn;			// SDRAM��/д�����ź�

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) 
		work_state_r <= `W_IDLE;
	else
		begin
		case (work_state_r)
		//��ʼ������״̬
		`W_IDLE:	if(sdram_ref_req & sdram_init_done) 
						begin
						work_state_r <= `W_AR; 		//��ʱ��ˢ������
						sys_r_wn <= 1'b1;
						end 		
					else if(sdram_wr_req & sdram_init_done) 
						begin
						work_state_r <= `W_ACTIVE;	//дSDRAM
						sys_r_wn <= 1'b0;	
						end											
					else if(sdram_rd_req && sdram_init_done) 
						begin
						work_state_r <= `W_ACTIVE;	//��SDRAM
						sys_r_wn <= 1'b1;	
						end
					else 
						begin 
						work_state_r <= `W_IDLE;
						sys_r_wn <= 1'b1;
						end
		/*************************************************************/
		//����Ч״̬
		`W_ACTIVE: 	if(TRCD_CLK == 0)
						 if(sys_r_wn) work_state_r <= `W_READ;
						 else work_state_r <= `W_WRITE;
					else work_state_r <= `W_TRCD;
		//����Ч�ȴ�
		`W_TRCD:	 if(`end_trcd)
						 if(sys_r_wn) work_state_r <= `W_READ;
						 else work_state_r <= `W_WRITE;
					else work_state_r <= `W_TRCD;
					
		/*************************************************************/
		//������״̬
		`W_READ:	work_state_r <= `W_CL;	
		//�ȴ�Ǳ����
		`W_CL:		work_state_r <= (`end_tcl) ? `W_RD:`W_CL;	
		//������
		`W_RD:		work_state_r <= (`end_tread) ? `W_IDLE:`W_RD;
		//����ɺ��Ԥ���ȴ�״̬	
		`W_RWAIT:	work_state_r <= (`end_trwait) ? `W_IDLE:`W_RWAIT;
		
		/*************************************************************/
		//д����״̬
		`W_WRITE:	work_state_r <= `W_WD;
		//д����
		`W_WD:		work_state_r <= (`end_twrite) ? `W_TDAL:`W_WD;
		//�ȴ�д���ݲ���ˢ�½���
		`W_TDAL:	work_state_r <= (`end_tdal) ? `W_IDLE:`W_TDAL;
		
		/*************************************************************/
		//�Զ�ˢ��״̬
		`W_AR:		work_state_r <= `W_TRFC; 
		//��ˢ�µȴ�
		`W_TRFC:	work_state_r <= (`end_trfc) ? `W_IDLE:`W_TRFC;
		/*************************************************************/
		default: 	work_state_r <= `W_IDLE;
		endcase
		end
end

assign work_state = work_state_r;		// SDRAM����״̬�Ĵ���
assign sdram_ref_ack = (work_state_r == `W_AR);		// SDRAM��ˢ��Ӧ���ź�


//Ҫ��ǰһ��ʱ�Ӳ���д��
//дSDRAM��Ӧ�ź�
assign sdram_wr_ack = 	((work_state == `W_TRCD) & ~sys_r_wn) | 
						(work_state == `W_WRITE)|
						((work_state == `W_WD) & (cnt_clk_r < sdwr_byte -2'd2));		
//��SDRAM��Ӧ�ź�
assign sdram_rd_ack = 	(work_state_r == `W_RD) & 
						(cnt_clk_r >= 9'd1) & (cnt_clk_r < sdrd_byte + 2'd1);		

//assign sdram_busy = (sdram_init_done && work_state_r == `W_IDLE) ? 1'b0:1'b1;	// SDRAMæ��־λ

//------------------------------------------------------------------------------
//����SDRAMʱ���������ʱ
//------------------------------------------------------------------------------
reg[8:0] cnt_clk_r;	//ʱ�Ӽ���
reg cnt_rst_n;		//ʱ�Ӽ�����λ�ź�	

always @ (posedge clk or negedge rst_n) 
	if(!rst_n) cnt_clk_r <= 9'd0;			//�����Ĵ�����λ
	else if(!cnt_rst_n) cnt_clk_r <= 9'd0;	//�����Ĵ�������
	else cnt_clk_r <= cnt_clk_r+1'b1;		//����������ʱ
	
assign cnt_clk = cnt_clk_r;			//�����Ĵ����������ڲ�`define��ʹ�� 

	//�����������߼�
always @ (init_state_r or work_state_r or cnt_clk_r or sdwr_byte or sdrd_byte) begin
	case (init_state_r)
	    	`I_NOP:	cnt_rst_n <= 1'b0;
	   		`I_PRE:	cnt_rst_n <= 1'b1;	//Ԥ�����ʱ��������	
	   		`I_TRP:	cnt_rst_n <= (`end_trp) ? 1'b0:1'b1;	//�ȴ�Ԥ�����ʱ�������������������
	    	`I_AR1,`I_AR2:
	         		cnt_rst_n <= 1'b1;			//��ˢ����ʱ��������
	    	`I_TRF1,`I_TRF2:
	         		cnt_rst_n <= (`end_trfc) ? 1'b0:1'b1;	//�ȴ���ˢ����ʱ�������������������
			`I_MRS:	cnt_rst_n <= 1'b1;			//ģʽ�Ĵ���������ʱ��������
			`I_TMRD:	cnt_rst_n <= (`end_tmrd) ? 1'b0:1'b1;	//�ȴ���ˢ����ʱ�������������������
		   	`I_DONE:
				begin
				case (work_state_r)
				`W_IDLE:	cnt_rst_n <= 1'b0;
				`W_ACTIVE: 	cnt_rst_n <= 1'b1;
				`W_TRCD:	cnt_rst_n <= (`end_trcd) ? 1'b0:1'b1;
				`W_CL:		cnt_rst_n <= (`end_tcl) ? 1'b0:1'b1;
				`W_RD:		cnt_rst_n <= (`end_tread) ? 1'b0:1'b1;
				`W_RWAIT:	cnt_rst_n <= (`end_trwait) ? 1'b0:1'b1;
				`W_WD:		cnt_rst_n <= (`end_twrite) ? 1'b0:1'b1;
				`W_TDAL:	cnt_rst_n <= (`end_tdal) ? 1'b0:1'b1;
				`W_TRFC:	cnt_rst_n <= (`end_trfc) ? 1'b0:1'b1;
				default: cnt_rst_n <= 1'b0;
				endcase
				end
		default: cnt_rst_n <= 1'b0;
		endcase
end

endmodule
