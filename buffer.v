module buffer (
	input g_input, p_input,
	output g_output, p_output	
);
	buf(g_input, g_output);
	buf(p_input, p_output);
endmodule