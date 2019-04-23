module Brent_Kung_tb ();
	reg[15:0]  data_1, data_2;
	wire [16:0] res;
	wire cin, res_true;
	Brent_Kung B(data_1, data_2, cin, res);

	assign res_true = res == (data_1 + data_2);
	integer seed1 = 1;
	assign cin = 1'b0;
	initial begin
		repeat(100) begin
			#10
			data_1 = {$random(seed1)} % 20000 ;
			data_2 = {$random(seed1)} % 20000 ;
			// data_1 = 15'd902;
			// data_2 = 15'd3932;

	  	end
		# 30;
	end
endmodule