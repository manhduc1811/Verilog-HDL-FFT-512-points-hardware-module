module ROM_128(
	input clk,
	input in_valid,
	input rst_n,
	output reg [23:0] w_r,
	output reg [23:0] w_i,
	output reg[1:0] state
);
////////////////////////////////////////////
// Internal signals
reg [9:0] count,next_count;
reg [7:0] s_count,next_s_count;
////////////////////////////////////////////
// Next state logic
always @(*) begin
    if(in_valid)
    begin 
        next_count = count + 1;
        next_s_count = s_count;
    end
    else begin
        next_count = count;
        next_s_count = s_count;  
    end
    
    if (count<10'd128) 
        state = 2'd0;
    else if (count >= 10'd128 && s_count < 8'd128)begin
        state = 2'd1;
        next_s_count = s_count + 1;
    end
    else if (count >= 10'd128 && s_count >= 8'd128)begin
        state = 2'd2;
        next_s_count = s_count + 1;
    end

	case(s_count)
	8'd128: begin 
	 w_r = 24'b 000000000000000100000000;
	 w_i = 24'b 000000000000000000000000;
	 end
	8'd129: begin 
	 w_r = 24'b 000000000000000100000000;
	 w_i = 24'b 111111111111111111111010;
	 end
	8'd130: begin 
	 w_r = 24'b 000000000000000100000000;
	 w_i = 24'b 111111111111111111110011;
	 end
	8'd131: begin 
	 w_r = 24'b 000000000000000011111111;
	 w_i = 24'b 111111111111111111101101;
	 end
	8'd132: begin 
	 w_r = 24'b 000000000000000011111111;
	 w_i = 24'b 111111111111111111100111;
	 end
	8'd133: begin 
	 w_r = 24'b 000000000000000011111110;
	 w_i = 24'b 111111111111111111100001;
	 end
	8'd134: begin 
	 w_r = 24'b 000000000000000011111101;
	 w_i = 24'b 111111111111111111011010;
	 end
	8'd135: begin 
	 w_r = 24'b 000000000000000011111100;
	 w_i = 24'b 111111111111111111010100;
	 end
	8'd136: begin 
	 w_r = 24'b 000000000000000011111011;
	 w_i = 24'b 111111111111111111001110;
	 end
	8'd137: begin 
	 w_r = 24'b 000000000000000011111010;
	 w_i = 24'b 111111111111111111001000;
	 end
	8'd138: begin 
	 w_r = 24'b 000000000000000011111000;
	 w_i = 24'b 111111111111111111000010;
	 end
	8'd139: begin 
	 w_r = 24'b 000000000000000011110111;
	 w_i = 24'b 111111111111111110111100;
	 end
	8'd140: begin 
	 w_r = 24'b 000000000000000011110101;
	 w_i = 24'b 111111111111111110110110;
	 end
	8'd141: begin 
	 w_r = 24'b 000000000000000011110011;
	 w_i = 24'b 111111111111111110110000;
	 end
	8'd142: begin 
	 w_r = 24'b 000000000000000011110001;
	 w_i = 24'b 111111111111111110101010;
	 end
	8'd143: begin 
	 w_r = 24'b 000000000000000011101111;
	 w_i = 24'b 111111111111111110100100;
	 end
	8'd144: begin 
	 w_r = 24'b 000000000000000011101101;
	 w_i = 24'b 111111111111111110011110;
	 end
	8'd145: begin 
	 w_r = 24'b 000000000000000011101010;
	 w_i = 24'b 111111111111111110011000;
	 end
	8'd146: begin 
	 w_r = 24'b 000000000000000011100111;
	 w_i = 24'b 111111111111111110010011;
	 end
	8'd147: begin 
	 w_r = 24'b 000000000000000011100101;
	 w_i = 24'b 111111111111111110001101;
	 end
	8'd148: begin 
	 w_r = 24'b 000000000000000011100010;
	 w_i = 24'b 111111111111111110000111;
	 end
	8'd149: begin 
	 w_r = 24'b 000000000000000011011111;
	 w_i = 24'b 111111111111111110000010;
	 end
	8'd150: begin 
	 w_r = 24'b 000000000000000011011100;
	 w_i = 24'b 111111111111111101111100;
	 end
	8'd151: begin 
	 w_r = 24'b 000000000000000011011000;
	 w_i = 24'b 111111111111111101110111;
	 end
	8'd152: begin 
	 w_r = 24'b 000000000000000011010101;
	 w_i = 24'b 111111111111111101110010;
	 end
	8'd153: begin 
	 w_r = 24'b 000000000000000011010001;
	 w_i = 24'b 111111111111111101101101;
	 end
	8'd154: begin 
	 w_r = 24'b 000000000000000011001110;
	 w_i = 24'b 111111111111111101101000;
	 end
	8'd155: begin 
	 w_r = 24'b 000000000000000011001010;
	 w_i = 24'b 111111111111111101100011;
	 end
	8'd156: begin 
	 w_r = 24'b 000000000000000011000110;
	 w_i = 24'b 111111111111111101011110;
	 end
	8'd157: begin 
	 w_r = 24'b 000000000000000011000010;
	 w_i = 24'b 111111111111111101011001;
	 end
	8'd158: begin 
	 w_r = 24'b 000000000000000010111110;
	 w_i = 24'b 111111111111111101010100;
	 end
	8'd159: begin 
	 w_r = 24'b 000000000000000010111001;
	 w_i = 24'b 111111111111111101001111;
	 end
	8'd160: begin 
	 w_r = 24'b 000000000000000010110101;
	 w_i = 24'b 111111111111111101001011;
	 end
	8'd161: begin 
	 w_r = 24'b 000000000000000010110001;
	 w_i = 24'b 111111111111111101000111;
	 end
	8'd162: begin 
	 w_r = 24'b 000000000000000010101100;
	 w_i = 24'b 111111111111111101000010;
	 end
	8'd163: begin 
	 w_r = 24'b 000000000000000010100111;
	 w_i = 24'b 111111111111111100111110;
	 end
	8'd164: begin 
	 w_r = 24'b 000000000000000010100010;
	 w_i = 24'b 111111111111111100111010;
	 end
	8'd165: begin 
	 w_r = 24'b 000000000000000010011101;
	 w_i = 24'b 111111111111111100110110;
	 end
	8'd166: begin 
	 w_r = 24'b 000000000000000010011000;
	 w_i = 24'b 111111111111111100110010;
	 end
	8'd167: begin 
	 w_r = 24'b 000000000000000010010011;
	 w_i = 24'b 111111111111111100101111;
	 end
	8'd168: begin 
	 w_r = 24'b 000000000000000010001110;
	 w_i = 24'b 111111111111111100101011;
	 end
	8'd169: begin 
	 w_r = 24'b 000000000000000010001001;
	 w_i = 24'b 111111111111111100101000;
	 end
	8'd170: begin 
	 w_r = 24'b 000000000000000010000100;
	 w_i = 24'b 111111111111111100100100;
	 end
	8'd171: begin 
	 w_r = 24'b 000000000000000001111110;
	 w_i = 24'b 111111111111111100100001;
	 end
	8'd172: begin 
	 w_r = 24'b 000000000000000001111001;
	 w_i = 24'b 111111111111111100011110;
	 end
	8'd173: begin 
	 w_r = 24'b 000000000000000001110011;
	 w_i = 24'b 111111111111111100011011;
	 end
	8'd174: begin 
	 w_r = 24'b 000000000000000001101101;
	 w_i = 24'b 111111111111111100011001;
	 end
	8'd175: begin 
	 w_r = 24'b 000000000000000001101000;
	 w_i = 24'b 111111111111111100010110;
	 end
	8'd176: begin 
	 w_r = 24'b 000000000000000001100010;
	 w_i = 24'b 111111111111111100010011;
	 end
	8'd177: begin 
	 w_r = 24'b 000000000000000001011100;
	 w_i = 24'b 111111111111111100010001;
	 end
	8'd178: begin 
	 w_r = 24'b 000000000000000001010110;
	 w_i = 24'b 111111111111111100001111;
	 end
	8'd179: begin 
	 w_r = 24'b 000000000000000001010000;
	 w_i = 24'b 111111111111111100001101;
	 end
	8'd180: begin 
	 w_r = 24'b 000000000000000001001010;
	 w_i = 24'b 111111111111111100001011;
	 end
	8'd181: begin 
	 w_r = 24'b 000000000000000001000100;
	 w_i = 24'b 111111111111111100001001;
	 end
	8'd182: begin 
	 w_r = 24'b 000000000000000000111110;
	 w_i = 24'b 111111111111111100001000;
	 end
	8'd183: begin 
	 w_r = 24'b 000000000000000000111000;
	 w_i = 24'b 111111111111111100000110;
	 end
	8'd184: begin 
	 w_r = 24'b 000000000000000000110010;
	 w_i = 24'b 111111111111111100000101;
	 end
	8'd185: begin 
	 w_r = 24'b 000000000000000000101100;
	 w_i = 24'b 111111111111111100000100;
	 end
	8'd186: begin 
	 w_r = 24'b 000000000000000000100110;
	 w_i = 24'b 111111111111111100000011;
	 end
	8'd187: begin 
	 w_r = 24'b 000000000000000000011111;
	 w_i = 24'b 111111111111111100000010;
	 end
	8'd188: begin 
	 w_r = 24'b 000000000000000000011001;
	 w_i = 24'b 111111111111111100000001;
	 end
	8'd189: begin 
	 w_r = 24'b 000000000000000000010011;
	 w_i = 24'b 111111111111111100000001;
	 end
	8'd190: begin 
	 w_r = 24'b 000000000000000000001101;
	 w_i = 24'b 111111111111111100000000;
	 end
	8'd191: begin 
	 w_r = 24'b 000000000000000000000110;
	 w_i = 24'b 111111111111111100000000;
	 end
	8'd192: begin 
	 w_r = 24'b 000000000000000000000000;
	 w_i = 24'b 111111111111111100000000;
	 end
	8'd193: begin 
	 w_r = 24'b 111111111111111111111010;
	 w_i = 24'b 111111111111111100000000;
	 end
	8'd194: begin 
	 w_r = 24'b 111111111111111111110011;
	 w_i = 24'b 111111111111111100000000;
	 end
	8'd195: begin 
	 w_r = 24'b 111111111111111111101101;
	 w_i = 24'b 111111111111111100000001;
	 end
	8'd196: begin 
	 w_r = 24'b 111111111111111111100111;
	 w_i = 24'b 111111111111111100000001;
	 end
	8'd197: begin 
	 w_r = 24'b 111111111111111111100001;
	 w_i = 24'b 111111111111111100000010;
	 end
	8'd198: begin 
	 w_r = 24'b 111111111111111111011010;
	 w_i = 24'b 111111111111111100000011;
	 end
	8'd199: begin 
	 w_r = 24'b 111111111111111111010100;
	 w_i = 24'b 111111111111111100000100;
	 end
	8'd200: begin 
	 w_r = 24'b 111111111111111111001110;
	 w_i = 24'b 111111111111111100000101;
	 end
	8'd201: begin 
	 w_r = 24'b 111111111111111111001000;
	 w_i = 24'b 111111111111111100000110;
	 end
	8'd202: begin 
	 w_r = 24'b 111111111111111111000010;
	 w_i = 24'b 111111111111111100001000;
	 end
	8'd203: begin 
	 w_r = 24'b 111111111111111110111100;
	 w_i = 24'b 111111111111111100001001;
	 end
	8'd204: begin 
	 w_r = 24'b 111111111111111110110110;
	 w_i = 24'b 111111111111111100001011;
	 end
	8'd205: begin 
	 w_r = 24'b 111111111111111110110000;
	 w_i = 24'b 111111111111111100001101;
	 end
	8'd206: begin 
	 w_r = 24'b 111111111111111110101010;
	 w_i = 24'b 111111111111111100001111;
	 end
	8'd207: begin 
	 w_r = 24'b 111111111111111110100100;
	 w_i = 24'b 111111111111111100010001;
	 end
	8'd208: begin 
	 w_r = 24'b 111111111111111110011110;
	 w_i = 24'b 111111111111111100010011;
	 end
	8'd209: begin 
	 w_r = 24'b 111111111111111110011000;
	 w_i = 24'b 111111111111111100010110;
	 end
	8'd210: begin 
	 w_r = 24'b 111111111111111110010011;
	 w_i = 24'b 111111111111111100011001;
	 end
	8'd211: begin 
	 w_r = 24'b 111111111111111110001101;
	 w_i = 24'b 111111111111111100011011;
	 end
	8'd212: begin 
	 w_r = 24'b 111111111111111110000111;
	 w_i = 24'b 111111111111111100011110;
	 end
	8'd213: begin 
	 w_r = 24'b 111111111111111110000010;
	 w_i = 24'b 111111111111111100100001;
	 end
	8'd214: begin 
	 w_r = 24'b 111111111111111101111100;
	 w_i = 24'b 111111111111111100100100;
	 end
	8'd215: begin 
	 w_r = 24'b 111111111111111101110111;
	 w_i = 24'b 111111111111111100101000;
	 end
	8'd216: begin 
	 w_r = 24'b 111111111111111101110010;
	 w_i = 24'b 111111111111111100101011;
	 end
	8'd217: begin 
	 w_r = 24'b 111111111111111101101101;
	 w_i = 24'b 111111111111111100101111;
	 end
	8'd218: begin 
	 w_r = 24'b 111111111111111101101000;
	 w_i = 24'b 111111111111111100110010;
	 end
	8'd219: begin 
	 w_r = 24'b 111111111111111101100011;
	 w_i = 24'b 111111111111111100110110;
	 end
	8'd220: begin 
	 w_r = 24'b 111111111111111101011110;
	 w_i = 24'b 111111111111111100111010;
	 end
	8'd221: begin 
	 w_r = 24'b 111111111111111101011001;
	 w_i = 24'b 111111111111111100111110;
	 end
	8'd222: begin 
	 w_r = 24'b 111111111111111101010100;
	 w_i = 24'b 111111111111111101000010;
	 end
	8'd223: begin 
	 w_r = 24'b 111111111111111101001111;
	 w_i = 24'b 111111111111111101000111;
	 end
	8'd224: begin 
	 w_r = 24'b 111111111111111101001011;
	 w_i = 24'b 111111111111111101001011;
	 end
	8'd225: begin 
	 w_r = 24'b 111111111111111101000111;
	 w_i = 24'b 111111111111111101001111;
	 end
	8'd226: begin 
	 w_r = 24'b 111111111111111101000010;
	 w_i = 24'b 111111111111111101010100;
	 end
	8'd227: begin 
	 w_r = 24'b 111111111111111100111110;
	 w_i = 24'b 111111111111111101011001;
	 end
	8'd228: begin 
	 w_r = 24'b 111111111111111100111010;
	 w_i = 24'b 111111111111111101011110;
	 end
	8'd229: begin 
	 w_r = 24'b 111111111111111100110110;
	 w_i = 24'b 111111111111111101100011;
	 end
	8'd230: begin 
	 w_r = 24'b 111111111111111100110010;
	 w_i = 24'b 111111111111111101101000;
	 end
	8'd231: begin 
	 w_r = 24'b 111111111111111100101111;
	 w_i = 24'b 111111111111111101101101;
	 end
	8'd232: begin 
	 w_r = 24'b 111111111111111100101011;
	 w_i = 24'b 111111111111111101110010;
	 end
	8'd233: begin 
	 w_r = 24'b 111111111111111100101000;
	 w_i = 24'b 111111111111111101110111;
	 end
	8'd234: begin 
	 w_r = 24'b 111111111111111100100100;
	 w_i = 24'b 111111111111111101111100;
	 end
	8'd235: begin 
	 w_r = 24'b 111111111111111100100001;
	 w_i = 24'b 111111111111111110000010;
	 end
	8'd236: begin 
	 w_r = 24'b 111111111111111100011110;
	 w_i = 24'b 111111111111111110000111;
	 end
	8'd237: begin 
	 w_r = 24'b 111111111111111100011011;
	 w_i = 24'b 111111111111111110001101;
	 end
	8'd238: begin 
	 w_r = 24'b 111111111111111100011001;
	 w_i = 24'b 111111111111111110010011;
	 end
	8'd239: begin 
	 w_r = 24'b 111111111111111100010110;
	 w_i = 24'b 111111111111111110011000;
	 end
	8'd240: begin 
	 w_r = 24'b 111111111111111100010011;
	 w_i = 24'b 111111111111111110011110;
	 end
	8'd241: begin 
	 w_r = 24'b 111111111111111100010001;
	 w_i = 24'b 111111111111111110100100;
	 end
	8'd242: begin 
	 w_r = 24'b 111111111111111100001111;
	 w_i = 24'b 111111111111111110101010;
	 end
	8'd243: begin 
	 w_r = 24'b 111111111111111100001101;
	 w_i = 24'b 111111111111111110110000;
	 end
	8'd244: begin 
	 w_r = 24'b 111111111111111100001011;
	 w_i = 24'b 111111111111111110110110;
	 end
	8'd245: begin 
	 w_r = 24'b 111111111111111100001001;
	 w_i = 24'b 111111111111111110111100;
	 end
	8'd246: begin 
	 w_r = 24'b 111111111111111100001000;
	 w_i = 24'b 111111111111111111000010;
	 end
	8'd247: begin 
	 w_r = 24'b 111111111111111100000110;
	 w_i = 24'b 111111111111111111001000;
	 end
	8'd248: begin 
	 w_r = 24'b 111111111111111100000101;
	 w_i = 24'b 111111111111111111001110;
	 end
	8'd249: begin 
	 w_r = 24'b 111111111111111100000100;
	 w_i = 24'b 111111111111111111010100;
	 end
	8'd250: begin 
	 w_r = 24'b 111111111111111100000011;
	 w_i = 24'b 111111111111111111011010;
	 end
	8'd251: begin 
	 w_r = 24'b 111111111111111100000010;
	 w_i = 24'b 111111111111111111100001;
	 end
	8'd252: begin 
	 w_r = 24'b 111111111111111100000001;
	 w_i = 24'b 111111111111111111100111;
	 end
	8'd253: begin 
	 w_r = 24'b 111111111111111100000001;
	 w_i = 24'b 111111111111111111101101;
	 end
	8'd254: begin 
	 w_r = 24'b 111111111111111100000000;
	 w_i = 24'b 111111111111111111110011;
	 end
	8'd255: begin 
	 w_r = 24'b 111111111111111100000000;
	 w_i = 24'b 111111111111111111111010;
	 end
	default: begin 
	 w_r = 24'b 000000000000000100000000;
	 w_i = 24'b 000000000000000000000000;
	 end
	endcase
end
////////////////////////////////////////////
// State register
always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        count <= 0;
        s_count <= 0;
    end
    else begin
        count <= next_count;
        s_count <= next_s_count;
    end
end
endmodule