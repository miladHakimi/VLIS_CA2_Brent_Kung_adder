module buffer (
	input g_input, p_input,
	output g_output, p_output	
);
	buf(g_output, g_input );
	buf(p_output, p_input);
endmodule