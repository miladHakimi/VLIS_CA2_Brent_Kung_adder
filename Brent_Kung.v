module brent_kung (
	input[15:0] data1, data2,
	output res	
);
	wire [15:0] init_p, init_g;
	wire [7:0]  first_layer_buffer_p, first_layer_buffer_g;
	wire [6:0]  black_cell_first_layer_g, black_cell_first_layer_p;
	

	wire first_layer_gray_cell_out;

	// layer 1
	gray_cell gc_l1(init_g[1], init_p[1], init_g[0], first_layer_gray_cell_out);

	assign init_p = data1 ^ data2;
	assign init_g = data1 & data2;

	assign {first_layer_buffer_g[0], first_layer_buffer_p[0]} = 2'b0;
	
	genvar index;  
	generate  
	for (index=1; index < 8; index=index+1)  
	  begin: first_level_black_cells  
	    black_cell black_level_1(
	    	.G_i_to_k(init_g[2*index+1]), .P_i_to_k(init_p[2*index+1]), .G_k_to_j(init_g[2*index]), .P_k_to_j(init_p[2*index]), 
	    	.G_i_to_j(black_cell_first_layer_g[index-1]), .P_i_to_j(black_cell_first_layer_p[index-1])
	    );
	    buffer(init_g[index*2], init_p[index*2], first_layer_buffer_g[index], first_layer_buffer_p[index]);
	  end  
	endgenerate  
	
	// layer 2

	wire second_layer_gray_cell_out;
	wire[3:0] black_cell_second_layer_g, black_cell_second_layer_p;
	wire[3:0] second_layer_buffer_g, second_layer_buffer_p;

	gray_cell gc_l2(black_cell_first_layer_g[0], black_cell_first_layer_p[0], first_layer_gray_cell_out, second_layer_gray_cell_out);
	buf(first_layer_gray_cell_out, second_layer_buffer_g[0]);
	generate
	for (index=1; index < 4; index=index+1)  
	  begin: second_level_black_cells  
	    black_cell black_level_2(	
	    		black_cell_first_layer_g[2*index], 
	    		black_cell_first_layer_p[2*index],
	    		black_cell_first_layer_g[2*index-1],
	    		black_cell_first_layer_p[2*index-1],
	    				
				black_cell_second_layer_g[index],
				black_cell_second_layer_p[index]
	    );
	    buffer(
	    	black_cell_first_layer_g[index*2-1],
	    	black_cell_first_layer_p[index*2-1],
	     	second_layer_buffer_g[index], 
	     	second_layer_buffer_p[index]
	    );
	  end  
	endgenerate 

	// layer 3
	wire[1:0] third_layer_buffer_g, third_layer_buffer_p;
	wire black_cell_third_layer_g, black_cell_third_layer_p;
	wire third_layer_gray_cell_out;

	gray_cell gc_l3(black_cell_second_layer_g[0], black_cell_second_layer_p[0], second_layer_gray_cell_out, third_layer_gray_cell_out);
	buf(second_layer_gray_cell_out, third_layer_buffer_g[0]);
	buffer third_layer_buff(black_cell_second_layer_g[1], black_cell_second_layer_p[1], third_layer_buffer_g[1], third_layer_buffer_p[1]);
	black_cell bc_l3(
		black_cell_second_layer_g[2],
		black_cell_second_layer_p[2],
		black_cell_second_layer_g[1],
		black_cell_second_layer_p[1],
		black_cell_third_layer_g,
		black_cell_third_layer_p
		);

	// layer 4
	wire forth_layer_gray_cell_out;
	wire forth_layer_buffer_out;

	gray_cell gc_l4(black_cell_third_layer_g, black_cell_third_layer_p, third_layer_gray_cell_out, forth_layer_gray_cell_out);
	buf(third_layer_gray_cell_out, forth_layer_buffer_out);

	// layer 5
	wire fifth_layer_gray_cell_out;
	gray_cell gc_l5(third_layer_buffer_g[1], third_layer_buffer_p[1], forth_layer_buffer_out, fifth_layer_gray_cell_out);

	// layer 6
	wire [2:0] sixth_layer_gray_cell_out, sixth_layer_buffer_out;
	gray_cell gc_l6_0(
		second_layer_buffer_g[1],
		second_layer_buffer_g[1],
		third_layer_buffer_g[0],

		sixth_layer_gray_cell_out[0]
	);
	gray_cell gc_l6_1(
		second_layer_buffer_g[2],
		second_layer_buffer_p[2],
		forth_layer_buffer_out,

		sixth_layer_gray_cell_out[1]
	);

	gray_cell gc_l6_2(
		second_layer_buffer_g[3],
		second_layer_buffer_p[3],
		fifth_layer_gray_cell_out,

		sixth_layer_gray_cell_out[2]
	);

	buf(fifth_layer_gray_cell_out, sixth_layer_buffer_out[0]);
	buf(forth_layer_gray_cell_out, sixth_layer_buffer_out[1]);

endmodule