module FFT512(
	input                     clk,
	input                     rst_n,
	input                     in_valid,
	input signed       [11:0] din_r,
	input signed       [11:0] din_i,
	output                    out_valid,
	output reg signed  [15:0] dout_r,
	output reg signed  [15:0] dout_i
);
////////////////////////////////////////////////////////////////////////////
// Internal signals
integer            i;
reg signed  [15:0] result_r        [0:511];
reg signed  [15:0] result_i        [0:511];
reg signed  [15:0] result_r_ns     [0:511];
reg signed  [15:0] result_i_ns     [0:511];
reg signed  [15:0] next_dout_r;
reg signed  [15:0] next_dout_i;
reg         [9:0]  count_y;
reg         [9:0]  next_count_y;
reg signed  [23:0] din_r_reg,din_i_reg;
reg                in_valid_reg,r8_valid,next_r8_valid;
reg         [1:0]  no9_state;
reg                s9_count,next_s9_count;
reg                next_over,over;
reg                assign_out;
reg                next_out_valid;
reg         [8:0]  y_1_delay;
wire        [23:0] out_r,out_i;
wire        [8:0]  y_1;
wire        [23:0] din_r_wire,din_i_wire;
///////////////////
wire [1:0]  rom256_state;
wire [23:0] rom256_w_r,rom256_w_i;
wire [23:0] shift_256_dout_r,shift_256_dout_i;
wire [23:0] radix_no1_delay_r,radix_no1_delay_i;
wire [23:0] radix_no1_op_r,radix_no1_op_i;
wire radix_no1_outvalid;
///////////////////
wire [1:0]  rom128_state;
wire [23:0] rom128_w_r,rom128_w_i;
wire [23:0] shift_128_dout_r,shift_128_dout_i;
wire [23:0] radix_no2_delay_r,radix_no2_delay_i;
wire [23:0] radix_no2_op_r,radix_no2_op_i;
wire radix_no2_outvalid;
///////////////////
wire [1:0] rom64_state;
wire [23:0]rom64_w_r,rom64_w_i;
wire [23:0]shift_64_dout_r,shift_64_dout_i;
wire [23:0]radix_no3_delay_r,radix_no3_delay_i;
wire [23:0]radix_no3_op_r,radix_no3_op_i;
wire radix_no3_outvalid;
///////////////////
wire [1:0] rom32_state;
wire [23:0]rom32_w_r,rom32_w_i;
wire [23:0]shift_32_dout_r,shift_32_dout_i;
wire [23:0]radix_no4_delay_r,radix_no4_delay_i;
wire [23:0]radix_no4_op_r,radix_no4_op_i;
wire radix_no4_outvalid;
///////////////////
wire [1:0] rom16_state;
wire [23:0]rom16_w_r,rom16_w_i;
wire [23:0]shift_16_dout_r,shift_16_dout_i;
wire [23:0]radix_no5_delay_r,radix_no5_delay_i;
wire [23:0]radix_no5_op_r,radix_no5_op_i;
wire radix_no5_outvalid;
///////////////////
wire [1:0] rom8_state;
wire [23:0]rom8_w_r,rom8_w_i;
wire [23:0]shift_8_dout_r,shift_8_dout_i;
wire [23:0]radix_no6_delay_r,radix_no6_delay_i;
wire [23:0]radix_no6_op_r,radix_no6_op_i;
wire radix_no6_outvalid;
///////////////////
wire [1:0] rom4_state;
wire [23:0]rom4_w_r,rom4_w_i;
wire [23:0]shift_4_dout_r,shift_4_dout_i;
wire [23:0]radix_no7_delay_r,radix_no7_delay_i;
wire [23:0]radix_no7_op_r,radix_no7_op_i;
wire radix_no7_outvalid;
///////////////////
wire [1:0] rom2_state;
wire [23:0]rom2_w_r,rom2_w_i;
wire [23:0]shift_2_dout_r,shift_2_dout_i;
wire [23:0]radix_no8_delay_r,radix_no8_delay_i;
wire [23:0]radix_no8_op_r,radix_no8_op_i;
wire radix_no8_outvalid;
///////////////////
wire [23:0]shift_1_dout_r,shift_1_dout_i;
wire [23:0]radix_no9_delay_r,radix_no9_delay_i;
wire [23:0]radix_no9_op_r,radix_no9_op_i;
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////Step 1///////
radix2 radix_no1(
.state(rom256_state),//state ctrl
.din_a_r(shift_256_dout_r),//fb
.din_a_i(shift_256_dout_i),//fb
.din_b_r(din_r_wire),//input
.din_b_i(din_i_wire),//input
.w_r(rom256_w_r),//twindle_r
.w_i(rom256_w_i),//twindle_i
.op_r(radix_no1_op_r),
.op_i(radix_no1_op_i),
.delay_r(radix_no1_delay_r),
.delay_i(radix_no1_delay_i),
.outvalid(radix_no1_outvalid)
);
shift_256 shift_256(
.clk(clk),.rst_n(rst_n),
.in_valid(in_valid_reg),
.din_r(radix_no1_delay_r),
.din_i(radix_no1_delay_i),
.dout_r(shift_256_dout_r),
.dout_i(shift_256_dout_i)
);
ROM_256 rom256(
.clk(clk),
.in_valid(in_valid_reg),
.rst_n(rst_n),
.w_r(rom256_w_r),
.w_i(rom256_w_i),
.state(rom256_state)
);
////////////////////////////////////Step 2///////
radix2 radix_no2(
.state(rom128_state),//state ctrl
.din_a_r(shift_128_dout_r),//fb
.din_a_i(shift_128_dout_i),//fb
.din_b_r(radix_no1_op_r),//input
.din_b_i(radix_no1_op_i),//input
.w_r(rom128_w_r),//twindle
.w_i(rom128_w_i),//d
.op_r(radix_no2_op_r),
.op_i(radix_no2_op_i),
.delay_r(radix_no2_delay_r),
.delay_i(radix_no2_delay_i),
.outvalid(radix_no2_outvalid)
);
shift_128 shift_128(
.clk(clk),.rst_n(rst_n),
.in_valid(radix_no1_outvalid),
.din_r(radix_no2_delay_r),
.din_i(radix_no2_delay_i),
.dout_r(shift_128_dout_r),
.dout_i(shift_128_dout_i)
);
ROM_128 rom128(
.clk(clk),
.in_valid(radix_no1_outvalid),
.rst_n(rst_n),
.w_r(rom128_w_r),
.w_i(rom128_w_i),
.state(rom128_state)
);
////////////////////////////////////Step 3///////
radix2 radix_no3(
.state(rom64_state),//state ctrl
.din_a_r(shift_64_dout_r),//fb
.din_a_i(shift_64_dout_i),//fb
.din_b_r(radix_no2_op_r),//input
.din_b_i(radix_no2_op_i),//input
.w_r(rom64_w_r),//twindle
.w_i(rom64_w_i),//d
.op_r(radix_no3_op_r),
.op_i(radix_no3_op_i),
.delay_r(radix_no3_delay_r),
.delay_i(radix_no3_delay_i),
.outvalid(radix_no3_outvalid)
);
shift_64 shift_64(
.clk(clk),.rst_n(rst_n),
.in_valid(radix_no2_outvalid),
.din_r(radix_no3_delay_r),
.din_i(radix_no3_delay_i),
.dout_r(shift_64_dout_r),
.dout_i(shift_64_dout_i)  
);
ROM_64 rom64(
.clk(clk),
.in_valid(radix_no2_outvalid),
.rst_n(rst_n),
.w_r(rom64_w_r),
.w_i(rom64_w_i),
.state(rom64_state)
);
////////////////////////////////////Step 4///////
radix2 radix_no4(
.state(rom32_state),//state ctrl
.din_a_r(shift_32_dout_r),//fb
.din_a_i(shift_32_dout_i),//fb
.din_b_r(radix_no3_op_r),//input
.din_b_i(radix_no3_op_i),//input
.w_r(rom32_w_r),//twindle
.w_i(rom32_w_i),//d
.op_r(radix_no4_op_r),
.op_i(radix_no4_op_i),
.delay_r(radix_no4_delay_r),
.delay_i(radix_no4_delay_i),
.outvalid(radix_no4_outvalid)
);
shift_32 shift_32(
.clk(clk),.rst_n(rst_n),
.in_valid(radix_no3_outvalid),
.din_r(radix_no4_delay_r),
.din_i(radix_no4_delay_i),
.dout_r(shift_32_dout_r),
.dout_i(shift_32_dout_i)
);
ROM_32 rom32(
.clk(clk),
.in_valid(radix_no3_outvalid),
.rst_n(rst_n),
.w_r(rom32_w_r),
.w_i(rom32_w_i),
.state(rom32_state)
);
////////////////////////////////////Step 5///////
radix2 radix_no5(
.state(rom16_state),//state ctrl
.din_a_r(shift_16_dout_r),//fb
.din_a_i(shift_16_dout_i),//fb
.din_b_r(radix_no4_op_r),//input
.din_b_i(radix_no4_op_i),//input
.w_r(rom16_w_r),//twindle
.w_i(rom16_w_i),//d
.op_r(radix_no5_op_r),
.op_i(radix_no5_op_i),
.delay_r(radix_no5_delay_r),
.delay_i(radix_no5_delay_i),
.outvalid(radix_no5_outvalid)
);
shift_16 shift_16(
.clk(clk),.rst_n(rst_n),
.in_valid(radix_no4_outvalid),
.din_r(radix_no5_delay_r),
.din_i(radix_no5_delay_i),
.dout_r(shift_16_dout_r),
.dout_i(shift_16_dout_i)
);
ROM_16 rom16(
.clk(clk),
.in_valid(radix_no4_outvalid),
.rst_n(rst_n),
.w_r(rom16_w_r),
.w_i(rom16_w_i),
.state(rom16_state)
);
////////////////////////////////////Step 6///////
radix2 radix_no6(
.state(rom8_state),//state ctrl
.din_a_r(shift_8_dout_r),//fb
.din_a_i(shift_8_dout_i),//fb
.din_b_r(radix_no5_op_r),//input
.din_b_i(radix_no5_op_i),//input
.w_r(rom8_w_r),//twindle
.w_i(rom8_w_i),//d
.op_r(radix_no6_op_r),
.op_i(radix_no6_op_i),
.delay_r(radix_no6_delay_r),
.delay_i(radix_no6_delay_i),
.outvalid(radix_no6_outvalid)
);
shift_8 shift_8(
.clk(clk),.rst_n(rst_n),
.in_valid(radix_no5_outvalid),
.din_r(radix_no6_delay_r),
.din_i(radix_no6_delay_i),
.dout_r(shift_8_dout_r),
.dout_i(shift_8_dout_i)
);
ROM_8 rom8(
.clk(clk),
.in_valid(radix_no5_outvalid),
.rst_n(rst_n),
.w_r(rom8_w_r),
.w_i(rom8_w_i),
.state(rom8_state)
);
////////////////////////////////////Step 7///////
radix2 radix_no7(
.state(rom4_state),//state ctrl
.din_a_r(shift_4_dout_r),//fb
.din_a_i(shift_4_dout_i),//fb
.din_b_r(radix_no6_op_r),//input
.din_b_i(radix_no6_op_i),//input
.w_r(rom4_w_r),//twindle
.w_i(rom4_w_i),//d
.op_r(radix_no7_op_r),
.op_i(radix_no7_op_i),
.delay_r(radix_no7_delay_r),
.delay_i(radix_no7_delay_i),
.outvalid(radix_no7_outvalid)
);
shift_4 shift_4(
.clk(clk),.rst_n(rst_n),
.in_valid(radix_no6_outvalid),
.din_r(radix_no7_delay_r),
.din_i(radix_no7_delay_i),
.dout_r(shift_4_dout_r),
.dout_i(shift_4_dout_i)
);
ROM_4 rom4(
.clk(clk),
.in_valid(radix_no6_outvalid),
.rst_n(rst_n),
.w_r(rom4_w_r),
.w_i(rom4_w_i),
.state(rom4_state)
);
////////////////////////////////////Step 8///////
radix2 radix_no8(
.state(rom2_state),//state ctrl
.din_a_r(shift_2_dout_r),//fb
.din_a_i(shift_2_dout_i),//fb
.din_b_r(radix_no7_op_r),//input
.din_b_i(radix_no7_op_i),//input
.w_r(rom2_w_r),//twindle
.w_i(rom2_w_i),//d
.op_r(radix_no8_op_r),
.op_i(radix_no8_op_i),
.delay_r(radix_no8_delay_r),
.delay_i(radix_no8_delay_i),
.outvalid(radix_no8_outvalid)
);
shift_2 shift_2(
.clk(clk),.rst_n(rst_n),
.in_valid(radix_no7_outvalid),
.din_r(radix_no8_delay_r),
.din_i(radix_no8_delay_i),
.dout_r(shift_2_dout_r),
.dout_i(shift_2_dout_i)
);
ROM_2 rom2(
.clk(clk),
.in_valid(radix_no7_outvalid),
.rst_n(rst_n),
.w_r(rom2_w_r),
.w_i(rom2_w_i),
.state(rom2_state)
);
////////////////////////////////////Step 9///////
radix2 radix_no9(
.state(no9_state),//state ctrl
.din_a_r(shift_1_dout_r),//fb
.din_a_i(shift_1_dout_i),//fb
.din_b_r(radix_no8_op_r),//input
.din_b_i(radix_no8_op_i),//input
.w_r(24'd256),//twindle
.w_i(24'd0),//d
.op_r(out_r),
.op_i(out_i),
.delay_r(radix_no9_delay_r),
.delay_i(radix_no9_delay_i),
.outvalid()
);
shift_1 shift_1(
.clk(clk),.rst_n(rst_n),
.in_valid(radix_no8_outvalid),
.din_r(radix_no9_delay_r),
.din_i(radix_no9_delay_i),
.dout_r(shift_1_dout_r),
.dout_i(shift_1_dout_i)
);
////////////////////////////////////////////////////////////////////////////
// Next state logic
always@(*)begin
    next_r8_valid              = radix_no8_outvalid;
    if (r8_valid)next_s9_count = s9_count + 1;
    else next_s9_count         = s9_count;
    
    if(r8_valid && s9_count == 1'b0)     no9_state = 2'b01;
    else if(r8_valid && s9_count == 1'b1)no9_state = 2'b10;
    else no9_state = 2'b00;

    if(radix_no8_outvalid) next_count_y = count_y + 9'd1;
    else next_count_y = count_y;

    if(next_out_valid) begin
        next_dout_r = result_r[y_1_delay];
        next_dout_i = result_i[y_1_delay];
    end
    else begin
        next_dout_r = dout_r;
        next_dout_i = dout_i;
    end
end
////////////////////////////////////////////////////////////////////////////
// State register
always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        din_r_reg 		<= 0;
        din_i_reg 		<= 0;
        in_valid_reg 	<= 0;
        s9_count 		<= 0;
        r8_valid 		<= 0;
        count_y 		<= 0;
        assign_out 		<= 0;
        over 			<= 0;
        dout_r 			<= 0;
        dout_i 			<= 0;
        y_1_delay 		<= 0;
        for (i=0;i<=511;i=i+1) begin
            result_r[i] <= 0;
            result_i[i] <= 0;
        end
    end
    else begin
        din_r_reg 		<= {{4{din_r[11]}},din_r,8'b0};
        din_i_reg 		<= {{4{din_i[11]}},din_i,8'b0};
        in_valid_reg 	<= in_valid;
        s9_count 		<= next_s9_count;
        r8_valid 		<= next_r8_valid;
        count_y  		<= next_count_y;
        assign_out 		<= next_out_valid;
        over 			<= next_over;
        y_1_delay 		<= y_1;
        dout_r 			<= next_dout_r;
        dout_i 			<= next_dout_i;
        for (i=0;i<=511;i=i+1) begin
            result_r[i] <= result_r_ns[i];
            result_i[i] <= result_i_ns[i];
        end
    end
end
////////////////////////////////////////////////////////////////////////////
// Output logic
assign out_valid 	= assign_out;
assign y_1 			= (count_y>9'd0)? (count_y - 9'd1) : count_y; 
assign din_r_wire	= din_r_reg;
assign din_i_wire   = din_i_reg;
////////////////////////////////////////////////////////////////////////////
// Rev. ordering
always @(*) begin
    next_over = over;
    for (i=0;i<=511;i=i+1) begin
        result_r_ns[i] = result_r[i];
        result_i_ns[i] = result_i[i];
    end
    if(next_over==1'b1)next_out_valid = 1'b1;
    else next_out_valid = assign_out;

    if(over!=1'b1) begin
        case((y_1))
			9'd0 : begin
			   result_r_ns[511] = out_r[23:8];
			   result_i_ns[511] = out_i[23:8];
			end
			9'd1 : begin
			   result_r_ns[255] = out_r[23:8];
			   result_i_ns[255] = out_i[23:8];
			end
			9'd2 : begin
			   result_r_ns[127] = out_r[23:8];
			   result_i_ns[127] = out_i[23:8];
			end
			9'd3 : begin
			   result_r_ns[383] = out_r[23:8];
			   result_i_ns[383] = out_i[23:8];
			end
			9'd4 : begin
			   result_r_ns[63] = out_r[23:8];
			   result_i_ns[63] = out_i[23:8];
			end
			9'd5 : begin
			   result_r_ns[319] = out_r[23:8];
			   result_i_ns[319] = out_i[23:8];
			end
			9'd6 : begin
			   result_r_ns[191] = out_r[23:8];
			   result_i_ns[191] = out_i[23:8];
			end
			9'd7 : begin
			   result_r_ns[447] = out_r[23:8];
			   result_i_ns[447] = out_i[23:8];
			end
			9'd8 : begin
			   result_r_ns[31] = out_r[23:8];
			   result_i_ns[31] = out_i[23:8];
			end
			9'd9 : begin
			   result_r_ns[287] = out_r[23:8];
			   result_i_ns[287] = out_i[23:8];
			end
			9'd10 : begin
			   result_r_ns[159] = out_r[23:8];
			   result_i_ns[159] = out_i[23:8];
			end
			9'd11 : begin
			   result_r_ns[415] = out_r[23:8];
			   result_i_ns[415] = out_i[23:8];
			end
			9'd12 : begin
			   result_r_ns[95] = out_r[23:8];
			   result_i_ns[95] = out_i[23:8];
			end
			9'd13 : begin
			   result_r_ns[351] = out_r[23:8];
			   result_i_ns[351] = out_i[23:8];
			end
			9'd14 : begin
			   result_r_ns[223] = out_r[23:8];
			   result_i_ns[223] = out_i[23:8];
			end
			9'd15 : begin
			   result_r_ns[479] = out_r[23:8];
			   result_i_ns[479] = out_i[23:8];
			end
			9'd16 : begin
			   result_r_ns[15] = out_r[23:8];
			   result_i_ns[15] = out_i[23:8];
			end
			9'd17 : begin
			   result_r_ns[271] = out_r[23:8];
			   result_i_ns[271] = out_i[23:8];
			end
			9'd18 : begin
			   result_r_ns[143] = out_r[23:8];
			   result_i_ns[143] = out_i[23:8];
			end
			9'd19 : begin
			   result_r_ns[399] = out_r[23:8];
			   result_i_ns[399] = out_i[23:8];
			end
			9'd20 : begin
			   result_r_ns[79] = out_r[23:8];
			   result_i_ns[79] = out_i[23:8];
			end
			9'd21 : begin
			   result_r_ns[335] = out_r[23:8];
			   result_i_ns[335] = out_i[23:8];
			end
			9'd22 : begin
			   result_r_ns[207] = out_r[23:8];
			   result_i_ns[207] = out_i[23:8];
			end
			9'd23 : begin
			   result_r_ns[463] = out_r[23:8];
			   result_i_ns[463] = out_i[23:8];
			end
			9'd24 : begin
			   result_r_ns[47] = out_r[23:8];
			   result_i_ns[47] = out_i[23:8];
			end
			9'd25 : begin
			   result_r_ns[303] = out_r[23:8];
			   result_i_ns[303] = out_i[23:8];
			end
			9'd26 : begin
			   result_r_ns[175] = out_r[23:8];
			   result_i_ns[175] = out_i[23:8];
			end
			9'd27 : begin
			   result_r_ns[431] = out_r[23:8];
			   result_i_ns[431] = out_i[23:8];
			end
			9'd28 : begin
			   result_r_ns[111] = out_r[23:8];
			   result_i_ns[111] = out_i[23:8];
			end
			9'd29 : begin
			   result_r_ns[367] = out_r[23:8];
			   result_i_ns[367] = out_i[23:8];
			end
			9'd30 : begin
			   result_r_ns[239] = out_r[23:8];
			   result_i_ns[239] = out_i[23:8];
			end
			9'd31 : begin
			   result_r_ns[495] = out_r[23:8];
			   result_i_ns[495] = out_i[23:8];
			end
			9'd32 : begin
			   result_r_ns[7] = out_r[23:8];
			   result_i_ns[7] = out_i[23:8];
			end
			9'd33 : begin
			   result_r_ns[263] = out_r[23:8];
			   result_i_ns[263] = out_i[23:8];
			end
			9'd34 : begin
			   result_r_ns[135] = out_r[23:8];
			   result_i_ns[135] = out_i[23:8];
			end
			9'd35 : begin
			   result_r_ns[391] = out_r[23:8];
			   result_i_ns[391] = out_i[23:8];
			end
			9'd36 : begin
			   result_r_ns[71] = out_r[23:8];
			   result_i_ns[71] = out_i[23:8];
			end
			9'd37 : begin
			   result_r_ns[327] = out_r[23:8];
			   result_i_ns[327] = out_i[23:8];
			end
			9'd38 : begin
			   result_r_ns[199] = out_r[23:8];
			   result_i_ns[199] = out_i[23:8];
			end
			9'd39 : begin
			   result_r_ns[455] = out_r[23:8];
			   result_i_ns[455] = out_i[23:8];
			end
			9'd40 : begin
			   result_r_ns[39] = out_r[23:8];
			   result_i_ns[39] = out_i[23:8];
			end
			9'd41 : begin
			   result_r_ns[295] = out_r[23:8];
			   result_i_ns[295] = out_i[23:8];
			end
			9'd42 : begin
			   result_r_ns[167] = out_r[23:8];
			   result_i_ns[167] = out_i[23:8];
			end
			9'd43 : begin
			   result_r_ns[423] = out_r[23:8];
			   result_i_ns[423] = out_i[23:8];
			end
			9'd44 : begin
			   result_r_ns[103] = out_r[23:8];
			   result_i_ns[103] = out_i[23:8];
			end
			9'd45 : begin
			   result_r_ns[359] = out_r[23:8];
			   result_i_ns[359] = out_i[23:8];
			end
			9'd46 : begin
			   result_r_ns[231] = out_r[23:8];
			   result_i_ns[231] = out_i[23:8];
			end
			9'd47 : begin
			   result_r_ns[487] = out_r[23:8];
			   result_i_ns[487] = out_i[23:8];
			end
			9'd48 : begin
			   result_r_ns[23] = out_r[23:8];
			   result_i_ns[23] = out_i[23:8];
			end
			9'd49 : begin
			   result_r_ns[279] = out_r[23:8];
			   result_i_ns[279] = out_i[23:8];
			end
			9'd50 : begin
			   result_r_ns[151] = out_r[23:8];
			   result_i_ns[151] = out_i[23:8];
			end
			9'd51 : begin
			   result_r_ns[407] = out_r[23:8];
			   result_i_ns[407] = out_i[23:8];
			end
			9'd52 : begin
			   result_r_ns[87] = out_r[23:8];
			   result_i_ns[87] = out_i[23:8];
			end
			9'd53 : begin
			   result_r_ns[343] = out_r[23:8];
			   result_i_ns[343] = out_i[23:8];
			end
			9'd54 : begin
			   result_r_ns[215] = out_r[23:8];
			   result_i_ns[215] = out_i[23:8];
			end
			9'd55 : begin
			   result_r_ns[471] = out_r[23:8];
			   result_i_ns[471] = out_i[23:8];
			end
			9'd56 : begin
			   result_r_ns[55] = out_r[23:8];
			   result_i_ns[55] = out_i[23:8];
			end
			9'd57 : begin
			   result_r_ns[311] = out_r[23:8];
			   result_i_ns[311] = out_i[23:8];
			end
			9'd58 : begin
			   result_r_ns[183] = out_r[23:8];
			   result_i_ns[183] = out_i[23:8];
			end
			9'd59 : begin
			   result_r_ns[439] = out_r[23:8];
			   result_i_ns[439] = out_i[23:8];
			end
			9'd60 : begin
			   result_r_ns[119] = out_r[23:8];
			   result_i_ns[119] = out_i[23:8];
			end
			9'd61 : begin
			   result_r_ns[375] = out_r[23:8];
			   result_i_ns[375] = out_i[23:8];
			end
			9'd62 : begin
			   result_r_ns[247] = out_r[23:8];
			   result_i_ns[247] = out_i[23:8];
			end
			9'd63 : begin
			   result_r_ns[503] = out_r[23:8];
			   result_i_ns[503] = out_i[23:8];
			end
			9'd64 : begin
			   result_r_ns[3] = out_r[23:8];
			   result_i_ns[3] = out_i[23:8];
			end
			9'd65 : begin
			   result_r_ns[259] = out_r[23:8];
			   result_i_ns[259] = out_i[23:8];
			end
			9'd66 : begin
			   result_r_ns[131] = out_r[23:8];
			   result_i_ns[131] = out_i[23:8];
			end
			9'd67 : begin
			   result_r_ns[387] = out_r[23:8];
			   result_i_ns[387] = out_i[23:8];
			end
			9'd68 : begin
			   result_r_ns[67] = out_r[23:8];
			   result_i_ns[67] = out_i[23:8];
			end
			9'd69 : begin
			   result_r_ns[323] = out_r[23:8];
			   result_i_ns[323] = out_i[23:8];
			end
			9'd70 : begin
			   result_r_ns[195] = out_r[23:8];
			   result_i_ns[195] = out_i[23:8];
			end
			9'd71 : begin
			   result_r_ns[451] = out_r[23:8];
			   result_i_ns[451] = out_i[23:8];
			end
			9'd72 : begin
			   result_r_ns[35] = out_r[23:8];
			   result_i_ns[35] = out_i[23:8];
			end
			9'd73 : begin
			   result_r_ns[291] = out_r[23:8];
			   result_i_ns[291] = out_i[23:8];
			end
			9'd74 : begin
			   result_r_ns[163] = out_r[23:8];
			   result_i_ns[163] = out_i[23:8];
			end
			9'd75 : begin
			   result_r_ns[419] = out_r[23:8];
			   result_i_ns[419] = out_i[23:8];
			end
			9'd76 : begin
			   result_r_ns[99] = out_r[23:8];
			   result_i_ns[99] = out_i[23:8];
			end
			9'd77 : begin
			   result_r_ns[355] = out_r[23:8];
			   result_i_ns[355] = out_i[23:8];
			end
			9'd78 : begin
			   result_r_ns[227] = out_r[23:8];
			   result_i_ns[227] = out_i[23:8];
			end
			9'd79 : begin
			   result_r_ns[483] = out_r[23:8];
			   result_i_ns[483] = out_i[23:8];
			end
			9'd80 : begin
			   result_r_ns[19] = out_r[23:8];
			   result_i_ns[19] = out_i[23:8];
			end
			9'd81 : begin
			   result_r_ns[275] = out_r[23:8];
			   result_i_ns[275] = out_i[23:8];
			end
			9'd82 : begin
			   result_r_ns[147] = out_r[23:8];
			   result_i_ns[147] = out_i[23:8];
			end
			9'd83 : begin
			   result_r_ns[403] = out_r[23:8];
			   result_i_ns[403] = out_i[23:8];
			end
			9'd84 : begin
			   result_r_ns[83] = out_r[23:8];
			   result_i_ns[83] = out_i[23:8];
			end
			9'd85 : begin
			   result_r_ns[339] = out_r[23:8];
			   result_i_ns[339] = out_i[23:8];
			end
			9'd86 : begin
			   result_r_ns[211] = out_r[23:8];
			   result_i_ns[211] = out_i[23:8];
			end
			9'd87 : begin
			   result_r_ns[467] = out_r[23:8];
			   result_i_ns[467] = out_i[23:8];
			end
			9'd88 : begin
			   result_r_ns[51] = out_r[23:8];
			   result_i_ns[51] = out_i[23:8];
			end
			9'd89 : begin
			   result_r_ns[307] = out_r[23:8];
			   result_i_ns[307] = out_i[23:8];
			end
			9'd90 : begin
			   result_r_ns[179] = out_r[23:8];
			   result_i_ns[179] = out_i[23:8];
			end
			9'd91 : begin
			   result_r_ns[435] = out_r[23:8];
			   result_i_ns[435] = out_i[23:8];
			end
			9'd92 : begin
			   result_r_ns[115] = out_r[23:8];
			   result_i_ns[115] = out_i[23:8];
			end
			9'd93 : begin
			   result_r_ns[371] = out_r[23:8];
			   result_i_ns[371] = out_i[23:8];
			end
			9'd94 : begin
			   result_r_ns[243] = out_r[23:8];
			   result_i_ns[243] = out_i[23:8];
			end
			9'd95 : begin
			   result_r_ns[499] = out_r[23:8];
			   result_i_ns[499] = out_i[23:8];
			end
			9'd96 : begin
			   result_r_ns[11] = out_r[23:8];
			   result_i_ns[11] = out_i[23:8];
			end
			9'd97 : begin
			   result_r_ns[267] = out_r[23:8];
			   result_i_ns[267] = out_i[23:8];
			end
			9'd98 : begin
			   result_r_ns[139] = out_r[23:8];
			   result_i_ns[139] = out_i[23:8];
			end
			9'd99 : begin
			   result_r_ns[395] = out_r[23:8];
			   result_i_ns[395] = out_i[23:8];
			end
			9'd100 : begin
			   result_r_ns[75] = out_r[23:8];
			   result_i_ns[75] = out_i[23:8];
			end
			9'd101 : begin
			   result_r_ns[331] = out_r[23:8];
			   result_i_ns[331] = out_i[23:8];
			end
			9'd102 : begin
			   result_r_ns[203] = out_r[23:8];
			   result_i_ns[203] = out_i[23:8];
			end
			9'd103 : begin
			   result_r_ns[459] = out_r[23:8];
			   result_i_ns[459] = out_i[23:8];
			end
			9'd104 : begin
			   result_r_ns[43] = out_r[23:8];
			   result_i_ns[43] = out_i[23:8];
			end
			9'd105 : begin
			   result_r_ns[299] = out_r[23:8];
			   result_i_ns[299] = out_i[23:8];
			end
			9'd106 : begin
			   result_r_ns[171] = out_r[23:8];
			   result_i_ns[171] = out_i[23:8];
			end
			9'd107 : begin
			   result_r_ns[427] = out_r[23:8];
			   result_i_ns[427] = out_i[23:8];
			end
			9'd108 : begin
			   result_r_ns[107] = out_r[23:8];
			   result_i_ns[107] = out_i[23:8];
			end
			9'd109 : begin
			   result_r_ns[363] = out_r[23:8];
			   result_i_ns[363] = out_i[23:8];
			end
			9'd110 : begin
			   result_r_ns[235] = out_r[23:8];
			   result_i_ns[235] = out_i[23:8];
			end
			9'd111 : begin
			   result_r_ns[491] = out_r[23:8];
			   result_i_ns[491] = out_i[23:8];
			end
			9'd112 : begin
			   result_r_ns[27] = out_r[23:8];
			   result_i_ns[27] = out_i[23:8];
			end
			9'd113 : begin
			   result_r_ns[283] = out_r[23:8];
			   result_i_ns[283] = out_i[23:8];
			end
			9'd114 : begin
			   result_r_ns[155] = out_r[23:8];
			   result_i_ns[155] = out_i[23:8];
			end
			9'd115 : begin
			   result_r_ns[411] = out_r[23:8];
			   result_i_ns[411] = out_i[23:8];
			end
			9'd116 : begin
			   result_r_ns[91] = out_r[23:8];
			   result_i_ns[91] = out_i[23:8];
			end
			9'd117 : begin
			   result_r_ns[347] = out_r[23:8];
			   result_i_ns[347] = out_i[23:8];
			end
			9'd118 : begin
			   result_r_ns[219] = out_r[23:8];
			   result_i_ns[219] = out_i[23:8];
			end
			9'd119 : begin
			   result_r_ns[475] = out_r[23:8];
			   result_i_ns[475] = out_i[23:8];
			end
			9'd120 : begin
			   result_r_ns[59] = out_r[23:8];
			   result_i_ns[59] = out_i[23:8];
			end
			9'd121 : begin
			   result_r_ns[315] = out_r[23:8];
			   result_i_ns[315] = out_i[23:8];
			end
			9'd122 : begin
			   result_r_ns[187] = out_r[23:8];
			   result_i_ns[187] = out_i[23:8];
			end
			9'd123 : begin
			   result_r_ns[443] = out_r[23:8];
			   result_i_ns[443] = out_i[23:8];
			end
			9'd124 : begin
			   result_r_ns[123] = out_r[23:8];
			   result_i_ns[123] = out_i[23:8];
			end
			9'd125 : begin
			   result_r_ns[379] = out_r[23:8];
			   result_i_ns[379] = out_i[23:8];
			end
			9'd126 : begin
			   result_r_ns[251] = out_r[23:8];
			   result_i_ns[251] = out_i[23:8];
			end
			9'd127 : begin
			   result_r_ns[507] = out_r[23:8];
			   result_i_ns[507] = out_i[23:8];
			end
			9'd128 : begin
			   result_r_ns[1] = out_r[23:8];
			   result_i_ns[1] = out_i[23:8];
			end
			9'd129 : begin
			   result_r_ns[257] = out_r[23:8];
			   result_i_ns[257] = out_i[23:8];
			end
			9'd130 : begin
			   result_r_ns[129] = out_r[23:8];
			   result_i_ns[129] = out_i[23:8];
			end
			9'd131 : begin
			   result_r_ns[385] = out_r[23:8];
			   result_i_ns[385] = out_i[23:8];
			end
			9'd132 : begin
			   result_r_ns[65] = out_r[23:8];
			   result_i_ns[65] = out_i[23:8];
			end
			9'd133 : begin
			   result_r_ns[321] = out_r[23:8];
			   result_i_ns[321] = out_i[23:8];
			end
			9'd134 : begin
			   result_r_ns[193] = out_r[23:8];
			   result_i_ns[193] = out_i[23:8];
			end
			9'd135 : begin
			   result_r_ns[449] = out_r[23:8];
			   result_i_ns[449] = out_i[23:8];
			end
			9'd136 : begin
			   result_r_ns[33] = out_r[23:8];
			   result_i_ns[33] = out_i[23:8];
			end
			9'd137 : begin
			   result_r_ns[289] = out_r[23:8];
			   result_i_ns[289] = out_i[23:8];
			end
			9'd138 : begin
			   result_r_ns[161] = out_r[23:8];
			   result_i_ns[161] = out_i[23:8];
			end
			9'd139 : begin
			   result_r_ns[417] = out_r[23:8];
			   result_i_ns[417] = out_i[23:8];
			end
			9'd140 : begin
			   result_r_ns[97] = out_r[23:8];
			   result_i_ns[97] = out_i[23:8];
			end
			9'd141 : begin
			   result_r_ns[353] = out_r[23:8];
			   result_i_ns[353] = out_i[23:8];
			end
			9'd142 : begin
			   result_r_ns[225] = out_r[23:8];
			   result_i_ns[225] = out_i[23:8];
			end
			9'd143 : begin
			   result_r_ns[481] = out_r[23:8];
			   result_i_ns[481] = out_i[23:8];
			end
			9'd144 : begin
			   result_r_ns[17] = out_r[23:8];
			   result_i_ns[17] = out_i[23:8];
			end
			9'd145 : begin
			   result_r_ns[273] = out_r[23:8];
			   result_i_ns[273] = out_i[23:8];
			end
			9'd146 : begin
			   result_r_ns[145] = out_r[23:8];
			   result_i_ns[145] = out_i[23:8];
			end
			9'd147 : begin
			   result_r_ns[401] = out_r[23:8];
			   result_i_ns[401] = out_i[23:8];
			end
			9'd148 : begin
			   result_r_ns[81] = out_r[23:8];
			   result_i_ns[81] = out_i[23:8];
			end
			9'd149 : begin
			   result_r_ns[337] = out_r[23:8];
			   result_i_ns[337] = out_i[23:8];
			end
			9'd150 : begin
			   result_r_ns[209] = out_r[23:8];
			   result_i_ns[209] = out_i[23:8];
			end
			9'd151 : begin
			   result_r_ns[465] = out_r[23:8];
			   result_i_ns[465] = out_i[23:8];
			end
			9'd152 : begin
			   result_r_ns[49] = out_r[23:8];
			   result_i_ns[49] = out_i[23:8];
			end
			9'd153 : begin
			   result_r_ns[305] = out_r[23:8];
			   result_i_ns[305] = out_i[23:8];
			end
			9'd154 : begin
			   result_r_ns[177] = out_r[23:8];
			   result_i_ns[177] = out_i[23:8];
			end
			9'd155 : begin
			   result_r_ns[433] = out_r[23:8];
			   result_i_ns[433] = out_i[23:8];
			end
			9'd156 : begin
			   result_r_ns[113] = out_r[23:8];
			   result_i_ns[113] = out_i[23:8];
			end
			9'd157 : begin
			   result_r_ns[369] = out_r[23:8];
			   result_i_ns[369] = out_i[23:8];
			end
			9'd158 : begin
			   result_r_ns[241] = out_r[23:8];
			   result_i_ns[241] = out_i[23:8];
			end
			9'd159 : begin
			   result_r_ns[497] = out_r[23:8];
			   result_i_ns[497] = out_i[23:8];
			end
			9'd160 : begin
			   result_r_ns[9] = out_r[23:8];
			   result_i_ns[9] = out_i[23:8];
			end
			9'd161 : begin
			   result_r_ns[265] = out_r[23:8];
			   result_i_ns[265] = out_i[23:8];
			end
			9'd162 : begin
			   result_r_ns[137] = out_r[23:8];
			   result_i_ns[137] = out_i[23:8];
			end
			9'd163 : begin
			   result_r_ns[393] = out_r[23:8];
			   result_i_ns[393] = out_i[23:8];
			end
			9'd164 : begin
			   result_r_ns[73] = out_r[23:8];
			   result_i_ns[73] = out_i[23:8];
			end
			9'd165 : begin
			   result_r_ns[329] = out_r[23:8];
			   result_i_ns[329] = out_i[23:8];
			end
			9'd166 : begin
			   result_r_ns[201] = out_r[23:8];
			   result_i_ns[201] = out_i[23:8];
			end
			9'd167 : begin
			   result_r_ns[457] = out_r[23:8];
			   result_i_ns[457] = out_i[23:8];
			end
			9'd168 : begin
			   result_r_ns[41] = out_r[23:8];
			   result_i_ns[41] = out_i[23:8];
			end
			9'd169 : begin
			   result_r_ns[297] = out_r[23:8];
			   result_i_ns[297] = out_i[23:8];
			end
			9'd170 : begin
			   result_r_ns[169] = out_r[23:8];
			   result_i_ns[169] = out_i[23:8];
			end
			9'd171 : begin
			   result_r_ns[425] = out_r[23:8];
			   result_i_ns[425] = out_i[23:8];
			end
			9'd172 : begin
			   result_r_ns[105] = out_r[23:8];
			   result_i_ns[105] = out_i[23:8];
			end
			9'd173 : begin
			   result_r_ns[361] = out_r[23:8];
			   result_i_ns[361] = out_i[23:8];
			end
			9'd174 : begin
			   result_r_ns[233] = out_r[23:8];
			   result_i_ns[233] = out_i[23:8];
			end
			9'd175 : begin
			   result_r_ns[489] = out_r[23:8];
			   result_i_ns[489] = out_i[23:8];
			end
			9'd176 : begin
			   result_r_ns[25] = out_r[23:8];
			   result_i_ns[25] = out_i[23:8];
			end
			9'd177 : begin
			   result_r_ns[281] = out_r[23:8];
			   result_i_ns[281] = out_i[23:8];
			end
			9'd178 : begin
			   result_r_ns[153] = out_r[23:8];
			   result_i_ns[153] = out_i[23:8];
			end
			9'd179 : begin
			   result_r_ns[409] = out_r[23:8];
			   result_i_ns[409] = out_i[23:8];
			end
			9'd180 : begin
			   result_r_ns[89] = out_r[23:8];
			   result_i_ns[89] = out_i[23:8];
			end
			9'd181 : begin
			   result_r_ns[345] = out_r[23:8];
			   result_i_ns[345] = out_i[23:8];
			end
			9'd182 : begin
			   result_r_ns[217] = out_r[23:8];
			   result_i_ns[217] = out_i[23:8];
			end
			9'd183 : begin
			   result_r_ns[473] = out_r[23:8];
			   result_i_ns[473] = out_i[23:8];
			end
			9'd184 : begin
			   result_r_ns[57] = out_r[23:8];
			   result_i_ns[57] = out_i[23:8];
			end
			9'd185 : begin
			   result_r_ns[313] = out_r[23:8];
			   result_i_ns[313] = out_i[23:8];
			end
			9'd186 : begin
			   result_r_ns[185] = out_r[23:8];
			   result_i_ns[185] = out_i[23:8];
			end
			9'd187 : begin
			   result_r_ns[441] = out_r[23:8];
			   result_i_ns[441] = out_i[23:8];
			end
			9'd188 : begin
			   result_r_ns[121] = out_r[23:8];
			   result_i_ns[121] = out_i[23:8];
			end
			9'd189 : begin
			   result_r_ns[377] = out_r[23:8];
			   result_i_ns[377] = out_i[23:8];
			end
			9'd190 : begin
			   result_r_ns[249] = out_r[23:8];
			   result_i_ns[249] = out_i[23:8];
			end
			9'd191 : begin
			   result_r_ns[505] = out_r[23:8];
			   result_i_ns[505] = out_i[23:8];
			end
			9'd192 : begin
			   result_r_ns[5] = out_r[23:8];
			   result_i_ns[5] = out_i[23:8];
			end
			9'd193 : begin
			   result_r_ns[261] = out_r[23:8];
			   result_i_ns[261] = out_i[23:8];
			end
			9'd194 : begin
			   result_r_ns[133] = out_r[23:8];
			   result_i_ns[133] = out_i[23:8];
			end
			9'd195 : begin
			   result_r_ns[389] = out_r[23:8];
			   result_i_ns[389] = out_i[23:8];
			end
			9'd196 : begin
			   result_r_ns[69] = out_r[23:8];
			   result_i_ns[69] = out_i[23:8];
			end
			9'd197 : begin
			   result_r_ns[325] = out_r[23:8];
			   result_i_ns[325] = out_i[23:8];
			end
			9'd198 : begin
			   result_r_ns[197] = out_r[23:8];
			   result_i_ns[197] = out_i[23:8];
			end
			9'd199 : begin
			   result_r_ns[453] = out_r[23:8];
			   result_i_ns[453] = out_i[23:8];
			end
			9'd200 : begin
			   result_r_ns[37] = out_r[23:8];
			   result_i_ns[37] = out_i[23:8];
			end
			9'd201 : begin
			   result_r_ns[293] = out_r[23:8];
			   result_i_ns[293] = out_i[23:8];
			end
			9'd202 : begin
			   result_r_ns[165] = out_r[23:8];
			   result_i_ns[165] = out_i[23:8];
			end
			9'd203 : begin
			   result_r_ns[421] = out_r[23:8];
			   result_i_ns[421] = out_i[23:8];
			end
			9'd204 : begin
			   result_r_ns[101] = out_r[23:8];
			   result_i_ns[101] = out_i[23:8];
			end
			9'd205 : begin
			   result_r_ns[357] = out_r[23:8];
			   result_i_ns[357] = out_i[23:8];
			end
			9'd206 : begin
			   result_r_ns[229] = out_r[23:8];
			   result_i_ns[229] = out_i[23:8];
			end
			9'd207 : begin
			   result_r_ns[485] = out_r[23:8];
			   result_i_ns[485] = out_i[23:8];
			end
			9'd208 : begin
			   result_r_ns[21] = out_r[23:8];
			   result_i_ns[21] = out_i[23:8];
			end
			9'd209 : begin
			   result_r_ns[277] = out_r[23:8];
			   result_i_ns[277] = out_i[23:8];
			end
			9'd210 : begin
			   result_r_ns[149] = out_r[23:8];
			   result_i_ns[149] = out_i[23:8];
			end
			9'd211 : begin
			   result_r_ns[405] = out_r[23:8];
			   result_i_ns[405] = out_i[23:8];
			end
			9'd212 : begin
			   result_r_ns[85] = out_r[23:8];
			   result_i_ns[85] = out_i[23:8];
			end
			9'd213 : begin
			   result_r_ns[341] = out_r[23:8];
			   result_i_ns[341] = out_i[23:8];
			end
			9'd214 : begin
			   result_r_ns[213] = out_r[23:8];
			   result_i_ns[213] = out_i[23:8];
			end
			9'd215 : begin
			   result_r_ns[469] = out_r[23:8];
			   result_i_ns[469] = out_i[23:8];
			end
			9'd216 : begin
			   result_r_ns[53] = out_r[23:8];
			   result_i_ns[53] = out_i[23:8];
			end
			9'd217 : begin
			   result_r_ns[309] = out_r[23:8];
			   result_i_ns[309] = out_i[23:8];
			end
			9'd218 : begin
			   result_r_ns[181] = out_r[23:8];
			   result_i_ns[181] = out_i[23:8];
			end
			9'd219 : begin
			   result_r_ns[437] = out_r[23:8];
			   result_i_ns[437] = out_i[23:8];
			end
			9'd220 : begin
			   result_r_ns[117] = out_r[23:8];
			   result_i_ns[117] = out_i[23:8];
			end
			9'd221 : begin
			   result_r_ns[373] = out_r[23:8];
			   result_i_ns[373] = out_i[23:8];
			end
			9'd222 : begin
			   result_r_ns[245] = out_r[23:8];
			   result_i_ns[245] = out_i[23:8];
			end
			9'd223 : begin
			   result_r_ns[501] = out_r[23:8];
			   result_i_ns[501] = out_i[23:8];
			end
			9'd224 : begin
			   result_r_ns[13] = out_r[23:8];
			   result_i_ns[13] = out_i[23:8];
			end
			9'd225 : begin
			   result_r_ns[269] = out_r[23:8];
			   result_i_ns[269] = out_i[23:8];
			end
			9'd226 : begin
			   result_r_ns[141] = out_r[23:8];
			   result_i_ns[141] = out_i[23:8];
			end
			9'd227 : begin
			   result_r_ns[397] = out_r[23:8];
			   result_i_ns[397] = out_i[23:8];
			end
			9'd228 : begin
			   result_r_ns[77] = out_r[23:8];
			   result_i_ns[77] = out_i[23:8];
			end
			9'd229 : begin
			   result_r_ns[333] = out_r[23:8];
			   result_i_ns[333] = out_i[23:8];
			end
			9'd230 : begin
			   result_r_ns[205] = out_r[23:8];
			   result_i_ns[205] = out_i[23:8];
			end
			9'd231 : begin
			   result_r_ns[461] = out_r[23:8];
			   result_i_ns[461] = out_i[23:8];
			end
			9'd232 : begin
			   result_r_ns[45] = out_r[23:8];
			   result_i_ns[45] = out_i[23:8];
			end
			9'd233 : begin
			   result_r_ns[301] = out_r[23:8];
			   result_i_ns[301] = out_i[23:8];
			end
			9'd234 : begin
			   result_r_ns[173] = out_r[23:8];
			   result_i_ns[173] = out_i[23:8];
			end
			9'd235 : begin
			   result_r_ns[429] = out_r[23:8];
			   result_i_ns[429] = out_i[23:8];
			end
			9'd236 : begin
			   result_r_ns[109] = out_r[23:8];
			   result_i_ns[109] = out_i[23:8];
			end
			9'd237 : begin
			   result_r_ns[365] = out_r[23:8];
			   result_i_ns[365] = out_i[23:8];
			end
			9'd238 : begin
			   result_r_ns[237] = out_r[23:8];
			   result_i_ns[237] = out_i[23:8];
			end
			9'd239 : begin
			   result_r_ns[493] = out_r[23:8];
			   result_i_ns[493] = out_i[23:8];
			end
			9'd240 : begin
			   result_r_ns[29] = out_r[23:8];
			   result_i_ns[29] = out_i[23:8];
			end
			9'd241 : begin
			   result_r_ns[285] = out_r[23:8];
			   result_i_ns[285] = out_i[23:8];
			end
			9'd242 : begin
			   result_r_ns[157] = out_r[23:8];
			   result_i_ns[157] = out_i[23:8];
			end
			9'd243 : begin
			   result_r_ns[413] = out_r[23:8];
			   result_i_ns[413] = out_i[23:8];
			end
			9'd244 : begin
			   result_r_ns[93] = out_r[23:8];
			   result_i_ns[93] = out_i[23:8];
			end
			9'd245 : begin
			   result_r_ns[349] = out_r[23:8];
			   result_i_ns[349] = out_i[23:8];
			end
			9'd246 : begin
			   result_r_ns[221] = out_r[23:8];
			   result_i_ns[221] = out_i[23:8];
			end
			9'd247 : begin
			   result_r_ns[477] = out_r[23:8];
			   result_i_ns[477] = out_i[23:8];
			end
			9'd248 : begin
			   result_r_ns[61] = out_r[23:8];
			   result_i_ns[61] = out_i[23:8];
			end
			9'd249 : begin
			   result_r_ns[317] = out_r[23:8];
			   result_i_ns[317] = out_i[23:8];
			end
			9'd250 : begin
			   result_r_ns[189] = out_r[23:8];
			   result_i_ns[189] = out_i[23:8];
			end
			9'd251 : begin
			   result_r_ns[445] = out_r[23:8];
			   result_i_ns[445] = out_i[23:8];
			end
			9'd252 : begin
			   result_r_ns[125] = out_r[23:8];
			   result_i_ns[125] = out_i[23:8];
			end
			9'd253 : begin
			   result_r_ns[381] = out_r[23:8];
			   result_i_ns[381] = out_i[23:8];
			end
			9'd254 : begin
			   result_r_ns[253] = out_r[23:8];
			   result_i_ns[253] = out_i[23:8];
			end
			9'd255 : begin
			   result_r_ns[509] = out_r[23:8];
			   result_i_ns[509] = out_i[23:8];
			end
			9'd256 : begin
			   result_r_ns[0] = out_r[23:8];
			   result_i_ns[0] = out_i[23:8];
			end
			9'd257 : begin
			   result_r_ns[256] = out_r[23:8];
			   result_i_ns[256] = out_i[23:8];
			end
			9'd258 : begin
			   result_r_ns[128] = out_r[23:8];
			   result_i_ns[128] = out_i[23:8];
			end
			9'd259 : begin
			   result_r_ns[384] = out_r[23:8];
			   result_i_ns[384] = out_i[23:8];
			end
			9'd260 : begin
			   result_r_ns[64] = out_r[23:8];
			   result_i_ns[64] = out_i[23:8];
			end
			9'd261 : begin
			   result_r_ns[320] = out_r[23:8];
			   result_i_ns[320] = out_i[23:8];
			end
			9'd262 : begin
			   result_r_ns[192] = out_r[23:8];
			   result_i_ns[192] = out_i[23:8];
			end
			9'd263 : begin
			   result_r_ns[448] = out_r[23:8];
			   result_i_ns[448] = out_i[23:8];
			end
			9'd264 : begin
			   result_r_ns[32] = out_r[23:8];
			   result_i_ns[32] = out_i[23:8];
			end
			9'd265 : begin
			   result_r_ns[288] = out_r[23:8];
			   result_i_ns[288] = out_i[23:8];
			end
			9'd266 : begin
			   result_r_ns[160] = out_r[23:8];
			   result_i_ns[160] = out_i[23:8];
			end
			9'd267 : begin
			   result_r_ns[416] = out_r[23:8];
			   result_i_ns[416] = out_i[23:8];
			end
			9'd268 : begin
			   result_r_ns[96] = out_r[23:8];
			   result_i_ns[96] = out_i[23:8];
			end
			9'd269 : begin
			   result_r_ns[352] = out_r[23:8];
			   result_i_ns[352] = out_i[23:8];
			end
			9'd270 : begin
			   result_r_ns[224] = out_r[23:8];
			   result_i_ns[224] = out_i[23:8];
			end
			9'd271 : begin
			   result_r_ns[480] = out_r[23:8];
			   result_i_ns[480] = out_i[23:8];
			end
			9'd272 : begin
			   result_r_ns[16] = out_r[23:8];
			   result_i_ns[16] = out_i[23:8];
			end
			9'd273 : begin
			   result_r_ns[272] = out_r[23:8];
			   result_i_ns[272] = out_i[23:8];
			end
			9'd274 : begin
			   result_r_ns[144] = out_r[23:8];
			   result_i_ns[144] = out_i[23:8];
			end
			9'd275 : begin
			   result_r_ns[400] = out_r[23:8];
			   result_i_ns[400] = out_i[23:8];
			end
			9'd276 : begin
			   result_r_ns[80] = out_r[23:8];
			   result_i_ns[80] = out_i[23:8];
			end
			9'd277 : begin
			   result_r_ns[336] = out_r[23:8];
			   result_i_ns[336] = out_i[23:8];
			end
			9'd278 : begin
			   result_r_ns[208] = out_r[23:8];
			   result_i_ns[208] = out_i[23:8];
			end
			9'd279 : begin
			   result_r_ns[464] = out_r[23:8];
			   result_i_ns[464] = out_i[23:8];
			end
			9'd280 : begin
			   result_r_ns[48] = out_r[23:8];
			   result_i_ns[48] = out_i[23:8];
			end
			9'd281 : begin
			   result_r_ns[304] = out_r[23:8];
			   result_i_ns[304] = out_i[23:8];
			end
			9'd282 : begin
			   result_r_ns[176] = out_r[23:8];
			   result_i_ns[176] = out_i[23:8];
			end
			9'd283 : begin
			   result_r_ns[432] = out_r[23:8];
			   result_i_ns[432] = out_i[23:8];
			end
			9'd284 : begin
			   result_r_ns[112] = out_r[23:8];
			   result_i_ns[112] = out_i[23:8];
			end
			9'd285 : begin
			   result_r_ns[368] = out_r[23:8];
			   result_i_ns[368] = out_i[23:8];
			end
			9'd286 : begin
			   result_r_ns[240] = out_r[23:8];
			   result_i_ns[240] = out_i[23:8];
			end
			9'd287 : begin
			   result_r_ns[496] = out_r[23:8];
			   result_i_ns[496] = out_i[23:8];
			end
			9'd288 : begin
			   result_r_ns[8] = out_r[23:8];
			   result_i_ns[8] = out_i[23:8];
			end
			9'd289 : begin
			   result_r_ns[264] = out_r[23:8];
			   result_i_ns[264] = out_i[23:8];
			end
			9'd290 : begin
			   result_r_ns[136] = out_r[23:8];
			   result_i_ns[136] = out_i[23:8];
			end
			9'd291 : begin
			   result_r_ns[392] = out_r[23:8];
			   result_i_ns[392] = out_i[23:8];
			end
			9'd292 : begin
			   result_r_ns[72] = out_r[23:8];
			   result_i_ns[72] = out_i[23:8];
			end
			9'd293 : begin
			   result_r_ns[328] = out_r[23:8];
			   result_i_ns[328] = out_i[23:8];
			end
			9'd294 : begin
			   result_r_ns[200] = out_r[23:8];
			   result_i_ns[200] = out_i[23:8];
			end
			9'd295 : begin
			   result_r_ns[456] = out_r[23:8];
			   result_i_ns[456] = out_i[23:8];
			end
			9'd296 : begin
			   result_r_ns[40] = out_r[23:8];
			   result_i_ns[40] = out_i[23:8];
			end
			9'd297 : begin
			   result_r_ns[296] = out_r[23:8];
			   result_i_ns[296] = out_i[23:8];
			end
			9'd298 : begin
			   result_r_ns[168] = out_r[23:8];
			   result_i_ns[168] = out_i[23:8];
			end
			9'd299 : begin
			   result_r_ns[424] = out_r[23:8];
			   result_i_ns[424] = out_i[23:8];
			end
			9'd300 : begin
			   result_r_ns[104] = out_r[23:8];
			   result_i_ns[104] = out_i[23:8];
			end
			9'd301 : begin
			   result_r_ns[360] = out_r[23:8];
			   result_i_ns[360] = out_i[23:8];
			end
			9'd302 : begin
			   result_r_ns[232] = out_r[23:8];
			   result_i_ns[232] = out_i[23:8];
			end
			9'd303 : begin
			   result_r_ns[488] = out_r[23:8];
			   result_i_ns[488] = out_i[23:8];
			end
			9'd304 : begin
			   result_r_ns[24] = out_r[23:8];
			   result_i_ns[24] = out_i[23:8];
			end
			9'd305 : begin
			   result_r_ns[280] = out_r[23:8];
			   result_i_ns[280] = out_i[23:8];
			end
			9'd306 : begin
			   result_r_ns[152] = out_r[23:8];
			   result_i_ns[152] = out_i[23:8];
			end
			9'd307 : begin
			   result_r_ns[408] = out_r[23:8];
			   result_i_ns[408] = out_i[23:8];
			end
			9'd308 : begin
			   result_r_ns[88] = out_r[23:8];
			   result_i_ns[88] = out_i[23:8];
			end
			9'd309 : begin
			   result_r_ns[344] = out_r[23:8];
			   result_i_ns[344] = out_i[23:8];
			end
			9'd310 : begin
			   result_r_ns[216] = out_r[23:8];
			   result_i_ns[216] = out_i[23:8];
			end
			9'd311 : begin
			   result_r_ns[472] = out_r[23:8];
			   result_i_ns[472] = out_i[23:8];
			end
			9'd312 : begin
			   result_r_ns[56] = out_r[23:8];
			   result_i_ns[56] = out_i[23:8];
			end
			9'd313 : begin
			   result_r_ns[312] = out_r[23:8];
			   result_i_ns[312] = out_i[23:8];
			end
			9'd314 : begin
			   result_r_ns[184] = out_r[23:8];
			   result_i_ns[184] = out_i[23:8];
			end
			9'd315 : begin
			   result_r_ns[440] = out_r[23:8];
			   result_i_ns[440] = out_i[23:8];
			end
			9'd316 : begin
			   result_r_ns[120] = out_r[23:8];
			   result_i_ns[120] = out_i[23:8];
			end
			9'd317 : begin
			   result_r_ns[376] = out_r[23:8];
			   result_i_ns[376] = out_i[23:8];
			end
			9'd318 : begin
			   result_r_ns[248] = out_r[23:8];
			   result_i_ns[248] = out_i[23:8];
			end
			9'd319 : begin
			   result_r_ns[504] = out_r[23:8];
			   result_i_ns[504] = out_i[23:8];
			end
			9'd320 : begin
			   result_r_ns[4] = out_r[23:8];
			   result_i_ns[4] = out_i[23:8];
			end
			9'd321 : begin
			   result_r_ns[260] = out_r[23:8];
			   result_i_ns[260] = out_i[23:8];
			end
			9'd322 : begin
			   result_r_ns[132] = out_r[23:8];
			   result_i_ns[132] = out_i[23:8];
			end
			9'd323 : begin
			   result_r_ns[388] = out_r[23:8];
			   result_i_ns[388] = out_i[23:8];
			end
			9'd324 : begin
			   result_r_ns[68] = out_r[23:8];
			   result_i_ns[68] = out_i[23:8];
			end
			9'd325 : begin
			   result_r_ns[324] = out_r[23:8];
			   result_i_ns[324] = out_i[23:8];
			end
			9'd326 : begin
			   result_r_ns[196] = out_r[23:8];
			   result_i_ns[196] = out_i[23:8];
			end
			9'd327 : begin
			   result_r_ns[452] = out_r[23:8];
			   result_i_ns[452] = out_i[23:8];
			end
			9'd328 : begin
			   result_r_ns[36] = out_r[23:8];
			   result_i_ns[36] = out_i[23:8];
			end
			9'd329 : begin
			   result_r_ns[292] = out_r[23:8];
			   result_i_ns[292] = out_i[23:8];
			end
			9'd330 : begin
			   result_r_ns[164] = out_r[23:8];
			   result_i_ns[164] = out_i[23:8];
			end
			9'd331 : begin
			   result_r_ns[420] = out_r[23:8];
			   result_i_ns[420] = out_i[23:8];
			end
			9'd332 : begin
			   result_r_ns[100] = out_r[23:8];
			   result_i_ns[100] = out_i[23:8];
			end
			9'd333 : begin
			   result_r_ns[356] = out_r[23:8];
			   result_i_ns[356] = out_i[23:8];
			end
			9'd334 : begin
			   result_r_ns[228] = out_r[23:8];
			   result_i_ns[228] = out_i[23:8];
			end
			9'd335 : begin
			   result_r_ns[484] = out_r[23:8];
			   result_i_ns[484] = out_i[23:8];
			end
			9'd336 : begin
			   result_r_ns[20] = out_r[23:8];
			   result_i_ns[20] = out_i[23:8];
			end
			9'd337 : begin
			   result_r_ns[276] = out_r[23:8];
			   result_i_ns[276] = out_i[23:8];
			end
			9'd338 : begin
			   result_r_ns[148] = out_r[23:8];
			   result_i_ns[148] = out_i[23:8];
			end
			9'd339 : begin
			   result_r_ns[404] = out_r[23:8];
			   result_i_ns[404] = out_i[23:8];
			end
			9'd340 : begin
			   result_r_ns[84] = out_r[23:8];
			   result_i_ns[84] = out_i[23:8];
			end
			9'd341 : begin
			   result_r_ns[340] = out_r[23:8];
			   result_i_ns[340] = out_i[23:8];
			end
			9'd342 : begin
			   result_r_ns[212] = out_r[23:8];
			   result_i_ns[212] = out_i[23:8];
			end
			9'd343 : begin
			   result_r_ns[468] = out_r[23:8];
			   result_i_ns[468] = out_i[23:8];
			end
			9'd344 : begin
			   result_r_ns[52] = out_r[23:8];
			   result_i_ns[52] = out_i[23:8];
			end
			9'd345 : begin
			   result_r_ns[308] = out_r[23:8];
			   result_i_ns[308] = out_i[23:8];
			end
			9'd346 : begin
			   result_r_ns[180] = out_r[23:8];
			   result_i_ns[180] = out_i[23:8];
			end
			9'd347 : begin
			   result_r_ns[436] = out_r[23:8];
			   result_i_ns[436] = out_i[23:8];
			end
			9'd348 : begin
			   result_r_ns[116] = out_r[23:8];
			   result_i_ns[116] = out_i[23:8];
			end
			9'd349 : begin
			   result_r_ns[372] = out_r[23:8];
			   result_i_ns[372] = out_i[23:8];
			end
			9'd350 : begin
			   result_r_ns[244] = out_r[23:8];
			   result_i_ns[244] = out_i[23:8];
			end
			9'd351 : begin
			   result_r_ns[500] = out_r[23:8];
			   result_i_ns[500] = out_i[23:8];
			end
			9'd352 : begin
			   result_r_ns[12] = out_r[23:8];
			   result_i_ns[12] = out_i[23:8];
			end
			9'd353 : begin
			   result_r_ns[268] = out_r[23:8];
			   result_i_ns[268] = out_i[23:8];
			end
			9'd354 : begin
			   result_r_ns[140] = out_r[23:8];
			   result_i_ns[140] = out_i[23:8];
			end
			9'd355 : begin
			   result_r_ns[396] = out_r[23:8];
			   result_i_ns[396] = out_i[23:8];
			end
			9'd356 : begin
			   result_r_ns[76] = out_r[23:8];
			   result_i_ns[76] = out_i[23:8];
			end
			9'd357 : begin
			   result_r_ns[332] = out_r[23:8];
			   result_i_ns[332] = out_i[23:8];
			end
			9'd358 : begin
			   result_r_ns[204] = out_r[23:8];
			   result_i_ns[204] = out_i[23:8];
			end
			9'd359 : begin
			   result_r_ns[460] = out_r[23:8];
			   result_i_ns[460] = out_i[23:8];
			end
			9'd360 : begin
			   result_r_ns[44] = out_r[23:8];
			   result_i_ns[44] = out_i[23:8];
			end
			9'd361 : begin
			   result_r_ns[300] = out_r[23:8];
			   result_i_ns[300] = out_i[23:8];
			end
			9'd362 : begin
			   result_r_ns[172] = out_r[23:8];
			   result_i_ns[172] = out_i[23:8];
			end
			9'd363 : begin
			   result_r_ns[428] = out_r[23:8];
			   result_i_ns[428] = out_i[23:8];
			end
			9'd364 : begin
			   result_r_ns[108] = out_r[23:8];
			   result_i_ns[108] = out_i[23:8];
			end
			9'd365 : begin
			   result_r_ns[364] = out_r[23:8];
			   result_i_ns[364] = out_i[23:8];
			end
			9'd366 : begin
			   result_r_ns[236] = out_r[23:8];
			   result_i_ns[236] = out_i[23:8];
			end
			9'd367 : begin
			   result_r_ns[492] = out_r[23:8];
			   result_i_ns[492] = out_i[23:8];
			end
			9'd368 : begin
			   result_r_ns[28] = out_r[23:8];
			   result_i_ns[28] = out_i[23:8];
			end
			9'd369 : begin
			   result_r_ns[284] = out_r[23:8];
			   result_i_ns[284] = out_i[23:8];
			end
			9'd370 : begin
			   result_r_ns[156] = out_r[23:8];
			   result_i_ns[156] = out_i[23:8];
			end
			9'd371 : begin
			   result_r_ns[412] = out_r[23:8];
			   result_i_ns[412] = out_i[23:8];
			end
			9'd372 : begin
			   result_r_ns[92] = out_r[23:8];
			   result_i_ns[92] = out_i[23:8];
			end
			9'd373 : begin
			   result_r_ns[348] = out_r[23:8];
			   result_i_ns[348] = out_i[23:8];
			end
			9'd374 : begin
			   result_r_ns[220] = out_r[23:8];
			   result_i_ns[220] = out_i[23:8];
			end
			9'd375 : begin
			   result_r_ns[476] = out_r[23:8];
			   result_i_ns[476] = out_i[23:8];
			end
			9'd376 : begin
			   result_r_ns[60] = out_r[23:8];
			   result_i_ns[60] = out_i[23:8];
			end
			9'd377 : begin
			   result_r_ns[316] = out_r[23:8];
			   result_i_ns[316] = out_i[23:8];
			end
			9'd378 : begin
			   result_r_ns[188] = out_r[23:8];
			   result_i_ns[188] = out_i[23:8];
			end
			9'd379 : begin
			   result_r_ns[444] = out_r[23:8];
			   result_i_ns[444] = out_i[23:8];
			end
			9'd380 : begin
			   result_r_ns[124] = out_r[23:8];
			   result_i_ns[124] = out_i[23:8];
			end
			9'd381 : begin
			   result_r_ns[380] = out_r[23:8];
			   result_i_ns[380] = out_i[23:8];
			end
			9'd382 : begin
			   result_r_ns[252] = out_r[23:8];
			   result_i_ns[252] = out_i[23:8];
			end
			9'd383 : begin
			   result_r_ns[508] = out_r[23:8];
			   result_i_ns[508] = out_i[23:8];
			end
			9'd384 : begin
			   result_r_ns[2] = out_r[23:8];
			   result_i_ns[2] = out_i[23:8];
			end
			9'd385 : begin
			   result_r_ns[258] = out_r[23:8];
			   result_i_ns[258] = out_i[23:8];
			end
			9'd386 : begin
			   result_r_ns[130] = out_r[23:8];
			   result_i_ns[130] = out_i[23:8];
			end
			9'd387 : begin
			   result_r_ns[386] = out_r[23:8];
			   result_i_ns[386] = out_i[23:8];
			end
			9'd388 : begin
			   result_r_ns[66] = out_r[23:8];
			   result_i_ns[66] = out_i[23:8];
			end
			9'd389 : begin
			   result_r_ns[322] = out_r[23:8];
			   result_i_ns[322] = out_i[23:8];
			end
			9'd390 : begin
			   result_r_ns[194] = out_r[23:8];
			   result_i_ns[194] = out_i[23:8];
			end
			9'd391 : begin
			   result_r_ns[450] = out_r[23:8];
			   result_i_ns[450] = out_i[23:8];
			end
			9'd392 : begin
			   result_r_ns[34] = out_r[23:8];
			   result_i_ns[34] = out_i[23:8];
			end
			9'd393 : begin
			   result_r_ns[290] = out_r[23:8];
			   result_i_ns[290] = out_i[23:8];
			end
			9'd394 : begin
			   result_r_ns[162] = out_r[23:8];
			   result_i_ns[162] = out_i[23:8];
			end
			9'd395 : begin
			   result_r_ns[418] = out_r[23:8];
			   result_i_ns[418] = out_i[23:8];
			end
			9'd396 : begin
			   result_r_ns[98] = out_r[23:8];
			   result_i_ns[98] = out_i[23:8];
			end
			9'd397 : begin
			   result_r_ns[354] = out_r[23:8];
			   result_i_ns[354] = out_i[23:8];
			end
			9'd398 : begin
			   result_r_ns[226] = out_r[23:8];
			   result_i_ns[226] = out_i[23:8];
			end
			9'd399 : begin
			   result_r_ns[482] = out_r[23:8];
			   result_i_ns[482] = out_i[23:8];
			end
			9'd400 : begin
			   result_r_ns[18] = out_r[23:8];
			   result_i_ns[18] = out_i[23:8];
			end
			9'd401 : begin
			   result_r_ns[274] = out_r[23:8];
			   result_i_ns[274] = out_i[23:8];
			end
			9'd402 : begin
			   result_r_ns[146] = out_r[23:8];
			   result_i_ns[146] = out_i[23:8];
			end
			9'd403 : begin
			   result_r_ns[402] = out_r[23:8];
			   result_i_ns[402] = out_i[23:8];
			end
			9'd404 : begin
			   result_r_ns[82] = out_r[23:8];
			   result_i_ns[82] = out_i[23:8];
			end
			9'd405 : begin
			   result_r_ns[338] = out_r[23:8];
			   result_i_ns[338] = out_i[23:8];
			end
			9'd406 : begin
			   result_r_ns[210] = out_r[23:8];
			   result_i_ns[210] = out_i[23:8];
			end
			9'd407 : begin
			   result_r_ns[466] = out_r[23:8];
			   result_i_ns[466] = out_i[23:8];
			end
			9'd408 : begin
			   result_r_ns[50] = out_r[23:8];
			   result_i_ns[50] = out_i[23:8];
			end
			9'd409 : begin
			   result_r_ns[306] = out_r[23:8];
			   result_i_ns[306] = out_i[23:8];
			end
			9'd410 : begin
			   result_r_ns[178] = out_r[23:8];
			   result_i_ns[178] = out_i[23:8];
			end
			9'd411 : begin
			   result_r_ns[434] = out_r[23:8];
			   result_i_ns[434] = out_i[23:8];
			end
			9'd412 : begin
			   result_r_ns[114] = out_r[23:8];
			   result_i_ns[114] = out_i[23:8];
			end
			9'd413 : begin
			   result_r_ns[370] = out_r[23:8];
			   result_i_ns[370] = out_i[23:8];
			end
			9'd414 : begin
			   result_r_ns[242] = out_r[23:8];
			   result_i_ns[242] = out_i[23:8];
			end
			9'd415 : begin
			   result_r_ns[498] = out_r[23:8];
			   result_i_ns[498] = out_i[23:8];
			end
			9'd416 : begin
			   result_r_ns[10] = out_r[23:8];
			   result_i_ns[10] = out_i[23:8];
			end
			9'd417 : begin
			   result_r_ns[266] = out_r[23:8];
			   result_i_ns[266] = out_i[23:8];
			end
			9'd418 : begin
			   result_r_ns[138] = out_r[23:8];
			   result_i_ns[138] = out_i[23:8];
			end
			9'd419 : begin
			   result_r_ns[394] = out_r[23:8];
			   result_i_ns[394] = out_i[23:8];
			end
			9'd420 : begin
			   result_r_ns[74] = out_r[23:8];
			   result_i_ns[74] = out_i[23:8];
			end
			9'd421 : begin
			   result_r_ns[330] = out_r[23:8];
			   result_i_ns[330] = out_i[23:8];
			end
			9'd422 : begin
			   result_r_ns[202] = out_r[23:8];
			   result_i_ns[202] = out_i[23:8];
			end
			9'd423 : begin
			   result_r_ns[458] = out_r[23:8];
			   result_i_ns[458] = out_i[23:8];
			end
			9'd424 : begin
			   result_r_ns[42] = out_r[23:8];
			   result_i_ns[42] = out_i[23:8];
			end
			9'd425 : begin
			   result_r_ns[298] = out_r[23:8];
			   result_i_ns[298] = out_i[23:8];
			end
			9'd426 : begin
			   result_r_ns[170] = out_r[23:8];
			   result_i_ns[170] = out_i[23:8];
			end
			9'd427 : begin
			   result_r_ns[426] = out_r[23:8];
			   result_i_ns[426] = out_i[23:8];
			end
			9'd428 : begin
			   result_r_ns[106] = out_r[23:8];
			   result_i_ns[106] = out_i[23:8];
			end
			9'd429 : begin
			   result_r_ns[362] = out_r[23:8];
			   result_i_ns[362] = out_i[23:8];
			end
			9'd430 : begin
			   result_r_ns[234] = out_r[23:8];
			   result_i_ns[234] = out_i[23:8];
			end
			9'd431 : begin
			   result_r_ns[490] = out_r[23:8];
			   result_i_ns[490] = out_i[23:8];
			end
			9'd432 : begin
			   result_r_ns[26] = out_r[23:8];
			   result_i_ns[26] = out_i[23:8];
			end
			9'd433 : begin
			   result_r_ns[282] = out_r[23:8];
			   result_i_ns[282] = out_i[23:8];
			end
			9'd434 : begin
			   result_r_ns[154] = out_r[23:8];
			   result_i_ns[154] = out_i[23:8];
			end
			9'd435 : begin
			   result_r_ns[410] = out_r[23:8];
			   result_i_ns[410] = out_i[23:8];
			end
			9'd436 : begin
			   result_r_ns[90] = out_r[23:8];
			   result_i_ns[90] = out_i[23:8];
			end
			9'd437 : begin
			   result_r_ns[346] = out_r[23:8];
			   result_i_ns[346] = out_i[23:8];
			end
			9'd438 : begin
			   result_r_ns[218] = out_r[23:8];
			   result_i_ns[218] = out_i[23:8];
			end
			9'd439 : begin
			   result_r_ns[474] = out_r[23:8];
			   result_i_ns[474] = out_i[23:8];
			end
			9'd440 : begin
			   result_r_ns[58] = out_r[23:8];
			   result_i_ns[58] = out_i[23:8];
			end
			9'd441 : begin
			   result_r_ns[314] = out_r[23:8];
			   result_i_ns[314] = out_i[23:8];
			end
			9'd442 : begin
			   result_r_ns[186] = out_r[23:8];
			   result_i_ns[186] = out_i[23:8];
			end
			9'd443 : begin
			   result_r_ns[442] = out_r[23:8];
			   result_i_ns[442] = out_i[23:8];
			end
			9'd444 : begin
			   result_r_ns[122] = out_r[23:8];
			   result_i_ns[122] = out_i[23:8];
			end
			9'd445 : begin
			   result_r_ns[378] = out_r[23:8];
			   result_i_ns[378] = out_i[23:8];
			end
			9'd446 : begin
			   result_r_ns[250] = out_r[23:8];
			   result_i_ns[250] = out_i[23:8];
			end
			9'd447 : begin
			   result_r_ns[506] = out_r[23:8];
			   result_i_ns[506] = out_i[23:8];
			end
			9'd448 : begin
			   result_r_ns[6] = out_r[23:8];
			   result_i_ns[6] = out_i[23:8];
			end
			9'd449 : begin
			   result_r_ns[262] = out_r[23:8];
			   result_i_ns[262] = out_i[23:8];
			end
			9'd450 : begin
			   result_r_ns[134] = out_r[23:8];
			   result_i_ns[134] = out_i[23:8];
			end
			9'd451 : begin
			   result_r_ns[390] = out_r[23:8];
			   result_i_ns[390] = out_i[23:8];
			end
			9'd452 : begin
			   result_r_ns[70] = out_r[23:8];
			   result_i_ns[70] = out_i[23:8];
			end
			9'd453 : begin
			   result_r_ns[326] = out_r[23:8];
			   result_i_ns[326] = out_i[23:8];
			end
			9'd454 : begin
			   result_r_ns[198] = out_r[23:8];
			   result_i_ns[198] = out_i[23:8];
			end
			9'd455 : begin
			   result_r_ns[454] = out_r[23:8];
			   result_i_ns[454] = out_i[23:8];
			end
			9'd456 : begin
			   result_r_ns[38] = out_r[23:8];
			   result_i_ns[38] = out_i[23:8];
			end
			9'd457 : begin
			   result_r_ns[294] = out_r[23:8];
			   result_i_ns[294] = out_i[23:8];
			end
			9'd458 : begin
			   result_r_ns[166] = out_r[23:8];
			   result_i_ns[166] = out_i[23:8];
			end
			9'd459 : begin
			   result_r_ns[422] = out_r[23:8];
			   result_i_ns[422] = out_i[23:8];
			end
			9'd460 : begin
			   result_r_ns[102] = out_r[23:8];
			   result_i_ns[102] = out_i[23:8];
			end
			9'd461 : begin
			   result_r_ns[358] = out_r[23:8];
			   result_i_ns[358] = out_i[23:8];
			end
			9'd462 : begin
			   result_r_ns[230] = out_r[23:8];
			   result_i_ns[230] = out_i[23:8];
			end
			9'd463 : begin
			   result_r_ns[486] = out_r[23:8];
			   result_i_ns[486] = out_i[23:8];
			end
			9'd464 : begin
			   result_r_ns[22] = out_r[23:8];
			   result_i_ns[22] = out_i[23:8];
			end
			9'd465 : begin
			   result_r_ns[278] = out_r[23:8];
			   result_i_ns[278] = out_i[23:8];
			end
			9'd466 : begin
			   result_r_ns[150] = out_r[23:8];
			   result_i_ns[150] = out_i[23:8];
			end
			9'd467 : begin
			   result_r_ns[406] = out_r[23:8];
			   result_i_ns[406] = out_i[23:8];
			end
			9'd468 : begin
			   result_r_ns[86] = out_r[23:8];
			   result_i_ns[86] = out_i[23:8];
			end
			9'd469 : begin
			   result_r_ns[342] = out_r[23:8];
			   result_i_ns[342] = out_i[23:8];
			end
			9'd470 : begin
			   result_r_ns[214] = out_r[23:8];
			   result_i_ns[214] = out_i[23:8];
			end
			9'd471 : begin
			   result_r_ns[470] = out_r[23:8];
			   result_i_ns[470] = out_i[23:8];
			end
			9'd472 : begin
			   result_r_ns[54] = out_r[23:8];
			   result_i_ns[54] = out_i[23:8];
			end
			9'd473 : begin
			   result_r_ns[310] = out_r[23:8];
			   result_i_ns[310] = out_i[23:8];
			end
			9'd474 : begin
			   result_r_ns[182] = out_r[23:8];
			   result_i_ns[182] = out_i[23:8];
			end
			9'd475 : begin
			   result_r_ns[438] = out_r[23:8];
			   result_i_ns[438] = out_i[23:8];
			end
			9'd476 : begin
			   result_r_ns[118] = out_r[23:8];
			   result_i_ns[118] = out_i[23:8];
			end
			9'd477 : begin
			   result_r_ns[374] = out_r[23:8];
			   result_i_ns[374] = out_i[23:8];
			end
			9'd478 : begin
			   result_r_ns[246] = out_r[23:8];
			   result_i_ns[246] = out_i[23:8];
			end
			9'd479 : begin
			   result_r_ns[502] = out_r[23:8];
			   result_i_ns[502] = out_i[23:8];
			end
			9'd480 : begin
			   result_r_ns[14] = out_r[23:8];
			   result_i_ns[14] = out_i[23:8];
			end
			9'd481 : begin
			   result_r_ns[270] = out_r[23:8];
			   result_i_ns[270] = out_i[23:8];
			end
			9'd482 : begin
			   result_r_ns[142] = out_r[23:8];
			   result_i_ns[142] = out_i[23:8];
			end
			9'd483 : begin
			   result_r_ns[398] = out_r[23:8];
			   result_i_ns[398] = out_i[23:8];
			end
			9'd484 : begin
			   result_r_ns[78] = out_r[23:8];
			   result_i_ns[78] = out_i[23:8];
			end
			9'd485 : begin
			   result_r_ns[334] = out_r[23:8];
			   result_i_ns[334] = out_i[23:8];
			end
			9'd486 : begin
			   result_r_ns[206] = out_r[23:8];
			   result_i_ns[206] = out_i[23:8];
			end
			9'd487 : begin
			   result_r_ns[462] = out_r[23:8];
			   result_i_ns[462] = out_i[23:8];
			end
			9'd488 : begin
			   result_r_ns[46] = out_r[23:8];
			   result_i_ns[46] = out_i[23:8];
			end
			9'd489 : begin
			   result_r_ns[302] = out_r[23:8];
			   result_i_ns[302] = out_i[23:8];
			end
			9'd490 : begin
			   result_r_ns[174] = out_r[23:8];
			   result_i_ns[174] = out_i[23:8];
			end
			9'd491 : begin
			   result_r_ns[430] = out_r[23:8];
			   result_i_ns[430] = out_i[23:8];
			end
			9'd492 : begin
			   result_r_ns[110] = out_r[23:8];
			   result_i_ns[110] = out_i[23:8];
			end
			9'd493 : begin
			   result_r_ns[366] = out_r[23:8];
			   result_i_ns[366] = out_i[23:8];
			end
			9'd494 : begin
			   result_r_ns[238] = out_r[23:8];
			   result_i_ns[238] = out_i[23:8];
			end
			9'd495 : begin
			   result_r_ns[494] = out_r[23:8];
			   result_i_ns[494] = out_i[23:8];
			end
			9'd496 : begin
			   result_r_ns[30] = out_r[23:8];
			   result_i_ns[30] = out_i[23:8];
			end
			9'd497 : begin
			   result_r_ns[286] = out_r[23:8];
			   result_i_ns[286] = out_i[23:8];
			end
			9'd498 : begin
			   result_r_ns[158] = out_r[23:8];
			   result_i_ns[158] = out_i[23:8];
			end
			9'd499 : begin
			   result_r_ns[414] = out_r[23:8];
			   result_i_ns[414] = out_i[23:8];
			end
			9'd500 : begin
			   result_r_ns[94] = out_r[23:8];
			   result_i_ns[94] = out_i[23:8];
			end
			9'd501 : begin
			   result_r_ns[350] = out_r[23:8];
			   result_i_ns[350] = out_i[23:8];
			end
			9'd502 : begin
			   result_r_ns[222] = out_r[23:8];
			   result_i_ns[222] = out_i[23:8];
			end
			9'd503 : begin
			   result_r_ns[478] = out_r[23:8];
			   result_i_ns[478] = out_i[23:8];
			end
			9'd504 : begin
			   result_r_ns[62] = out_r[23:8];
			   result_i_ns[62] = out_i[23:8];
			end
			9'd505 : begin
			   result_r_ns[318] = out_r[23:8];
			   result_i_ns[318] = out_i[23:8];
			end
			9'd506 : begin
			   result_r_ns[190] = out_r[23:8];
			   result_i_ns[190] = out_i[23:8];
			end
			9'd507 : begin
			   result_r_ns[446] = out_r[23:8];
			   result_i_ns[446] = out_i[23:8];
			end
			9'd508 : begin
			   result_r_ns[126] = out_r[23:8];
			   result_i_ns[126] = out_i[23:8];
			end
			9'd509 : begin
			   result_r_ns[382] = out_r[23:8];
			   result_i_ns[382] = out_i[23:8];
			end
			9'd510 : begin
			   result_r_ns[254] = out_r[23:8];
			   result_i_ns[254] = out_i[23:8];
			end
			9'd511 : begin
			   result_r_ns[510] = out_r[23:8];
			   result_i_ns[510] = out_i[23:8];
			   next_over = 1'b1; 
			end
        endcase
    end
end
endmodule
