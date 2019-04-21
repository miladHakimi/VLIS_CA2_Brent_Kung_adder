module brent_kung (
	input[15:0] data1, data2,
	output res	
);
	wire [15:0] init_p, init_g;
	wire [7:0]  first_layer_buffer_p, first_layer_buffer_g;
	wire [6:0]  black_cell_first_layer_g, black_cell_first_layer_p;
	
	wire[3:0] black_cell_second_layer_g, black_cell_second_layer_p;
	wire[3:0] second_layer_buffer_g, second_layer_buffer_p;

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
	
	generate
	for (index=1; index < 3; index=index+1)  
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

endmodule