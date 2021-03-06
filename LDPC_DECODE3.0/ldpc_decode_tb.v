`timescale 1ns/1ns
module ldpc_decode_tb;
reg clk;
reg rst_n;
reg ready;
reg en_din;
wire [7:0] d_in;
wire [7:0] d_out;
wire en_out;
wire f_out;
wire flag_out;

reg[7:0] RAM[1151:0];
reg[11:0] addr_RAM;
reg[7:0] ground_truth[1151:0];

ldpc_decode t0(clk,rst_n,ready,en_din,d_in,d_out,en_out,f_out,flag_out);

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		addr_RAM<=0;
	else if(en_din)
		addr_RAM<=addr_RAM+1'b1;

assign d_in=RAM[addr_RAM];



initial
begin
	$readmemb("D:/LDPC_DECODE3.0/work/decodedin0.txt",ground_truth);
	$readmemb("D:/LDPC_DECODE3.0/work/decodedin45.txt",RAM);
end
	
initial
begin
	$readmemb("D:/LDPC_DECODE3.0/work/H2nmsROM.txt",t0.z2.k1.H);

end


initial
begin
	clk=0;
forever #10 clk=~clk;
end

initial 
begin
	rst_n=1;
#15	rst_n=0;
#10 	rst_n=1;
end

initial 
begin
	ready=0;
#40 	ready=1;
#20	ready=0;
end

initial
begin
	en_din=0;
#60 	en_din=1;
#23040	en_din=0;
end

integer out_file;
initial 
begin
		out_file=$fopen("decode_out.txt","w");
end
	
always@(posedge clk)
	if(en_out)
		$fwrite(out_file,"%b\n",d_out[7:0]);



integer i,error;
initial
begin
	wait(en_out==1)
	begin
		for(i=0;i<1152;i=i+1)
			begin
				error=0;
				@(posedge clk)
				begin
					if(d_out!=ground_truth[i])
						error=error+1;
				end
			end
	end
end
	
	
endmodule
